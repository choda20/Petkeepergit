import 'package:flutter/material.dart';
import 'package:petkeeper/providers/request_provider.dart';
import 'package:provider/provider.dart';

import 'package:petkeeper/models/post.dart';
import 'package:petkeeper/widgets/post_item.dart';
import 'package:petkeeper/widgets/widget_args/new_post_screen_args.dart';
import '../widgets/post_item.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/AppDrawer.dart';
import '../providers/posts_provider.dart';

class homeScreen extends StatefulWidget {
  static const routename = '/home-screen';

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  int _dropDownWaterValue = 0;
  @override
  bool _isLoading = true;
  @override
  void didChangeDependencies() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<AuthProvider>(context, listen: false)
        .fetchExtraUserInfo();
    await Provider.of<PostsProvider>(context, listen: false).fetchPosts();
    await Provider.of<UserProvider>(context, listen: false).fetchUsersData();
    await Provider.of<RequestProvider>(context, listen: false).fetchRequests();
    super.didChangeDependencies();
    setState(() {
      _isLoading = false;
    });
  }

  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final postProvider = Provider.of<PostsProvider>(context);
    List<Post> postList = postProvider.post;
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
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      postList = postProvider.post;
                    });
                  },
                  child: const Icon(
                    Icons.refresh,
                    size: 26.0,
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                  onTap:
                      () {}, // implement a connection between the GetsureDetector and the filter_drawer/provider.
                  child: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                          child: Row(children: [
                        const Text('Watering(per day)'),
                        DropdownButton<int>(
                            style: const TextStyle(
                                color: Colors.blue, fontSize: 17),
                            underline: Container(height: 2, color: Colors.blue),
                            value: _dropDownWaterValue,
                            items: <int>[0, 1, 2, 3, 4, 5, 6]
                                .map<DropdownMenuItem<int>>((int value) {
                              return DropdownMenuItem<int>(
                                child: Text(value.toString()),
                                value: value,
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _dropDownWaterValue = newValue!;
                              });
                            }),
                      ]))
                    ],
                  )),
            )
          ],
        ),
        drawer: AppDrawer(),
        floatingActionButton: InkWell(
          child: ClipOval(
            child: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: <Color>[Color(0xfffe5858), Color(0xffee9617)])),
                height: 60,
                width: 60,
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                )),
          ),
          onTap: () {
            Navigator.of(context).pushNamed('/new_post-screen',
                arguments: NewPostScreenArgs(null, false));
          },
        ),
        body: _isLoading
            ? const CircularProgressIndicator()
            : SizedBox.expand(
                child: ListView.builder(
                    itemCount: postList.length,
                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                    itemBuilder: (BuildContext ctx, index) {
                      return PostItem(postList[index], false);
                    }),
              ));
  }
}
