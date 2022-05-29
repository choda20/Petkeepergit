import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../models/request.dart';
import '../providers/request_provider.dart';
import '../providers/auth_provider.dart';
import '../models/user.dart';
import '../providers/posts_provider.dart';
import '../providers/user_provider.dart';
import '../screens/screen_args/post_screen_args.dart';
import '../screens/screen_args/profile_screen_args.dart';
import '../screens/screen_args/new_post_screen_args.dart';
import '../widgets/gradient_icons.dart';

class PostScreen extends StatelessWidget {
  static const routename = '/post-screen';
  @override
  Widget build(BuildContext context) {
    final request = Provider.of<RequestProvider>(context);
    final currentUserId = Provider.of<AuthProvider>(context).user.uid;
    final args = ModalRoute.of(context)!.settings.arguments as PostScreenArgs;
    User poster =
        Provider.of<UserProvider>(context).getUserData(args.postData.userId);
    String postId = args.postData.postId;

    return Scaffold(
      backgroundColor: const Color(0xffeaeaea),
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: <Color>[Color(0xfffe5858), Color(0xffee9617)]))),
        title: Text(args.postData.title),
        actions: args.isEditing && args.isAccepted == false
            ? [
                Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamed('/new_post-screen',
                              arguments: NewPostScreenArgs(
                                  args.postData, args.isEditing));
                        },
                        child: const Icon(
                          Icons.edit,
                          size: 30.0,
                        ))),
                Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: GestureDetector(
                        onTap: () {
                          Provider.of<PostsProvider>(context, listen: false)
                              .deleteListing(args.postData.postId);
                          Navigator.of(context).pop();
                        },
                        child: const Icon(
                          Icons.delete,
                          size: 26.0,
                        ))),
              ]
            : [
                Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/profile-screen',
                              arguments: ProfileScreenArgs(poster.userId));
                        },
                        child: const Icon(
                          Icons.person,
                          size: 30.0,
                        ))),
              ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(children: [
              const SizedBox(width: 5),
              Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(args.postData.downloadUrl),
                      ),
                    ),
                  )),
              const SizedBox(width: 10),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  GradientText(
                    'Posted by: ',
                    colors: const [Color(0xfffe5858), Color(0xffee9617)],
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(poster.userName,
                      style: const TextStyle(
                          fontSize: 20, color: Color.fromARGB(255, 35, 34, 34)))
                ]),
                const SizedBox(height: 9),
                Row(children: [
                  GradientText(
                    'From: ',
                    colors: const [Color(0xfffe5858), Color(0xffee9617)],
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(args.postData.startingDate,
                      style: const TextStyle(
                          fontSize: 20, color: Color.fromARGB(255, 35, 34, 34)))
                ]),
                const SizedBox(height: 9),
                Row(children: [
                  GradientText(
                    'To: ',
                    colors: const [Color(0xfffe5858), Color(0xffee9617)],
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(args.postData.endingDate,
                      style: const TextStyle(
                          fontSize: 20, color: Color.fromARGB(255, 35, 34, 34)))
                ]),
                const SizedBox(height: 9),
                Row(children: [
                  RadiantGradientMask(
                    child: const Icon(
                      Icons.monetization_on,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    " " + args.postData.salary.toString() + '\$',
                    style: const TextStyle(
                        fontSize: 20, color: Color.fromARGB(255, 35, 34, 34)),
                  ),
                ]),
                const SizedBox(height: 9),
                Row(children: [
                  RadiantGradientMask(
                    child: const Icon(
                      Icons.pets,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                  Text(' ' + args.postData.petNum.toString(),
                      style: const TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 35, 34, 34))),
                ]),
              ]),
            ]),
            const SizedBox(height: 10),
            const Text('Treatment',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 15),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              RadiantGradientMask(
                child: const Icon(
                  Icons.directions_walk_outlined,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              Text(' ' + args.postData.walks.toString() + '(per day)',
                  style: const TextStyle(
                      fontSize: 20, color: Color.fromARGB(255, 35, 34, 34))),
            ]),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              RadiantGradientMask(
                child: const Icon(
                  Icons.food_bank,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              Text(' ' + args.postData.feeding.toString() + '(per day)',
                  style: const TextStyle(
                      fontSize: 20, color: Color.fromARGB(255, 35, 34, 34))),
            ]),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              RadiantGradientMask(
                child: const Icon(
                  Icons.water_drop,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              Text(' ' + args.postData.watering.toString() + '(per day)',
                  style: const TextStyle(
                      fontSize: 20, color: Color.fromARGB(255, 35, 34, 34))),
            ]),
            const SizedBox(height: 15),
            const Text('Description',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 15),
            SingleChildScrollView(
              child: Text(args.postData.description,
                  style: const TextStyle(
                      fontSize: 20, color: Color.fromARGB(255, 35, 34, 34))),
            ),
            const SizedBox(height: 15),
            const Text('Contact information',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 15),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              RadiantGradientMask(
                child: const Icon(
                  Icons.email,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              Text(' ' + poster.email,
                  style: const TextStyle(
                      fontSize: 20, color: Color.fromARGB(255, 35, 34, 34))),
            ]),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              RadiantGradientMask(
                child: const Icon(
                  Icons.phone,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              Text(' ' + poster.phoneNumber,
                  style: const TextStyle(
                      fontSize: 20, color: Color.fromARGB(255, 35, 34, 34))),
            ]),
            const SizedBox(height: 15),
            if (currentUserId != poster.userId && !args.isFromProfileScreen)
              request.hasRequested(
                          currentUserId, poster.userId, args.postData.postId) ==
                      false
                  ? ButtonTheme(
                      child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor),
                          onPressed: () {
                            request.addRequest(Request(postId, poster.userId,
                                currentUserId, false, ''));
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.done,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Apply',
                            style: TextStyle(color: Colors.white),
                          )))
                  : const Text('Already requested',
                      style: TextStyle(
                          fontSize: 20, color: Color.fromARGB(255, 35, 34, 34)))
          ],
        ),
      ),
    );
  }
}
