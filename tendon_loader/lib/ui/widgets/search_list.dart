import 'package:flutter/material.dart';
import 'package:tendon_loader/ui/widgets/input_factory.dart';

@immutable
class SearchList<T> extends StatefulWidget {
  const SearchList({
    super.key,
    required this.title,
    required this.searchLabel,
    required this.items,
    required this.searchTerm,
    required this.builder,
  });

  final String title;
  final String searchLabel;
  final Iterable<T> items;
  final String Function(T item) searchTerm;
  final Widget Function(T item, int index) builder;

  @override
  State<SearchList<T>> createState() => _SearchListState<T>();
}

class _SearchListState<T> extends State<SearchList<T>> {
  final _searchCtrl = TextEditingController();
  late Iterable<T> _items = widget.items;

  void _search() {
    final term = _searchCtrl.text.toLowerCase();
    if (term.isEmpty) {
      setState(() => _items = widget.items);
      return;
    }
    final filter = widget.items.where((e) {
      return widget.searchTerm(e).toLowerCase().contains(term);
    });
    setState(() => _items = filter);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar.medium(title: Text(widget.title)),
        SliverToBoxAdapter(
          child: InputFactory.search(
            onComplete: _search,
            controller: _searchCtrl,
            label: widget.searchLabel,
          ),
        ),
        SliverList.builder(
          itemCount: _items.length,
          itemBuilder: (_, index) {
            return widget.builder(_items.elementAt(index), index);
          },
        ),
      ],
    );
  }
}
