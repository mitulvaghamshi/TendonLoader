import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/common/router/router.dart';
import 'package:tendon_loader/common/widgets/loading_widget.dart';
import 'package:tendon_loader/network/prescription.dart';
import 'package:tendon_loader/network/user.dart';
import 'package:tendon_loader/screens/web/utils/popup_action.dart';
import 'package:tendon_loader/screens/web/widgets/dismissable_tile.dart';
import 'package:tendon_loader/screens/web/widgets/search_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key /* , required this.searchList */});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchCtrl = TextEditingController();
  Iterable<User> searchList = [];

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
                  final User patient = searchList.elementAt(index);
                  return DismissableTile(
                    itemKey: patient.id.toString(),
                    barColor: const Color(0xff3ddc85),
                    title: Text(
                      patient.id.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subTitle: Text(patient.id.toString()),
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
    Iterable<User> filterList = searchList;
    if (query.isNotEmpty) {
      filterList = searchList.where((e) {
        return e.id.toString().toLowerCase().contains(query);
      });
    }
    _update(() => searchList = filterList);
  }

  Future<void> _handler(PopupAction action, User patient) async {
    PopupAction.values.where((element) => element == action);
    switch (action) {
      case PopupAction.itemTap:
        const ExportListRoute().go(context);
      case PopupAction.itemDelete:
        await patient.delete();
      case PopupAction.itemDownload:
        await patient.download();
      default:
    }
  }
}

class _PopupMenu extends StatelessWidget {
  const _PopupMenu({required this.patient});

  final User patient;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Prescription>(
      future: Future.value(const Prescription.empty()),
      builder: (_, snapshot) {
        if (!snapshot.hasData) return const LoadingWidget();
        // patient.prescription = snapshot.data;
        return PopupMenuButton<PopupAction>(
          onSelected: (action) => _onSelected(context, action, patient),
          itemBuilder: (context) {
            return <PopupMenuItem<PopupAction>>[
              // if (patient.prescription!.isAdmin)
              //   const PopupMenuItem<PopupAction>(
              //     value: PopupAction.userWebAccess,
              //     child: Text('Remove web access!'),
              //   )
              // else
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
    User patient,
  ) async {
    switch (action) {
      case PopupAction.userWebAccess:
      // patient.prescription = patient.prescription!.copyWith(
      //   isAdmin: !patient.prescription!.isAdmin,
      // );
      // await patient.prescriptionRef!.update(patient.toMap());
      case PopupAction.userExerciseHistory:
      // ExerciseHistoryRoute(userId: patient.id).go(context);
      case PopupAction.editPrescriptions:
      // NewExerciseRoute(userId: patient.id, readOnly: true).go(context);
      default:
    }
  }
}
