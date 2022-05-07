import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:petkeeper/screens/post_screen.dart';
import 'package:petkeeper/widgets/widget_args/post_screen_args.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../providers/auth_provider.dart';
import 'package:petkeeper/models/post.dart';

class PostItem extends StatelessWidget {
  PostItem(this.postData, this.isEditing);
  Post postData;
  bool isEditing;
  @override
  Widget build(BuildContext context) {
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
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Text(postData.title,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 7),
                        Text(postData.dates,
                            style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 7),
                        const Divider(
                          color: Colors.black,
                        ),
                        Row(
                          children: [
                            Column(
                              children: [
                                Text(postData.petNum.toString(),
                                    style: const TextStyle(fontSize: 16)),
                                const Text('Number of pets',
                                    style: TextStyle(fontSize: 17))
                              ],
                            ),
                            const SizedBox(width: 25),
                            Column(
                              children: [
                                Text(postData.salary.toString() + '\$',
                                    style: const TextStyle(fontSize: 16)),
                                const Text('Salary',
                                    style: TextStyle(fontSize: 17))
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
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
