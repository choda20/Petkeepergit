import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/posts_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../screens/screen_args/profile_screen_args.dart';
import '../widgets/post_item.dart';
import '../widgets/gradient_icons.dart';
import '../models/rating.dart';
import '../providers/rating_provider.dart';
import '../widgets/rating_item.dart';

class ProfileScreen extends StatefulWidget {
  static const routename = '/profile-screen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _choosenData =
      0; // 0 = post, 1 == post ratings , 2 = job ratings, 3 = info
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ProfileScreenArgs;
    final currentUId = Provider.of<AuthProvider>(context).user.uid;
    final userData =
        Provider.of<UserProvider>(context).getUserData(args.userId);
    final postProvider = Provider.of<PostsProvider>(context);
    final userPostList = postProvider.getUserPosts(args.userId);
    final postList = Provider.of<PostsProvider>(context).post;
    final ratingProvider = Provider.of<RatingProvider>(context);
    final ratingList = ratingProvider.getUserRatings(args.userId);
    final postRatings = ratingList
        .where((element) =>
            element.ratedBy != userData.userId &&
            userData.userId == element.poster)
        .toList();
    final jobRatings = ratingList
        .where((element) =>
            element.careTaker == userData.userId &&
            element.ratedBy != userData.userId)
        .toList();
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: const Color(0xffee9617),
            selectedIconTheme: const IconThemeData(color: Colors.white),
            currentIndex: _choosenData,
            onTap: (int index) {
              setState(() {
                _choosenData = index;
              });
            },
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: RadiantGradientMask(child: const Icon(Icons.feed)),
                  label: 'Posts'),
              BottomNavigationBarItem(
                  icon: RadiantGradientMask(child: const Icon(Icons.star)),
                  label: 'Post ratings'),
              BottomNavigationBarItem(
                  icon: RadiantGradientMask(child: const Icon(Icons.star)),
                  label: 'Job ratings'),
              BottomNavigationBarItem(
                  icon: RadiantGradientMask(
                      child: const Icon(Icons.contact_mail)),
                  label: 'Contact information')
            ]),
        backgroundColor: const Color(0xffeaeaea),
        appBar: AppBar(
            title: currentUId == args.userId
                ? const Text('Your profile')
                : Text(userData.userName + 's profile'),
            flexibleSpace: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: <Color>[
                  Color(0xfffe5858),
                  Color(0xffee9617)
                ])))),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            CircleAvatar(
                radius: 100,
                backgroundImage: NetworkImage(userData.downloadurl)),
            const SizedBox(height: 20),
            Expanded(
                child: _choosenData == 3
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
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(' ' + userData.phoneNumber,
                                    style: const TextStyle(
                                        fontSize: 25,
                                        color:
                                            Color.fromARGB(255, 35, 34, 34))),
                              ]),
                          const SizedBox(height: 20),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RadiantGradientMask(
                                  child: const Icon(
                                    Icons.email,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(' ' + userData.email,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color:
                                            Color.fromARGB(255, 35, 34, 34))),
                              ]),
                        ],
                      )
                    : _choosenData == 0 && userPostList.isEmpty
                        ? Center(
                            child: Text(
                              '${userData.userName} has not posted any listings yet.',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 20),
                            ),
                          )
                        : _choosenData == 1 && postRatings.isNotEmpty
                            ? ListView.builder(
                                padding: const EdgeInsets.all(10),
                                itemCount: postRatings.length,
                                itemBuilder: (BuildContext ctx, index) {
                                  return RatingItem(
                                      postRatings[index],
                                      postList.firstWhere((element) =>
                                          element.postId ==
                                          postRatings[index].postId));
                                })
                            : _choosenData == 2 && jobRatings.isNotEmpty
                                ? ListView.builder(
                                    padding: const EdgeInsets.all(10),
                                    itemCount: jobRatings.length,
                                    itemBuilder: (BuildContext ctx, index) {
                                      return RatingItem(
                                          jobRatings[index],
                                          postList.firstWhere((element) =>
                                              element.postId ==
                                              jobRatings[index].postId));
                                    })
                                : _choosenData == 1 && postRatings.isEmpty
                                    ? Center(
                                        child: Text(
                                          '${userData.userName} has not recived any ratings for his posts yet.',
                                          style: const TextStyle(fontSize: 20),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    : _choosenData == 2 && jobRatings.isEmpty
                                        ? Center(
                                            child: Text(
                                              '${userData.userName} has not recived any ratings for his jobs yet.',
                                              style:
                                                  const TextStyle(fontSize: 20),
                                              textAlign: TextAlign.center,
                                            ),
                                          )
                                        : ListView.builder(
                                            padding: const EdgeInsets.all(10),
                                            itemBuilder:
                                                (BuildContext ctx, index) {
                                              return PostItem(
                                                  userPostList[index],
                                                  false,
                                                  true,
                                                  false);
                                            },
                                            itemCount: userPostList.length))
          ],
        ));
  }
}
