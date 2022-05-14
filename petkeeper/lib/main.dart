//package imports
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petkeeper/providers/request_provider.dart';
import 'package:provider/provider.dart';
// file imports
import 'Screens/new_post_screen.dart';
import 'Screens/home_screen.dart';
import 'widgets/AppDrawer.dart';
import 'Screens/auth_screen.dart';
import './providers/user_provider.dart';
import 'package:petkeeper/screens/post_screen.dart';
import 'package:petkeeper/screens/profile_screen.dart';
import 'package:petkeeper/screens/user_listings_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/posts_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => RequestProvider()),
        ChangeNotifierProvider(create: (ctx) => AuthProvider()),
        ChangeNotifierProvider(create: (ctx) => PostsProvider()),
        ChangeNotifierProvider(create: (ctx) => UserProvider())
      ],
      child: MaterialApp(
        title: "PetKeeper",
        theme: ThemeData(primaryColor: const Color(0xffee9617)),
        home: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: <Color>[Color(0xfffe5858), Color(0xffee9617)])),
          child: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, usersnapshot) {
              if (usersnapshot.hasData) {
                return homeScreen();
              } else {
                return AuthScreen();
              }
            },
          ),
        ),
        routes: {
          AuthScreen.routename: (ctx) => AuthScreen(),
          homeScreen.routename: (ctx) => homeScreen(),
          NewPost.routename: (ctx) => NewPost(),
          ProfileScreen.routename: (ctx) => ProfileScreen(),
          PostScreen.routename: (ctx) => PostScreen(),
          UserListings.routename: (ctx) => UserListings(),
        },
      ),
    );
  }
}
