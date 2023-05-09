import 'package:flutter/material.dart';
import 'package:tendon_loader/experimentutils.dart';
import 'package:tendon_loader/experimentwidgets/detail_widget.dart';

@immutable
class ItemWidget extends StatelessWidget {
  const ItemWidget({super.key, required this.patient});

  final Patient patient;

  @override
  Widget build(BuildContext context) {
    final names = patient.userRef?.id.split('@');
    if (names == null) throw 'Document name is null.';
    return ListTile(
      leading: CircleAvatar(child: Text(names.first[0].toUpperCase())),
      title: Text(names.first),
      subtitle: Text(names.join('@')),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => DetailWidget(item: patient),
        ),
      ),
    );
  }
}
