import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tendon_loader/custom/custom_themes.dart';
import 'package:tendon_loader/custom/routes.dart';
import 'package:tendon_loader/handler/user.dart';

void main() {
  runApp(MultiProvider(
    providers: <ChangeNotifierProvider<User>>[ChangeNotifierProvider<User>(create: (_) => User())],
    child: const TendonLoader(),
  ));
}

class TendonLoader extends StatelessWidget {
  const TendonLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: routes,
      theme: lightTheme,
      darkTheme: darkTheme,
      title: 'Tendon Loader',
      initialRoute: Navigator.defaultRouteName,
    );
  }
}
