import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../providers/request_provider.dart';
import '../screens/screen_args/post_screen_args.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../widgets/gradient_icons.dart';

class PostItem extends StatelessWidget {
  PostItem(
      this.postData, this.isEditing, this.isRequestRelevant, this.isAccepted);
  Post postData;
  bool isEditing;
  bool isRequestRelevant;
  bool isAccepted;
  @override
  Widget build(BuildContext context) {
    String careTakerId = '';
    late User careTakerData;
    if (isAccepted) {
      careTakerId =
          Provider.of<RequestProvider>(context).getCareTakerId(postData.postId);
      careTakerData =
          Provider.of<UserProvider>(context).getUserData(careTakerId);
    }
    final userData =
        Provider.of<UserProvider>(context).getUserData(postData.userId);
    final currentUser = Provider.of<AuthProvider>(context).user.uid;
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  height: 160,
                  width: 150,
                  child: Card(
                      child: FittedBox(
                          fit: BoxFit.fill,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(postData.downloadUrl))))),
              const SizedBox(width: 3),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    FittedBox(
                      child: GradientText(
                        postData.title,
                        colors: const [Color(0xfffe5858), Color(0xffee9617)],
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 7),
                    currentUser == postData.userId
                        ? const SizedBox()
                        : Row(children: [
                            Flexible(
                              child: Text('by ${userData.userName}',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 18)),
                            ),
                          ]),
                    isAccepted ? const SizedBox(height: 5) : const SizedBox(),
                    isAccepted
                        ? Row(children: [
                            const Text('Taken care of by: ',
                                style: TextStyle(fontSize: 18)),
                            Flexible(
                              child: GradientText(careTakerData.userName,
                                  overflow: TextOverflow.ellipsis,
                                  colors: const [
                                    Color(0xfffe5858),
                                    Color(0xffee9617)
                                  ],
                                  style: const TextStyle(fontSize: 18)),
                            )
                          ])
                        : const SizedBox(),
                    const SizedBox(height: 2),
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
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context).pushNamed('/post-screen',
            arguments: PostScreenArgs(
                postData, isEditing, isRequestRelevant, isAccepted));
      },
    );
  }
}
