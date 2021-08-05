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
  final TextEditingController _searchCtrl = TextEditingController();
  late Iterable<String> _userList = context.model.getUserList();
  final FocusNode _focusNode = FocusNode();
  bool _isUser = true;

  void _handleUserSearch() {
    _focusNode.unfocus();
    _userList = context.model.filter(filter: _isUser ? _searchCtrl.text : null);
    setState(() {});
  }

  void _toggleSerach() {
    setState(() => _isUser = !_isUser);
  }

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.fromLTRB(16, 16, 8, 16),
      child: SizedBox(
        width: 340,
        child: Column(
          children: <Widget>[
            TextField(
              autofocus: true,
              focusNode: _focusNode,
              controller: _searchCtrl,
              onSubmitted: (_) => _handleUserSearch(),
              decoration: InputDecoration(
                hintText: _isUser ? 'Search user' : 'Search export',
                prefixIcon: IconButton(icon: const Icon(Icons.search), onPressed: _handleUserSearch),
                suffixIcon: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  IconButton(icon: const Icon(Icons.swap_horiz), onPressed: _toggleSerach),
                  IconButton(icon: const Icon(Icons.close), onPressed: _searchCtrl.clear),
                ]),
              ),
            ),
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
                        filter: _searchCtrl.text,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
