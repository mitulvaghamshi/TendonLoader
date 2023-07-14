import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tendon_loader/app_user/user.dart';
import 'package:tendon_loader/common/constants.dart';
import 'package:tendon_loader/common/widgets/raw_button.dart';
import 'package:tendon_loader/router/router.dart';
import 'package:tendon_loader/screens/web/widgets/search_field.dart';

@immutable
final class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.items});

  final Iterable<User> items;

  @override
  State<HomePage> createState() => _HomePageState();
}

final class _HomePageState extends State<HomePage> {
  final _searchCtrl = TextEditingController();
  late Iterable<User> searchList = widget.items;

  void _search() {
    final term = _searchCtrl.text.toLowerCase();
    final list =
        term.isEmpty ? widget.items : widget.items.where((e) => e.match(term));
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
      SliverAppBar.large(title: const Text('Enrolled Users')),
      SliverList.builder(
        itemCount: searchList.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return SearchField(
              label: 'Search by name...',
              controller: _searchCtrl,
              onSearch: _search,
            );
          } else if (index < searchList.length + 1) {
            final user = searchList.elementAt(index - 1);
            return RawButton.tile(
              leadingToTitleSpace: 16,
              axisAlignment: MainAxisAlignment.start,
              leading: CircleAvatar(radius: 24, child: Text(index.toString())),
              trailing: IconButton(
                onPressed: () {
                  // TODO(me): Implement view to manage these options:
                  // TODO(me): Allow web access? - Switch
                  // TODO(me): Exercise History - Show screen
                  // TODO(me): Edit Prescriptions - Show screen
                },
                icon: const Icon(Icons.settings),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name, style: Styles.titleStyle),
                  Text(
                    user.username,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              onTap: () => context.push(
                const ExerciseListRoute().location,
                extra: user,
              ),
            );
          }
          return null;
        },
      ),
    ]);
  }
}
