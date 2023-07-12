import 'package:flutter/material.dart';
import 'package:tendon_loader/screens/web/utils/popup_action.dart';

class DismissableTile extends StatelessWidget {
  const DismissableTile({
    super.key,
    required this.itemKey,
    required this.barColor,
    required this.title,
    required this.subTitle,
    required this.trailing,
    required this.handler,
  });

  final String itemKey;
  final Color barColor;
  final Widget title;
  final Widget subTitle;
  final Widget trailing;
  final void Function(PopupAction) handler;

  @override
  Widget build(BuildContext context) {
    const TextStyle textStyle = TextStyle(color: Colors.white);
    return Dismissible(
      key: ValueKey<String>(itemKey),
      dismissThresholds: const <DismissDirection, double>{
        DismissDirection.endToStart: 0.9,
      },
      background: Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.centerLeft,
        color: const Color(0xff3ddc85),
        child: const Text('Download all', style: textStyle),
      ),
      secondaryBackground: Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.centerRight,
        color: const Color(0xFFDC3D3D),
        child: const Text('Delete', style: textStyle),
      ),
      confirmDismiss: (direction) => _onDismiss(context, direction),
      child: ListTile(
        minLeadingWidth: 10,
        onTap: () => handler(PopupAction.itemTap),
        contentPadding: const EdgeInsets.fromLTRB(5, 0, 16, 0),
        leading: VerticalDivider(width: 5, thickness: 5, color: barColor),
        title: title,
        subtitle: subTitle,
        trailing: trailing,
      ),
    );
  }
}

extension on DismissableTile {
  Future<bool?> _onDismiss(
      BuildContext context, DismissDirection direction) async {
    if (direction == DismissDirection.endToStart) {
      bool delete = true;
      ScaffoldMessenger.of(context).showMaterialBanner(_makeBanner(() {
        delete = false;
        ScaffoldMessenger.maybeOf(context)?.clearMaterialBanners();
      }));
      return Future<bool>.delayed(const Duration(seconds: 5), () {
        ScaffoldMessenger.maybeOf(context)?.clearMaterialBanners();
        if (delete) handler(PopupAction.itemDelete);
        return delete;
      });
    } else if (direction == DismissDirection.startToEnd) {
      handler(PopupAction.itemDownload);
      return false;
    }
    return null;
  }

  MaterialBanner _makeBanner(VoidCallback action) {
    return MaterialBanner(
      content: const Text('Item will be deleted soon!'),
      actions: <Widget>[
        TextButton(onPressed: action, child: const Text('Undo')),
      ],
    );
  }
}
