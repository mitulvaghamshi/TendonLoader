import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/custom/custom_progress.dart';
import 'package:tendon_loader/screens/web/user_tile.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final TextEditingController _userCtrl = TextEditingController();
  final TextEditingController _exportCtrl = TextEditingController();
  late Iterable<int> _userList = context.model.getUserList();

  void _handleUserSearch() {
    _userList = context.model.filter(filter: _userCtrl.text);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.fromLTRB(16, 16, 8, 16),
      child: SizedBox(
        width: 350,
        child: Column(children: <Widget>[
          Row(children: <Widget>[
            Expanded(
              child: TextField(
                controller: _userCtrl,
                onSubmitted: (_) => _handleUserSearch(),
                decoration: InputDecoration(
                  hintText: 'Search user',
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: _handleUserSearch,
                  ),
                ),
              ),
            ),
            Expanded(
              child: TextField(
                controller: _exportCtrl,
                onSubmitted: (_) => _handleUserSearch(),
                decoration: InputDecoration(
                  hintText: 'Search export',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _userCtrl.clear();
                      _exportCtrl.clear();
                    },
                  ),
                ),
              ),
            ),
          ]),
          const SizedBox(height: 10),
          Expanded(
            child: RefreshIndicator(
              color: colorGoogleGreen,
              onRefresh: () async => context
                ..model.reload()
                ..view.refresh(),
              child: FutureBuilder<void>(
                future: context.model.fetch(),
                builder: (_, AsyncSnapshot<void> snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) return const CustomProgress();
                  return ListView.separated(
                    itemCount: _userList.length,
                    separatorBuilder: (_, __) => const Divider(height: 0),
                    itemBuilder: (_, int index) => UserTile(
                      id: _userList.elementAt(index),
                      filter: _exportCtrl.text,
                    ),
                  );
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
