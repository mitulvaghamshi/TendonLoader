import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tendon_loader/common/constants.dart';
import 'package:tendon_loader/common/models/export.dart';
import 'package:tendon_loader/common/models/patient.dart';
import 'package:tendon_loader/common/models/prescription.dart';
import 'package:tendon_loader/common/widgets/image_widget.dart';
import 'package:tendon_loader/common/widgets/loading_widget.dart';
import 'package:tendon_loader/common/widgets/no_result_widget.dart';
import 'package:tendon_loader/screens/app/homescreen.dart';
import 'package:tendon_loader/screens/exercise/exercise_mode.dart';
import 'package:tendon_loader/screens/exercise/models/exercise_handler.dart';
import 'package:tendon_loader/screens/exercise/new_exercise.dart';
import 'package:tendon_loader/screens/livedata/live_data.dart';
import 'package:tendon_loader/screens/livedata/models/livedata_handler.dart';
import 'package:tendon_loader/screens/mvctest/models/mvc_handler.dart';
import 'package:tendon_loader/screens/mvctest/mvc_testing.dart';
import 'package:tendon_loader/screens/mvctest/new_mvc_test.dart';
import 'package:tendon_loader/screens/prompt/prompt_screen.dart';
import 'package:tendon_loader/screens/settings/models/app_state.dart';
import 'package:tendon_loader/screens/settings/settings_screen.dart';
import 'package:tendon_loader/screens/signin/signin.dart';
import 'package:tendon_loader/screens/web/export_list.dart';
import 'package:tendon_loader/screens/web/export_view.dart';
import 'package:tendon_loader/screens/web/homepage.dart';
import 'package:tendon_loader/screens/web/widgets/exercise_history.dart';
import 'package:tendon_loader/screens/web/widgets/session_info.dart';

part 'router.g.dart';

const TypedGoRoute<SettingScreenRoute> settings =
    TypedGoRoute<SettingScreenRoute>(path: 'settings');

const TypedGoRoute<HomeScreenRoute> app = TypedGoRoute<HomeScreenRoute>(
  path: 'app',
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<LiveDataRoute>(path: 'live-data'),
    TypedGoRoute<MVCTestingRoute>(path: 'mvc-testing'),
    TypedGoRoute<NewMVCTestRoute>(path: 'new-mvc-test'),
    TypedGoRoute<ExerciseModeRoute>(path: 'exercise-mode'),
    TypedGoRoute<NewExerciseRoute>(path: 'new-exercise/:userId/:readOnly'),
    TypedGoRoute<PromptScreenRoute>(path: 'prompt-screen/:key'),
  ],
);

const TypedGoRoute<HomePageRoute> web = TypedGoRoute<HomePageRoute>(
  path: 'web',
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<ExportListRoute>(path: 'exports/:userId'),
    TypedGoRoute<ExportViewRoute>(path: 'export-view'),
    TypedGoRoute<SessionInfoRoute>(path: 'session-info'),
    TypedGoRoute<ExerciseHistoryRoute>(path: 'exercise-history/:userId'),
  ],
);

@TypedGoRoute<TendonLoaderRoute>(
  path: '/',
  routes: <TypedGoRoute<GoRouteData>>[app, web, settings],
)
@immutable
class TendonLoaderRoute extends GoRouteData {
  const TendonLoaderRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return Scaffold(
      body: SignIn(
        builder: (BuildContext context, User user) => Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const ImageWidget(maxSize: 200),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FloatingActionButton.extended(
                  heroTag: 'signin-patient-tag',
                  icon: const Icon(Icons.person),
                  label: const Text('Patient'),
                  onPressed: () => const HomeScreenRoute().go(context),
                ),
                FloatingActionButton.extended(
                  heroTag: 'signin-clinician-tag',
                  icon: const Icon(Icons.medical_services),
                  label: const Text('Clinician'),
                  onPressed: () => const HomePageRoute().go(context),
                ),
              ],
            ),
            FloatingActionButton.extended(
              heroTag: 'open-settings-tag',
              backgroundColor: Colors.indigo,
              icon: const Icon(Icons.settings),
              label: const Text('Settings'),
              onPressed: () => const SettingScreenRoute().go(context),
            ),
          ],
        ),
      ),
    );
  }
}

@immutable
class SettingScreenRoute extends GoRouteData {
  const SettingScreenRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsScreen();
}

@immutable
class HomeScreenRoute extends GoRouteData {
  const HomeScreenRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
}

@immutable
class LiveDataRoute extends GoRouteData {
  const LiveDataRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return LiveData(handler: LiveDataHandler(context: context));
  }
}

