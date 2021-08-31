import 'package:flutter/material.dart';
import 'package:tendon_loader/app_state/app_state_scope.dart';
import 'package:tendon_loader/app_state/app_state_widget.dart';
import 'package:tendon_loader/custom/app_frame.dart';
import 'package:tendon_loader/custom/progress_tile.dart';
import 'package:tendon_loader/custom/search_text_field.dart';
import 'package:tendon_loader/utils/themes.dart';
import 'package:tendon_loader/web/tiles/user_tile.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final TextEditingController _searchCtrl = TextEditingController();
  late Iterable<int> _userList = AppStateScope.of(context).userList;

  void _onSearch() {
    final Iterable<int> _filterUsers =
        AppStateWidget.of(context).filterUsers(_searchCtrl.text);
    setState(() => _userList = _filterUsers);
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
      margin: const EdgeInsets.fromLTRB(16, 16, 8, 16),
      child: SizedBox(
        width: 350,
        child: Column(children: <Widget>[
          SearchTextField(
            onSearch: _onSearch,
            controller: _searchCtrl,
            hint: 'Search patient...',
          ),
          Expanded(
            child: RefreshIndicator(
              color: colorMidGreen,
              onRefresh: () async => setState(() {
                AppStateWidget.of(context).setRefetch();
              }),
              child: FutureBuilder<void>(
                future: AppStateWidget.of(context).fetch(),
                builder: (_, AsyncSnapshot<void> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                      itemCount: _userList.length,
                      itemBuilder: (_, int index) => UserTile(
                        id: _userList.elementAt(index),
                      ),
                    );
                  }
                  return const Center(child: CustomProgress());
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
