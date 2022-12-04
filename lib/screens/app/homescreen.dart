import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tendon_loader/common/constants.dart';
import 'package:tendon_loader/common/router/router.dart';
import 'package:tendon_loader/common/widgets/image_widget.dart';
import 'package:tendon_loader/screens/bluetooth/connected_list.dart';
import 'package:tendon_loader/screens/bluetooth/models/bluetooth_handler.dart';
import 'package:tendon_loader/screens/bluetooth/models/simulator.dart';
import 'package:tendon_loader/screens/exercise/exercise_mode.dart';
import 'package:tendon_loader/screens/graph/models/graph_handler.dart';
import 'package:tendon_loader/screens/livedata/live_data.dart';
import 'package:tendon_loader/screens/mvctest/mvc_testing.dart';
import 'package:tendon_loader/screens/settings/models/app_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with Progressor {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tendon Loader'),
        actions: <Widget>[
          FloatingActionButton(
            heroTag: 'menu-open-settings-tag',
            backgroundColor: Colors.transparent,
            elevation: 0,
            onPressed: () => const SettingScreenRoute().go(context),
            child: const Icon(Icons.settings),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'connect-device-tag',
        icon: const Icon(Icons.bluetooth),
        label: const Text('Connect Device'),
        onPressed: _connectProgressor,
      ),
      body: SingleChildScrollView(
        child: WillPopScope(
          onWillPop: () async => disconnect().then((_) => true),
          child: Column(children: <Widget>[
            const ImageWidget(),
            ListTile(
              contentPadding: Styles.tilePadding,
              leading: const Icon(Icons.show_chart),
              title: const Text(LiveData.name),
              trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: () => _navigateTo(LiveData.name),
            ),
            ListTile(
              contentPadding: Styles.tilePadding,
              leading: const Icon(Icons.airline_seat_legroom_extra),
              title: const Text(MVCTesting.name),
              trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: () => _navigateTo(MVCTesting.name),
            ),
            ListTile(
              contentPadding: Styles.tilePadding,
              leading: const Icon(Icons.directions_run),
              title: const Text(ExerciseMode.name),
              trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: () => _navigateTo(ExerciseMode.name),
            ),
          ]),
        ),
      ),
    );
  }
}

extension on HomeScreenState {
  Future<void> _navigateTo(String route) async {
    if (!Simulator.useSimulator && progressor == null) _connectProgressor();
    switch (route) {
      case LiveData.name:
        const LiveDataRoute().go(context);
        break;
      case MVCTesting.name:
        const NewMVCTestRoute().go(context);
        break;
      case ExerciseMode.name:
        NewExerciseRoute(
          userId: AppState.of(context).getCurrentUserId(),
          readOnly: false,
        ).go(context);
        break;
    }
  }

  Future<void> _connectProgressor() async {
    await showDialog<void>(
      context: context,
      builder: (_) => const ConnectedList(),
    ).then((_) async => stopProgressor().then((_) => GraphHandler.clear()));
  }
}
