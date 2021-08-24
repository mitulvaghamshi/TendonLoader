import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/app_state/app_state_widget.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_dialog.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/custom/custom_progress.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';
import 'package:tendon_loader/web/common.dart';
import 'package:tendon_loader/web/user_tile.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final TextEditingController _userCtrl = TextEditingController();
  final TextEditingController _exportCtrl = TextEditingController();
  late Iterable<int> _userList = AppStateWidget.of(context).userList;

  void _onSearch() {
    final Iterable<int> _filter = AppStateWidget.of(context).filter(
      filter: _userCtrl.text,
    );
    setState(() => _userList = _filter);
  }

  Future<void> _onDelete(VoidCallback onDelete) async {
    return showDialog<void>(
      context: context,
      builder: (_) => CustomDialog(
        title: 'Delete export(s)?',
        content: CustomButton(
          onPressed: () {
            onDelete();
            context.pop();
            clickNotifier.value = null;
            setState(() => _userList = AppStateWidget.of(context).userList);
          },
          radius: 8,
          color: colorRed900,
          left: const Icon(Icons.delete, color: colorWhite),
          right: const Text(
            'Permanently delete',
            style: TextStyle(color: colorWhite),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _userCtrl.dispose();
    _exportCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        width: 350,
        child: Column(children: <Widget>[
          Row(children: <Widget>[
            Expanded(
              child: TextField(
                controller: _userCtrl,
                onSubmitted: (_) => _onSearch(),
                decoration: InputDecoration(
                  hintText: 'Search user',
                  prefixIcon: IconButton(
                    onPressed: _onSearch,
                    icon: const Icon(Icons.search),
                  ),
                ),
              ),
            ),
            Expanded(
              child: TextField(
                controller: _exportCtrl,
                onSubmitted: (_) => _onSearch(),
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
              onRefresh: () async => setState(() {
                AppStateWidget.of(context).setRefetch();
              }),
              child: FutureBuilder<void>(
                future: AppStateWidget.of(context).fetch(),
                builder: (_, AsyncSnapshot<void> snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const CustomProgress();
                  }
                  return ListView.separated(
                    itemCount: _userList.length,
                    separatorBuilder: (_, __) => const Divider(height: 0),
                    itemBuilder: (_, int index) => UserTile(
                      id: _userList.elementAt(index),
                      filter: _exportCtrl.text,
                      onDelete: _onDelete,
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
