import 'package:flutter/material.dart';
import 'package:tendon_loader/components/custom_textfield.dart';
import 'package:tendon_loader/utils/constants.dart';
import 'package:tendon_loader/utils/validator.dart';

class Content extends StatefulWidget {
  const Content({Key/*?*/ key}) : super(key: key);

  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Content> with ValidateSearchMixin {
  final TextEditingController _searchMvcCtrl = TextEditingController();
  final TextEditingController _searchExerciseCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchExerciseCtrl.dispose();
    _searchMvcCtrl.dispose();
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ColumnX(keya: 'exercise', controller: _searchExerciseCtrl, validator: validateSearchQuery),
            ColumnX(keya: 'mvc', controller: _searchMvcCtrl, validator: validateSearchQuery),
          ],
        ),
      ),
    );
  }
}

class ColumnX extends StatefulWidget {
  const ColumnX({Key/*?*/ key, this.controller, this.validator, this.keya}) : super(key: key);

  final TextEditingController/*?*/ controller;
  final String Function(String)/*?*/ validator;
  final String/*?*/ keya;

  @override
  _ColumnXState createState() => _ColumnXState();
}

class _ColumnXState extends State<ColumnX> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeFactor.sizeAside,
      child: Column(
        children: <Widget>[
          CustomTextField(label: 'Search Exercise', controller: widget.controller, validator: widget.validator, hint: 'Enter date'),
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
                  key: Key('${widget.keya}exerciseItemKey-$index'),
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
    );
  }
}
