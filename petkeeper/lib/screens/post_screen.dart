import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:petkeeper/models/post.dart';
import 'package:petkeeper/widgets/widget_args/chat_screen_args.dart';
import 'package:petkeeper/widgets/widget_args/post_screen_args.dart';

class PostScreen extends StatelessWidget {
  static const routename = '/post-screen';
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as PostScreenArgs;
    String imageUrl = args.postData.postImage;
    String title = args.postData.title;
    final _firebaseStorage =
        FirebaseStorage.instance.ref().child('images/$imageUrl+$title');
    return Scaffold(
      appBar: AppBar(
        title: Text(args.postData.title),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/profile-screen');
                  },
                  child: const Icon(
                    Icons.person,
                    size: 30.0,
                  ))),
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/chat-screen',
                        arguments: ChatScreenArgs(args.postData.userId,
                            FirebaseAuth.instance.currentUser!.uid));
                  },
                  child: const Icon(
                    Icons.chat_rounded,
                    size: 26.0,
                  ))),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            FutureBuilder<String>(
                future: _firebaseStorage.getDownloadURL(),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  Widget imageDisplay;
                  if (snapshot.connectionState == ConnectionState.done) {
                    imageDisplay = Image.network(snapshot.data.toString());
                  } else {
                    imageDisplay = const CircularProgressIndicator();
                  }
                  return Container(
                    height: 200,
                    width: 200,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: imageDisplay,
                      ),
                    ),
                  );
                }),
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  Container(
                    width: 190,
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      args.postData.dates,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    width: 190,
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      "Salary: " + args.postData.salary.toString() + '\$',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    width: 190,
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      "Number of pets: " + args.postData.petNum.toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ]),
          ]),
          const SizedBox(height: 20),
          const Text('Description',
              style: TextStyle(fontSize: 25, decoration: TextDecoration.none)),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Text(args.postData.description,
                  style: const TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const Expanded(
                child: Card(
                    child:
                        Text('Walks(per day)', style: TextStyle(fontSize: 18))),
              ),
              Card(
                  child: Text(args.postData.walks.toString(),
                      style: const TextStyle(fontSize: 18)))
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const Expanded(
                child: Card(
                    child: Text('Feeding(per day)',
                        style: TextStyle(fontSize: 18))),
              ),
              Card(
                  child: Text(args.postData.feeding.toString(),
                      style: const TextStyle(fontSize: 18)))
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const Expanded(
                child: Card(
                    child: Text('Watering(per day)',
                        style: TextStyle(fontSize: 18))),
              ),
              Card(
                  child: Text(args.postData.watering.toString(),
                      style: const TextStyle(fontSize: 18)))
            ],
          )
        ],
      ),
    );
  }
}
