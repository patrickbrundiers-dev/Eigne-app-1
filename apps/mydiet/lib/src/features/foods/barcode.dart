import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../app.dart';
import '../../core/food_quality.dart';
import '../../data/database.dart';
import '../../data/off_client.dart';
import '../../ui/widgets.dart';
import 'food_form_page.dart';

/// Replaced in tests.
OffClient Function() offClientFactory = OffClient.new;

/// Camera scanning on Android, iOS and the web; on Windows a field for typing the code
/// or for a USB barcode scanner (which types like a keyboard).
bool get cameraScanSupported =>
    debugCameraScan ??
    (kIsWeb || defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS);

/// Set to false in widget tests (no camera plugin there).
@visibleForTesting
bool? debugCameraScan;

/// Scans a barcode and returns the food for it: from the local database (works offline),
/// else from Open Food Facts after the user checked the values, else a new empty food
/// with the barcode. Returns null when cancelled.
Future<Food?> scanFood(BuildContext context) async {
  final code = await Navigator.push<String>(context, MaterialPageRoute(builder: (_) => const BarcodeScanPage()));
  if (code == null || !context.mounted) return null;
  return resolveBarcode(context, code);
}

Future<Food?> resolveBarcode(BuildContext context, String code) async {
  final db = context.db;
  final local = await db.findFoodByBarcode(code);
  if (local != null) return local;
  if (!context.mounted) return null;
  showMessage(context, 'Suche $code bei Open Food Facts …');
  OffProduct? product;
  String? problem;
  try {
    product = await offClientFactory().fetch(code);
  } on OffException catch (e) {
    problem = e.message;
  }
  if (!context.mounted) return null;
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  if (product == null) {
    showMessage(
      context,
      problem ?? 'Produkt $code ist bei Open Food Facts nicht bekannt. Bitte Werte vom Etikett eingeben.',
    );
  }
  final id = await Navigator.push<String>(
    context,
    MaterialPageRoute(
      builder: (_) => FoodFormPage(prefill: product, initialBarcode: code),
    ),
  );
  if (id == null || !context.mounted) return null;
  return db.getFood(id);
}

class BarcodeScanPage extends StatefulWidget {
  const BarcodeScanPage({super.key});

  @override
  State<BarcodeScanPage> createState() => _BarcodeScanPageState();
}

class _BarcodeScanPageState extends State<BarcodeScanPage> {
  final _c = TextEditingController();
  MobileScannerController? _scanner;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    if (cameraScanSupported) {
      _scanner = MobileScannerController(
        formats: const [BarcodeFormat.ean13, BarcodeFormat.ean8, BarcodeFormat.upcA, BarcodeFormat.upcE],
      );
    }
  }

  @override
  void dispose() {
    _c.dispose();
    _scanner?.dispose();
    super.dispose();
  }

  void _finish(String raw) {
    final code = raw.replaceAll(RegExp(r'\s'), '');
    if (_done || !isValidGtin(code)) return;
    _done = true;
    Navigator.pop(context, code);
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final typed = _c.text.replaceAll(RegExp(r'\s'), '');
    final valid = isValidGtin(typed);
    return Scaffold(
      appBar: AppBar(title: const Text('Barcode scannen')),
      body: Column(
        children: [
          if (cameraScanSupported)
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  MobileScanner(
                    controller: _scanner,
                    onDetect: (capture) {
                      for (final b in capture.barcodes) {
                        final v = b.rawValue;
                        if (v != null && isValidGtin(v)) {
                          _finish(v);
                          return;
                        }
                      }
                    },
                    errorBuilder: (context, error) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'Kamera nicht verfügbar (${error.errorCode.name}). Bitte Kamerazugriff erlauben oder '
                          'den Code unten eintippen.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 260,
                      height: 140,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 3),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!cameraScanSupported)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      'Code eintippen oder mit einem USB-Barcodescanner einlesen.',
                      style: t.textTheme.bodyLarge,
                    ),
                  ),
                TextField(
                  controller: _c,
                  autofocus: !cameraScanSupported,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Barcode (EAN)',
                    errorText: typed.isNotEmpty && typed.length >= 8 && !valid ? 'Prüfziffer passt nicht' : null,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      tooltip: 'Suchen',
                      onPressed: valid ? () => _finish(typed) : null,
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                  onSubmitted: _finish,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
