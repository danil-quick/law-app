import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:law_app/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset('configurations');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter FunsTrans App',
      theme: ThemeData(
        primaryColor: Colors.green
      ),
      initialRoute: '/',
      routes: routes,
    );
  }
}
