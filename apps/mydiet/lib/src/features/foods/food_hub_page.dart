import 'package:material_ui/material_ui.dart';

import '../home_shell.dart';
import '../plan/plan_view.dart';
import '../recipes/recipes_view.dart';
import '../recipes/shopping_view.dart';
import '../supplements/supplements_view.dart';
import 'foods_page.dart';

/// "Essen" tab: foods, recipes, weekly plan, shopping list and supplements.
class FoodHubPage extends StatelessWidget {
  const FoodHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Essen'),
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: 'Lebensmittel'),
              Tab(text: 'Rezepte'),
              Tab(text: 'Wochenplan'),
              Tab(text: 'Einkauf'),
              Tab(text: 'Supplemente'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PageBody(maxWidth: 900, child: FoodsPage(embedded: true)),
            PageBody(maxWidth: 900, child: RecipesView()),
            // The weekly plan uses the full width on the PC: days side by side.
            PageBody(maxWidth: 1800, child: PlanView()),
            PageBody(maxWidth: 900, child: ShoppingView()),
            PageBody(maxWidth: 900, child: SupplementsView()),
          ],
        ),
      ),
    );
  }
}
