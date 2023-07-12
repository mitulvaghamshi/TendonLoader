import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/common/constants.dart';
import 'package:tendon_loader/common/router/router.dart';
import 'package:tendon_loader/common/widgets/raw_button.dart';
import 'package:tendon_loader/network/app_scope.dart';
import 'package:tendon_loader/network/exercise.dart';
import 'package:tendon_loader/screens/prompt/widgets/pain_selector.dart';

@immutable
final class PromptScreen extends StatefulWidget {
  const PromptScreen({super.key});

  @override
  PromptScreenState createState() => PromptScreenState();
}

class PromptScreenState extends State<PromptScreen> {
  late final bool _autoUpload = AppScope.of(context).api.settings.autoUpload;

  double? painScore;
  Tolerance? painTolerance;
  Submission? submitDecision;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Congratulations',
          style: TextStyle(color: Colors.green, fontSize: 26),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: WillPopScope(
            onWillPop: () async => Future<bool>.value(true),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const _CardWidget(
                  children: <Widget>[
                    Text(
                      'Exercise session completed,\nGreat work!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Please answer few questions about '
                      'this session to finish!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                _CardWidget(
                  children: <Widget>[
                    const Text(
                      '1. Pain score',
                      style: Styles.numberPickerText,
                    ),
                    const Divider(thickness: 2),
                    const Text(
                      'Please describe your '
                      'pain during that session,\n'
                      'move slider to select (0 - 10).',
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 16,
                      ),
                      child: PainSelector(onSelect: (value) {
                        setState(() => painScore = value);
                      }),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        _buildPainText(
                          '0\n\nNo\npain',
                          const Color(0xff00e676),
                        ),
                        _buildPainText(
                          '5\n\nModerate\npain',
                          const Color(0xff7f9c61),
                        ),
                        _buildPainText(
                          '10\n\nWorst\npain',
                          const Color(0xffff534d),
                        ),
                      ],
                    ),
                  ],
                ),
                _CardWidget(
                  children: <Widget>[
                    const Text(
                      '2. Pain tolerance',
                      style: Styles.numberPickerText,
                    ),
                    const Divider(thickness: 2),
                    const Text(
                      'Was the pain during that '
                      'session tolerable for you?',
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RawButton.icon(
                          color: painTolerance == Tolerance.yes
                              ? Colors.blueGrey
                              : null,
                          left: const Icon(Icons.check),
                          right: Text(Tolerance.yes.value),
                          onTap: () =>
                              setState(() => painTolerance = Tolerance.yes),
                        ),
                        const SizedBox(width: 5),
                        RawButton.icon(
                          color: painTolerance == Tolerance.no
                              ? Colors.blueGrey
                              : null,
                          left: const Icon(Icons.clear),
                          right: Text(Tolerance.no.value),
                          onTap: () =>
                              setState(() => painTolerance = Tolerance.no),
                        ),
                        const SizedBox(width: 5),
                        RawButton.icon(
                          color: painTolerance == Tolerance.noPain
                              ? Colors.blueGrey
                              : null,
                          left: const Icon(Icons.remove),
                          right: Text(Tolerance.noPain.value),
                          onTap: () =>
                              setState(() => painTolerance = Tolerance.noPain),
                        ),
                      ],
                    ),
                  ],
                ),
                if (!_autoUpload)
                  _CardWidget(children: <Widget>[
                    const Text(
                      '3. Submit data?',
                      style: Styles.numberPickerText,
                    ),
                    const Divider(thickness: 2),
                    const Text(
                      'Would you like to submit your answers '
                      'and Exercise/MVC Test data to clinician?',
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      tileColor: submitDecision == Submission.now
                          ? Colors.blueGrey
                          : null,
                      leading: const Icon(Icons.cloud_upload,
                          color: Color(0xff3ddc85)),
                      title: Text(Submission.now.value),
                      onTap: () =>
                          setState(() => submitDecision = Submission.now),
                    ),
                    ListTile(
                      tileColor: submitDecision == Submission.leter
                          ? Colors.blueGrey
                          : null,
                      leading: const Icon(Icons.save, color: Color(0xffe18f3c)),
                      title: Text(Submission.leter.value),
                      onTap: () =>
                          setState(() => submitDecision = Submission.leter),
                    ),
                    ListTile(
                      tileColor: submitDecision == Submission.discard
                          ? Colors.blueGrey
                          : null,
                      leading:
                          const Icon(Icons.clear, color: Color(0xffff534d)),
                      title: Text(Submission.discard.value),
                      onTap: () =>
                          setState(() => submitDecision = Submission.discard),
                    ),
                  ]),
                const Divider(thickness: 2),
                _CardWidget(children: <Widget>[
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: ((_autoUpload ||
                                submitDecision == Submission.discard) ||
                            painScore != null && painTolerance != null)
                        ? RawButton.icon(
                            onTap: _onFinished,
                            left: const Icon(Icons.check),
                            right: const Text('Finish'),
                          )
                        : const Text(
                            'Please answer all three questions to finish.'),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension on PromptScreenState {
  Widget _buildPainText(String text, Color color) {
    return SizedBox(
      width: 80,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
          letterSpacing: 1,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Future<void> _onFinished() async {
    final Exercise export = AppScope.of(context).api.excercise;

    // export.painScore ??= painScore;
    // export.isTolerable ??= painTolerance?.value;

    if (_autoUpload) {
      if (!((await Connectivity().checkConnectivity()) !=
          ConnectivityResult.none)) await export.upload();
    } else {
      switch (submitDecision) {
        case Submission.now:
          await export.upload();
          break;
        case Submission.discard:
          break;
        case Submission.leter:
        default:
          break;
      }
    }

    if (mounted) const HomeScreenRoute().go(context);
  }
}

enum Tolerance {
  yes('Yes'),
  no('No'),
  noPain('No Pain');

  const Tolerance(this.value);

  final String value;
}

enum Submission {
  now('Okay, submit now'),
  leter('Save, and ask me leter'),
  discard('No, discard this session');

  const Submission(this.value);

  final String value;
}

class _CardWidget extends StatelessWidget {
  const _CardWidget({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(children: children),
      ),
    );
  }
}
