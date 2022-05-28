import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../widgets/gradient_icons.dart';
import '../widgets/request_item.dart';
import '../providers/request_provider.dart';
import '../widgets/post_item.dart';
import '../providers/posts_provider.dart';

class UserListings extends StatefulWidget {
  static const routename = '/listings-screen';

  @override
  State<UserListings> createState() => _UserListingsState();
}

class _UserListingsState extends State<UserListings> {
  int _choosenData = 0;
  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    final unfilteredposts =
        Provider.of<PostsProvider>(context).getUserPosts(uid);
    final posts =
        Provider.of<RequestProvider>(context).getPendingPosts(unfilteredposts);
    final releventPendingPosts =
        Provider.of<PostsProvider>(context).getOngingPosts(posts);
    final experiedPendingPosts =
        Provider.of<PostsProvider>(context).getPastPosts(posts);

    final acceptedRequests =
        Provider.of<RequestProvider>(context).getAcceptedApplications(uid);
    final acceptedRequetsPostIds = Provider.of<RequestProvider>(context)
        .getAcceptedApplicationsPostIds(uid);
    final acceptedRequestsPosts = Provider.of<PostsProvider>(context)
        .getPostsById(acceptedRequetsPostIds);

    final pendingRequests =
        Provider.of<RequestProvider>(context).getPendingApplications(uid);
    final pendingRequetsPostIds = Provider.of<RequestProvider>(context)
        .getPendingApplicationsPostIds(uid);
    final pendingRequestsPosts =
        Provider.of<PostsProvider>(context).getPostsById(pendingRequetsPostIds);

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
                  icon: RadiantGradientMask(
                      child: const Icon(Icons.feed_outlined)),
                  label: 'Listings'),
              BottomNavigationBarItem(
                  icon: RadiantGradientMask(
                      child: const Icon(Icons.content_paste_off)),
                  label: 'Expired Listings'),
              BottomNavigationBarItem(
                  icon: RadiantGradientMask(
                      child: const Icon(Icons.work_outline)),
                  label: 'Hired'),
              BottomNavigationBarItem(
                  icon: RadiantGradientMask(
                      child: const Icon(Icons.badge_outlined)),
                  label: 'Applications'),
            ]),
        appBar: AppBar(
            title: const Text('Your listings'),
            flexibleSpace: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: <Color>[
                  Color(0xfffe5858),
                  Color(0xffee9617)
                ])))),
        body: _choosenData == 0 && releventPendingPosts.isNotEmpty
            ? ListView.builder(
                itemCount: releventPendingPosts.length,
                padding: const EdgeInsets.only(bottom: 10, top: 10),
                itemBuilder: (BuildContext ctx, index) {
                  return PostItem(
                      releventPendingPosts[index], true, false, false);
                })
            : _choosenData == 0 && releventPendingPosts.isEmpty
                ? const Center(
                    child: Text(
                      'You have not posted any listings.',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  )
                : _choosenData == 1 && experiedPendingPosts.isNotEmpty
                    ? ListView.builder(
                        itemCount: experiedPendingPosts.length,
                        padding: const EdgeInsets.only(bottom: 10, top: 10),
                        itemBuilder: (BuildContext ctx, index) {
                          return PostItem(
                              experiedPendingPosts[index], false, false, false);
                        })
                    : _choosenData == 1 && experiedPendingPosts.isEmpty
                        ? const Center(
                            child: Text(
                              'You have no expired listings.',
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : _choosenData == 2 && acceptedRequests.isNotEmpty
                            ? SizedBox.expand(
                                child: ListView.builder(
                                    itemCount: acceptedRequests.length,
                                    padding: const EdgeInsets.only(
                                        bottom: 10, top: 10),
                                    itemBuilder: (BuildContext ctx, index) {
                                      return RequestItem(
                                          acceptedRequestsPosts[index],
                                          acceptedRequests[index],
                                          true,
                                          true);
                                    }),
                              )
                            : _choosenData == 2 && acceptedRequests.isEmpty
                                ? const Center(
                                    child: Text(
                                      'You have not hired a petkeeper yet.',
                                      style: TextStyle(fontSize: 20),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : _choosenData == 3 && pendingRequests.isEmpty
                                    ? const Center(
                                        child: Text(
                                          'You have no pending applications.',
                                          style: TextStyle(fontSize: 20),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    : SizedBox.expand(
                                        child: ListView.builder(
                                            itemCount: pendingRequests.length,
                                            padding: const EdgeInsets.only(
                                                bottom: 10, top: 10),
                                            itemBuilder:
                                                (BuildContext ctx, index) {
                                              return RequestItem(
                                                  pendingRequestsPosts[index],
                                                  pendingRequests[index],
                                                  false,
                                                  false);
                                            }),
                                      ));
  }
}
