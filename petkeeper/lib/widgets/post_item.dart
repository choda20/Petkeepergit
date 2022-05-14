import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../providers/user_provider.dart';
import 'package:petkeeper/widgets/widget_args/post_screen_args.dart';
import 'package:petkeeper/models/post.dart';

class PostItem extends StatelessWidget {
  PostItem(this.postData, this.isEditing);
  Post postData;
  bool isEditing;

  @override
  Widget build(BuildContext context) {
    final userData =
        Provider.of<UserProvider>(context).getUserData(postData.userId);
    String postId = postData.postId;
    final _firebaseStorage =
        FirebaseStorage.instance.ref().child('images/$postId');
    return GestureDetector(
      child: FutureBuilder<String>(
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          Widget imageDisplay;
          if (snapshot.connectionState == ConnectionState.done) {
            imageDisplay = Image.network(snapshot.data.toString());
          } else {
            imageDisplay = const CircularProgressIndicator();
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 3, right: 3, left: 3),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 150,
                      width: 150,
                      child: Card(
                          child: FittedBox(
                              fit: BoxFit.fill,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: imageDisplay)))),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Row(children: [
                        GradientText(
                          postData.title,
                          colors: const [Color(0xfffe5858), Color(0xffee9617)],
                          style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        const SizedBox(width: 7),
                        Text('by ${userData.userName}',
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black)),
                      ]),
                      const SizedBox(height: 5),
                      Text('From: ' + postData.startingDate,
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 5),
                      Text('To: ' + postData.endingDate,
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 5),
                      Row(children: [
                        Text(postData.petNum.toString(),
                            style: const TextStyle(fontSize: 18)),
                        RadiantGradientMask(
                          child: const Icon(
                            Icons.pets,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ]),
                      const SizedBox(height: 5),
                      Row(children: [
                        Text(postData.salary.toString(),
                            style: const TextStyle(fontSize: 18)),
                        RadiantGradientMask(
                          child: const Icon(
                            Icons.monetization_on,
                            size: 20,
                            color: Colors.white,
                          ),
                        )
                      ]),
                    ],
                  )
                ],
              ),
            ),
          );
        },
        future: _firebaseStorage.getDownloadURL(),
      ),
      onTap: () {
        Navigator.of(context).pushNamed('/post-screen',
            arguments: PostScreenArgs(postData, isEditing));
      },
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
