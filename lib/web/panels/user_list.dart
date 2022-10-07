/// MIT License
/// 
/// Copyright (c) 2021 Mitul Vaghamshi
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.
import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/app_frame.dart';
import 'package:tendon_loader/custom/progress_tile.dart';
import 'package:tendon_loader/custom/search_text_field.dart';
import 'package:tendon_loader/utils/themes.dart';
import 'package:tendon_loader/web/app_state/app_state_scope.dart';
import 'package:tendon_loader/web/app_state/app_state_widget.dart';
import 'package:tendon_loader/web/tiles/user_tile.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  UserListState createState() => UserListState();
}

class UserListState extends State<UserList> {
  final TextEditingController _searchCtrl = TextEditingController();
  late Iterable<int> _userList = AppStateScope.of(context).userList;

  void _onSearch() {
    final Iterable<int> searchResult =
        AppStateWidget.of(context).filterUsers(_searchCtrl.text);
    setState(() => _userList = searchResult);
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
