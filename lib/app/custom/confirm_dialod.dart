import 'package:tendon_loader/libs.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({Key key, this.sessionInfo, this.prescription}) : super(key: key);

  final SessionInfo sessionInfo;
  final Prescription prescription;

  static Future<bool> export(BuildContext context, {SessionInfo sessionInfo, Prescription prescription}) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Submit data to Clinician?', textAlign: TextAlign.center),
        content: ConfirmDialog(sessionInfo: sessionInfo, prescription: prescription),
        actions: <Widget>[TextButton(onPressed: () => Navigator.pop(context), child: const Text('Back'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          title: const Text('Submit now'),
          contentPadding: const EdgeInsets.symmetric(vertical: 5),
          leading: const Icon(Icons.circle, color: Colors.green, size: 50),
          subtitle: const Text('Send data to the cloud. Requires an active internet connection.'),
          onTap: () {
            ExportHandler.export(sessionInfo, prescription);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Uploading...')));
            Navigator.of(context).pop(true);
          },
        ),
        ListTile(
          title: const Text('Ask me later'),
          contentPadding: const EdgeInsets.symmetric(vertical: 5),
          leading: const Icon(Icons.circle, color: Colors.yellow, size: 50),
          subtitle: const Text('Save data locally on device and submit later (manual action required).'),
          onTap: () {
            ExportHandler.export(sessionInfo, prescription, true);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saving...')));
            Navigator.of(context).pop(true);
          },
        ),
        ListTile(
          title: const Text('Discard!'),
          contentPadding: const EdgeInsets.symmetric(vertical: 5),
          leading: const Icon(Icons.circle, color: Colors.red, size: 50),
          subtitle: const Text('(Attention!) Destroy data without submitting (cannot be recovered).'),
          onTap: () => Navigator.pop<bool>(context, false),
        ),
      ],
    );
  }
}
