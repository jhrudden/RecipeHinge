import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth/infrastructure/authentication_service.dart';
import 'auth/presentation/authenticate_screen.dart';
import 'infrastructure/overall/repositories/database.dart';
import 'presentation/home/widgets/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider(create: (_) => AuthenticationService()),
          StreamProvider(
              create: (context) =>
                  context.read<AuthenticationService>().authStateChanges)
        ],
        child: MaterialApp(
          title: "My App",
          theme: ThemeData(primarySwatch: Colors.blueGrey),
          home: AuthenticationWrapper(),
        ));
  }
}

/// Wrap Home Screen with authentication widget that verifies user is signed in
/// before proceding to home screen.
class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fireBaseUser = context.watch<User>();

    if (fireBaseUser != null) {
      return Provider<DatabaseService>(
        create: (_) => DatabaseService(uid: fireBaseUser.uid),
        child: Home(),
      );
    }

    return AuthenticateScreen();
  }
}
