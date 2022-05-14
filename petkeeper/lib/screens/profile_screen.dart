import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:petkeeper/widgets/post_item.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/posts_provider.dart';

import 'package:petkeeper/providers/auth_provider.dart';
import 'package:petkeeper/providers/user_provider.dart';
import 'package:petkeeper/widgets/widget_args/profile_screen_args.dart';

class ProfileScreen extends StatefulWidget {
  static const routename = '/profile-screen';
  int choosenData = 0; // 0 = post, 1 == rating , 2 = info
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ProfileScreenArgs;
    final CurrentUId = Provider.of<AuthProvider>(context).user.uid;
    final userData =
        Provider.of<UserProvider>(context).getUserData(args.userId);
    final postProvider = Provider.of<PostsProvider>(context);
    final url = FirebaseStorage.instance
        .refFromURL(
            'gs://petkeeper-7a537.appspot.com/profilePictures/${userData.userId}')
        .getDownloadURL();
    final postList = postProvider.getUserPosts(args.userId);
    int builderLength = 5;
    return Scaffold(
      backgroundColor: const Color(0xffeaeaea),
      appBar: AppBar(
          title: CurrentUId == args.userId
              ? const Text('Your profile')
              : Text(userData.userName + 's profile'),
          flexibleSpace: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: <Color>[Color(0xfffe5858), Color(0xffee9617)])))),
      body: FutureBuilder(
          future: url,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            Widget imageDisplay;
            if (snapshot.connectionState == ConnectionState.done) {
              imageDisplay = Image.network(
                snapshot.data.toString(),
                fit: BoxFit.cover,
              );
            } else {
              imageDisplay = const CircularProgressIndicator();
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                ClipOval(
                    child:
                        SizedBox(height: 175, width: 175, child: imageDisplay)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonTheme(
                        child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor),
                            onPressed: () {
                              setState(() {
                                widget.choosenData = 0;
                              });
                            },
                            icon: const Icon(Icons.feed),
                            label: const Text('Posts'))),
                    const SizedBox(width: 20),
                    ButtonTheme(
                        child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor),
                            onPressed: () {
                              setState(() {
                                widget.choosenData = 1;
                              });
                            },
                            icon: const Icon(Icons.star),
                            label: const Text('Ratings'))),
                    const SizedBox(width: 20),
                    ButtonTheme(
                        child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor),
                            onPressed: () {
                              setState(() {
                                widget.choosenData = 2;
                              });
                            },
                            icon: const Icon(Icons.contact_mail),
                            label: const Text('Contact')))
                  ],
                ),
                Expanded(
                    child: widget.choosenData == 2
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RadiantGradientMask(
                                      child: const Icon(
                                        Icons.phone,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(' ' + userData.phoneNumber,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            color: Color.fromARGB(
                                                255, 35, 34, 34))),
                                  ]),
                              const SizedBox(height: 20),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RadiantGradientMask(
                                      child: const Icon(
                                        Icons.email,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(' ' + userData.email,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            color: Color.fromARGB(
                                                255, 35, 34, 34))),
                                  ]),
                            ],
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(5),
                            itemBuilder: (BuildContext ctx, index) {
                              if (widget.choosenData == 0) {
                                return postList.isEmpty
                                    ? Text(
                                        '${userData.userName} has not posted any listings yet.')
                                    : PostItem(postList[index], false);
                              }
                              if (widget.choosenData == 1) {
                                return const Text('rating');
                              }
                              return const Text("Error");
                            },
                            itemCount: widget.choosenData == 0
                                ? postList.length
                                : builderLength))
              ],
            );
          }),
    );
  }
}

class RadiantGradientMask extends StatelessWidget {
  RadiantGradientMask({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const RadialGradient(
        center: Alignment.topCenter,
        radius: 1,
        colors: [Color(0xfffe5858), Color(0xffee9617)],
        tileMode: TileMode.mirror,
      ).createShader(bounds),
      child: child,
    );
  }
}
