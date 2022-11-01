// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import '../Pagination/infiniteScroll.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  LocalAuthentication localAuthentication = LocalAuthentication();

  @override
  void initState() {
    checkBiometric().then((hasSensor) {
      print("has_sensor");
    });
    super.initState();
  }

  bool? canScan;
  Future<dynamic> checkBiometric() async {
    canScan = await localAuthentication.canCheckBiometrics;
    authenticate();
  }

  void authenticate() async {
    bool didAuthenticate = false;
    didAuthenticate = await localAuthentication.authenticate(
        localizedReason: "please Authenticate",
        options: const AuthenticationOptions(
          stickyAuth: true,
          useErrorDialogs: true,
        ));
    if (didAuthenticate) {
      {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => InfiniteScrollPaginatorDemo()),
            (Route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
              onPressed: () {
                authenticate();
              },
              child: Text("     START     "))),
    );
  }
}
