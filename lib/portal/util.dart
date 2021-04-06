import 'package:url_launcher/url_launcher.dart';

Future<void> openLink(String url) async {
  if (await canLaunch(url)) await launch(url, webOnlyWindowName: 'Tendon Loader');
}
