import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_proto_app_b2b/notifiers.dart/account_notifier.dart';
import 'package:restaurant_proto_app_b2b/pages/home.dart';
import 'package:restaurant_proto_app_b2b/pages/intro.dart';
import 'package:restaurant_proto_app_b2b/widgets/Loading.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    AccountNotifier accountNotifier = Provider.of<AccountNotifier>(context);

    return FutureBuilder(
      future: accountNotifier.isLogedIn,
      // initialData: InitialData,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.data!){
            return Home();
          }else{
            return IntroScreen();
          }
        }else{
          return Loading();
        }
        
      },
    );
  }
}