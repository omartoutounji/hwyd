import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hwyd/routes/hwyd_routes.dart';

import 'screens/hwyd.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: routes,
    theme: ThemeData(brightness: Brightness.light),
    darkTheme: ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
    ),
    home: const Hwyd(),
  ));
}