@immutable
class NewMVCTestRoute extends GoRouteData {
  const NewMVCTestRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final String userId = AppState.of(context).getCurrentUserId();
    final DocumentReference<Prescription>? reference =
        Patient.of(userId).prescriptionRef;
    if (reference == null) throw 'Prescription reference is null';
    return FutureBuilder<DocumentSnapshot<Prescription>>(
      future: reference.get(),
      builder: (_, AsyncSnapshot<DocumentSnapshot<Prescription>> snapshot) {
        if (!snapshot.hasData) return const Center(child: LoadingWidget());
        final Prescription? prescription = snapshot.data!.data();
        if (prescription == null) throw 'Prescription is null';
        return NewMVCTest(duration: prescription.mvcDuration);
      },
    );
  }
}

@immutable
class MVCTestingRoute extends GoRouteData {
  const MVCTestingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return MVCTesting(
      handler: MVCHandler(
        context: context,
        mvcDuration: AppState.of(context).getLastMvcDuration(),
      ),
    );
  }
}

@immutable
class NewExerciseRoute extends GoRouteData {
  const NewExerciseRoute({required this.userId, required this.readOnly});

  final String userId;
  final bool readOnly;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final DocumentReference<Prescription>? reference =
        Patient.of(userId).prescriptionRef;
    if (reference == null) throw 'Prescription reference is null';
    return FutureBuilder<DocumentSnapshot<Prescription>>(
      future: reference.get(),
      builder: (_, AsyncSnapshot<DocumentSnapshot<Prescription>> snapshot) {
        if (!snapshot.hasData) return const Center(child: LoadingWidget());
        final Prescription? prescription = snapshot.data!.data();
        if (prescription == null) throw 'Prescription is null';
        return NewExercise(
          readOnly: readOnly,
          prescription: prescription,
          onSubmit: (Prescription prescription) {
            if (readOnly) {
              reference.update(prescription.toMap());
              context.pop();
            } else {
              const ExerciseModeRoute().go(context);
            }
          },
        );
      },
    );
  }
}

@immutable
class ExerciseModeRoute extends GoRouteData {
  const ExerciseModeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ExerciseMode(
      handler: ExerciseHandler(
        context: context,
        prescription: AppState.of(context).getLastPrescription(),
      ),
    );
  }
}

@immutable
class PromptScreenRoute extends GoRouteData {
  const PromptScreenRoute({required this.key});

  final String key;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PromptScreen(exportKey: key);
  }
}

@immutable
class HomePageRoute extends GoRouteData {
  const HomePageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return FutureBuilder<QuerySnapshot<Patient>>(
      future: _dataStore.where(FieldPath.documentId).get(),
      builder: (_, AsyncSnapshot<QuerySnapshot<Patient>> snapshot) {
        if (!snapshot.hasData) return const Center(child: LoadingWidget());
        final Iterable<Patient> data = snapshot.data!.docs
            .map((QueryDocumentSnapshot<Patient> e) => e.data());
        return HomePage(searchList: data);
      },
    );
  }
}

@immutable
class ExerciseHistoryRoute extends GoRouteData {
  const ExerciseHistoryRoute({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return FutureBuilder<QuerySnapshot<Export>>(
      future: Patient.of(userId).exportRef!.get(),
      builder: (_, AsyncSnapshot<QuerySnapshot<Export>> snapshot) {
        if (!snapshot.hasData) return const Center(child: LoadingWidget());
        final Iterable<Export> data = snapshot.data!.docs
            .map((QueryDocumentSnapshot<Export> e) => e.data());
        final Iterable<Export> list = data.where((Export e) => !e.isMVC);
        if (list.isEmpty) {
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(middle: Text(userId)),
            child: const Center(child: NoResultWidget()),
          );
        }
        return ExerciseHistory(exerciseList: list);
      },
    );
  }
}

@immutable
class ExportListRoute extends GoRouteData {
  const ExportListRoute({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return FutureBuilder<QuerySnapshot<Export>>(
      future: Patient.of(userId).exportRef!.get(),
      builder: (_, AsyncSnapshot<QuerySnapshot<Export>> snapshot) {
        if (!snapshot.hasData) return const Center(child: LoadingWidget());
        final Iterable<Export> data = snapshot.data!.docs
            .map((QueryDocumentSnapshot<Export> e) => e.data());
        return ExportList(title: userId, searchList: data);
      },
    );
  }
}

@immutable
class ExportViewRoute extends GoRouteData {
  const ExportViewRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const ExportView();
}

@immutable
class SessionInfoRoute extends GoRouteData {
  const SessionInfoRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SessionInfo();
}

CollectionReference<Patient> get _dataStore => FirebaseFirestore.instance
    .collection(DataKeys.rootCollection)
    .withConverter<Patient>(
        fromFirestore: Patient.fromJson,
        toFirestore: (Patient value, _) => value.toMap());
