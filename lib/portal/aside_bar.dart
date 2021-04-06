import 'package:flutter/material.dart';
import 'package:tendon_loader/components/custom_textfield.dart';
import 'package:tendon_loader/utils/validator.dart';

class AsideBar extends StatefulWidget {
  const AsideBar({Key/*?*/ key}) : super(key: key);

  @override
  _AsideBarState createState() => _AsideBarState();
}

class _AsideBarState extends State<AsideBar> with ValidateSearchMixin {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      return Card(
      elevation: 16,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            CustomTextField(label: 'Search user', controller: _searchCtrl, validator: validateSearchQuery, hint: 'Enter username'),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: 30,
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(color: Theme.of(context).accentColor, thickness: 1);
                },
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    key: Key('itemKeya-$index'),
                    confirmDismiss: (DismissDirection directions) {
                      return Future<bool>.delayed(const Duration(seconds: 2), () => false);
                    },
                    child: ListTile(
                      onTap: () {},
                      title: Text('Item-[$index]'),
                      subtitle: const Text('Some descriptions.'),
                      leading: const Icon(Icons.favorite_border_rounded),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*

          const Divider(color: Colors.white, thickness: 2),
ExpansionTile(
            title: const Text('Tendon Loader'),
            expandedAlignment: Alignment.topLeft,
            childrenPadding: const EdgeInsets.all(10),
            subtitle: const Text('Tap for more info...'),
            leading: const Icon(Icons.favorite, color: Colors.red),
            children: [
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('mitulvaghmashi@gmail.com'),
                onTap: () => openLink('mailto:mitulvaghmashi@gmail.com'),
              ),
            ],
          ),*/
