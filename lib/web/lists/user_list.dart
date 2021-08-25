import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/app_state/app_state_widget.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/custom/custom_progress.dart';
import 'package:tendon_loader/utils/themes.dart';
import 'package:tendon_loader/web/tiles/user_tile.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  static _UserListState of(BuildContext context) {
    return context.findAncestorStateOfType<_UserListState>()!;
  }

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final TextEditingController _searchCtrl = TextEditingController();
  late Iterable<int> _userList = AppStateWidget.of(context).userList;

  void _onSearch([String? value]) {
    final Iterable<int> _filterList = AppStateWidget.of(context).filter(
      filter: _searchCtrl.text,
    );
    setState(() => _userList = _filterList);
  }

  void refresh() {
    setState(() => _userList = AppStateWidget.of(context).userList);
  }

  @override
  void dispose() {
    super.dispose();
    _searchCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      padding: EdgeInsets.zero,
      child: SizedBox(
        width: 350,
        child: Column(children: <Widget>[
          TextField(
            controller: _searchCtrl,
            onSubmitted: _onSearch,
            decoration: InputDecoration(
              hintText: 'Search user',
              prefixIcon: IconButton(
                onPressed: _onSearch,
                icon: const Icon(Icons.search),
              ),
              suffixIcon: IconButton(
                onPressed: _searchCtrl.clear,
                icon: const Icon(Icons.clear),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              color: colorGoogleGreen,
              onRefresh: () async => setState(() {
                AppStateWidget.of(context).setRefetch();
              }),
              child: FutureBuilder<void>(
                future: AppStateWidget.of(context).fetch(),
                builder: (_, AsyncSnapshot<void> snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const CustomProgress();
                  }
                  return ListView.builder(
                    itemCount: _userList.length,
                    itemBuilder: (_, int index) => UserTile(
                      id: _userList.elementAt(index),
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
