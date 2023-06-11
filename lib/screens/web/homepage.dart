import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/common/models/patient.dart';
import 'package:tendon_loader/common/models/prescription.dart';
import 'package:tendon_loader/common/router/router.dart';
import 'package:tendon_loader/common/widgets/loading_widget.dart';
import 'package:tendon_loader/screens/web/utils/popup_action.dart';
import 'package:tendon_loader/screens/web/widgets/dismissable_tile.dart';
import 'package:tendon_loader/screens/web/widgets/search_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.searchList});

  final Iterable<Patient> searchList;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchCtrl = TextEditingController();
  late Iterable<Patient> searchList = widget.searchList;

  void _update(VoidCallback action) => setState(action);

  @override
  void dispose() {
    super.dispose();
    _searchCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        semanticChildCount: searchList.length,
        slivers: <Widget>[
          const CupertinoSliverNavigationBar(
            heroTag: 'homepage-nav',
            padding: EdgeInsetsDirectional.zero,
            largeTitle: Text('Clinician portal'),
          ),
          SliverSafeArea(
            top: false,
            minimum: const EdgeInsets.all(8),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((_, index) {
                if (index == 0) {
                  return SearchField(
                      onSearch: _search, controller: _searchCtrl);
                } else if (index < searchList.length) {
                  final Patient patient = searchList.elementAt(index);
                  return DismissableTile(
                    itemKey: patient.id,
                    barColor: const Color(0xff3ddc85),
                    title: Text(
                      patient.id.split('@').first,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subTitle: Text(patient.id),
                    trailing: _PopupMenu(patient: patient),
                    handler: (action) => _handler(action, patient),
                  );
                }
                return null;
              }),
            ),
          ),
        ],
      ),
    );
  }
}

extension on _HomePageState {
  void _search() {
    final String query = _searchCtrl.text.toLowerCase();
    Iterable<Patient> filterList = widget.searchList;
    if (query.isNotEmpty) {
      filterList = widget.searchList.where((e) {
        return e.id.toLowerCase().contains(query);
      });
    }
    _update(() => searchList = filterList);
  }

  Future<void> _handler(PopupAction action, Patient patient) async {
    PopupAction.values.where((element) => element == action);
    switch (action) {
      case PopupAction.itemTap:
        ExportListRoute(userId: patient.id).go(context);
        break;
      case PopupAction.itemDelete:
        await patient.delete();
        break;
      case PopupAction.itemDownload:
        await patient.download();
        break;
      default:
        break;
    }
  }
}

class _PopupMenu extends StatelessWidget {
  const _PopupMenu({required this.patient});

  final Patient patient;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Prescription>>(
      future: patient.prescriptionRef!.get(),
      builder: (_, snapshot) {
        if (!snapshot.hasData) return const LoadingWidget();
        patient.prescription = snapshot.data!.data();
        return PopupMenuButton<PopupAction>(
          onSelected: (action) => _onSelected(context, action, patient),
          itemBuilder: (context) {
            return <PopupMenuItem<PopupAction>>[
              if (patient.prescription!.isAdmin)
                const PopupMenuItem<PopupAction>(
                  value: PopupAction.userWebAccess,
                  child: Text('Remove web access!'),
                )
              else
                const PopupMenuItem<PopupAction>(
                  value: PopupAction.userWebAccess,
                  child: Text('Allow web access?'),
                ),
              const PopupMenuItem<PopupAction>(
                value: PopupAction.userExerciseHistory,
                child: Text('Exercise History'),
              ),
              const PopupMenuItem<PopupAction>(
                value: PopupAction.editPrescriptions,
                child: Text('Edit Prescriptions'),
              ),
            ];
          },
        );
      },
    );
  }
}

extension on _PopupMenu {
  Future<void> _onSelected(
    BuildContext context,
    PopupAction action,
    Patient patient,
  ) async {
    switch (action) {
      case PopupAction.userWebAccess:
        patient.prescription = patient.prescription!
            .copyWith(isAdmin: !patient.prescription!.isAdmin);
        await patient.prescriptionRef!.update(patient.toMap());
        break;
      case PopupAction.userExerciseHistory:
        ExerciseHistoryRoute(userId: patient.id).go(context);
        break;
      case PopupAction.editPrescriptions:
        NewExerciseRoute(userId: patient.id, readOnly: true).go(context);
        break;
      default:
        break;
    }
  }
}
