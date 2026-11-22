import 'package:material_ui/material_ui.dart';

import '../home_shell.dart';
import '../recipes/recipes_view.dart';
import '../recipes/shopping_view.dart';
import 'foods_page.dart';

/// "Essen" tab: foods, recipes and shopping list.
class FoodHubPage extends StatelessWidget {
  const FoodHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Essen'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Lebensmittel'),
              Tab(text: 'Rezepte'),
              Tab(text: 'Einkauf'),
            ],
          ),
        ),
        body: const PageBody(
          maxWidth: 900,
          child: TabBarView(children: [FoodsPage(embedded: true), RecipesView(), ShoppingView()]),
        ),
      ),
    );
  }
}
