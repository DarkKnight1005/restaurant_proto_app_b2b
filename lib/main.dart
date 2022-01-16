import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_proto_app_b2b/notifiers.dart/account_notifier.dart';
import 'package:restaurant_proto_app_b2b/notifiers.dart/home_notifier.dart';
import 'package:restaurant_proto_app_b2b/notifiers.dart/ordered_notifier.dart';
import 'package:restaurant_proto_app_b2b/pages/home.dart';
import 'package:restaurant_proto_app_b2b/services/main_configuration.dart';
import 'package:restaurant_proto_app_b2b/wrapper.dart';

void main() async{
  
  await MainConfiguration.configureApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AccountNotifier()),
        ChangeNotifierProvider(create: (context) => HomeNotifier()),
        ChangeNotifierProvider(create: (context) => OrderNotifier()),
      ],
      child: const MyApp()
    ),
    );
}

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Wrapper(),
    );
  }
}