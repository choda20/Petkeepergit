//package imports
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petkeeper/models/post.dart';
import 'package:petkeeper/deprecated/chat_list_screen.dart';
import 'package:petkeeper/deprecated/chat_screen.dart';
import 'package:petkeeper/screens/post_screen.dart';
import 'package:petkeeper/screens/profile_screen.dart';
import 'package:petkeeper/screens/user_listings_screen.dart';
import 'package:provider/provider.dart';
// file imports
import 'Screens/new_post_screen.dart';
import 'Screens/home_screen.dart';
import 'widgets/AppDrawer.dart';
import 'Screens/auth_screen.dart';
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
        ChangeNotifierProvider(create: (ctx) => AuthProvider()),
        ChangeNotifierProvider(create: (ctx) => PostsProvider())
      ],
      child: MaterialApp(
        title: "PetKeeper",
        home: Container(
          decoration: const BoxDecoration(
            gradient: (LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color.fromRGBO(102, 102, 255, 80),
                  Color.fromRGBO(102, 178, 255, 20)
                ])),
          ),
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
          ChatScreen.routename: (ctx) => ChatScreen(),
          ChatListScreen.routename: (ctx) => ChatListScreen(),
          UserListings.routename: (ctx) => UserListings(),
        },
      ),
    );
  }
}
