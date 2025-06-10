import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:statement_handle/models/post.dart';

class SearchComponent extends StatelessWidget {
  final List<Post> allPosts;
  final TextEditingController searchController;
  final ValueChanged<Post> onPostSelected;

  const SearchComponent({
    Key? key,
    required this.allPosts,
    required this.searchController,
    required this.onPostSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0),
      child: Autocomplete<Post>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return const Iterable<Post>.empty();
          }
          return allPosts.where((Post post) {
            return post.title.toLowerCase().contains(textEditingValue.text.toLowerCase());
          });
        },
        onSelected: onPostSelected, // Usa a função recebida via construtor

        fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
          // O Autocomplete precisa gerenciar seu próprio controller,
          // mas o listener na MainScreen ainda funcionará, pois o texto será o mesmo.
          searchController.value = textEditingController.value;

          return TextField(
            controller: textEditingController,
            focusNode: focusNode,
            decoration: const InputDecoration(
              hintText: 'Buscar produto...',
              prefixIcon: Icon(LucideIcons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(3.0)),
              ),
            ),
          );
        },

        optionsViewBuilder: (context, onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 4.0,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 250),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Post option = options.elementAt(index);
                    return InkWell(
                      onTap: () {
                        onSelected(option);
                      },
                      child: ListTile(
                        leading: Image.network(option.image, width: 40, height: 40, fit: BoxFit.cover),
                        title: Text(option.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}