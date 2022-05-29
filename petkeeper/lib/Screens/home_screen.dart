import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/filter.dart';
import '../providers/request_provider.dart';
import '../providers/filters_provider.dart';
import '../models/post.dart';
import '../screens/screen_args/new_post_screen_args.dart';
import '../widgets/post_item.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/AppDrawer.dart';
import '../providers/posts_provider.dart';
import '../providers/rating_provider.dart';

class homeScreen extends StatefulWidget {
  static const routename = '/home-screen';

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      print('didChange has started.');
      try {
        Provider.of<AuthProvider>(context, listen: false)
            .fetchExtraUserInfo()
            .then((value) {
          Provider.of<PostsProvider>(context, listen: false)
              .fetchPosts()
              .then((value) {
            Provider.of<RatingProvider>(context, listen: false)
                .fetchRatings()
                .then((value) {
              Provider.of<UserProvider>(context, listen: false)
                  .fetchUsersData()
                  .then((value) {
                Provider.of<RequestProvider>(context, listen: false)
                    .fetchRequests()
                    .then((value) {
                  Provider.of<FiltersProvider>(context, listen: false)
                      .resetFilters();
                  setState(() {
                    _isInit = false;
                    print('didChange has ended.');
                  });
                });
              });
            });
          });
        });
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    final filterProvider = Provider.of<FiltersProvider>(context).filter;
    final postProvider = Provider.of<PostsProvider>(context);
    final requestProvider = Provider.of<RequestProvider>(context);
    List<Post> unFilteredPosts = postProvider.getOngingPosts(postProvider.post);
    List<Post> unFilteredPostList =
        requestProvider.getPendingPosts(unFilteredPosts);
    List<Post> filteredPostList = postProvider.filterResults(
        Filter(
            filterProvider.foodValue,
            filterProvider.petsValue,
            filterProvider.walksValue,
            filterProvider.waterValue,
            filterProvider.startingSalaryValue,
            filterProvider.startingDate,
            filterProvider.endingDate),
        unFilteredPostList);
    return Scaffold(
        backgroundColor: const Color(0xffeaeaea),
        appBar: AppBar(
          flexibleSpace: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: <Color>[Color(0xfffe5858), Color(0xffee9617)]))),
          title: const Text('PetKeeper'),
        ),
        drawer: _isInit
            ? const Drawer(
                child: Center(child: CircularProgressIndicator()),
              )
            : AppDrawer(),
        floatingActionButton:
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          InkWell(
            child: ClipOval(
              child: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: <Color>[
                        Color(0xfffe5858),
                        Color(0xffee9617)
                      ])),
                  height: 60,
                  width: 60,
                  child: const Icon(Icons.refresh, color: Colors.white)),
            ),
            onTap: () {
              unFilteredPosts = postProvider.post;
              unFilteredPostList =
                  requestProvider.getPendingPosts(unFilteredPosts);
              setState(() {
                _isInit = true;
                didChangeDependencies();
              });
            },
          ),
          const SizedBox(width: 10),
          InkWell(
            child: ClipOval(
              child: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: <Color>[
                        Color(0xfffe5858),
                        Color(0xffee9617)
                      ])),
                  height: 60,
                  width: 60,
                  child: const Icon(Icons.search, color: Colors.white)),
            ),
            onTap: () {
              Navigator.of(context).pushNamed('/filters-screen');
            },
          ),
          const SizedBox(width: 10),
          InkWell(
            child: ClipOval(
              child: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: <Color>[
                        Color(0xfffe5858),
                        Color(0xffee9617)
                      ])),
                  height: 60,
                  width: 60,
                  child: const Icon(Icons.add, color: Colors.white)),
            ),
            onTap: () {
              Navigator.of(context).pushNamed('/new_post-screen',
                  arguments: NewPostScreenArgs(null, false));
              setState(() {});
            },
          ),
        ]),
        body: _isInit
            ? const Center(child: CircularProgressIndicator())
            : filteredPostList.isEmpty
                ? const Center(
                    child: Text(
                      'No listings :(',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  )
                : SizedBox.expand(
                    child: ListView.builder(
                        itemCount: filteredPostList.length,
                        padding: const EdgeInsets.only(bottom: 10, top: 10),
                        itemBuilder: (BuildContext ctx, index) {
                          return PostItem(
                              filteredPostList[index], false, false, false);
                        }),
                  ));
  }
}
