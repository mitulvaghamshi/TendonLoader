import 'package:flutter/material.dart';
import 'package:tendon_loader/ui/widgets/input_field.dart';

@immutable
class SearchListBuilder<T> extends StatefulWidget {
  const SearchListBuilder({
    super.key,
    required this.title,
    required this.searchLabel,
    required this.items,
    required this.searchField,
    required this.builder,
  });

  final String title;
  final String searchLabel;
  final Iterable<T> items;
  final String Function(T item) searchField;
  final Widget Function(T item, int index) builder;

  @override
  State<SearchListBuilder<T>> createState() => _SearchListBuilderState<T>();
}

class _SearchListBuilderState<T> extends State<SearchListBuilder<T>> {
  final _searchCtrl = TextEditingController();
  late Iterable<T> searchList = widget.items;

  void _search() {
    final term = _searchCtrl.text.toLowerCase();
    final Iterable<T> list = term.isEmpty
        ? widget.items
        : widget.items
            .where((e) => widget.searchField(e).toLowerCase().contains(term));
    setState(() => searchList = list);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      SliverAppBar.large(title: Text(widget.title)),
      SliverList.builder(
        itemCount: searchList.length + 1,
        itemBuilder: (context, index) => index == 0
            ? InputField.search(
                label: widget.searchLabel,
                controller: _searchCtrl,
                onComplete: _search,
              )
            : widget.builder(
                searchList.elementAt(index - 1),
                index,
              ),
      ),
    ]);
  }
}
