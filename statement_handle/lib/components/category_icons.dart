import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class CategoryIcons extends StatelessWidget {
  final List<String> categories;

  // Callback para notificar o widget pai quando uma categoria for clicada
  final ValueChanged<String> onCategorySelected;

  const CategoryIcons({
    Key? key,
    required this.categories,
    required this.onCategorySelected,
  }) : super(key: key);

  // Função para mapear o nome da categoria para o ícone correspondente
  IconData _getIconForCategory(String categoryName) {
    switch (categoryName) {
      case "electronics":
        return LucideIcons.washing_machine;
      case "jewelery":
        return LucideIcons.gem;
      case "men's clothing":
        return LucideIcons.shirt;
      case "women's clothing":
        return LucideIcons.spade;
      default:
        return LucideIcons
            .tag;
    }
  }

  String _formatCategoryName(String name) {
    if (name.isEmpty) return "";
    return name[0].toUpperCase() + name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: categories.map((category) {
          return InkWell(
            onTap: () => onCategorySelected(category),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getIconForCategory(category),
                    size: 24,
                    color: Theme
                        .of(context)
                        .colorScheme
                        .primary,
                  ),
                  const SizedBox(height: 4),
                  // Texto
                  SizedBox(
                    width: 70,
                    child: Text(
                      _formatCategoryName(category),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}