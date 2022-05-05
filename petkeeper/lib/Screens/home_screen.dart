import 'package:flutter/material.dart';
import 'package:petkeeper/models/post.dart';
import 'package:petkeeper/widgets/filter_drawer.dart';
import 'package:petkeeper/widgets/post_item.dart';
import 'package:provider/provider.dart';

import '../widgets/post_item.dart';
import '../providers/auth_provider.dart';
import '../widgets/AppDrawer.dart';
import '../providers/posts_provider.dart';

class homeScreen extends StatefulWidget {
  static const routename = '/home-screen';

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  late int _dropDownWaterValue;
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
        appBar: AppBar(
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
                        const Text('Walks(per day)'),
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
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed('/new_post-screen');
          },
        ),
        body: _isLoading
            ? const CircularProgressIndicator()
            : ListView.builder(
                itemCount: postList.length,
                padding: const EdgeInsets.only(bottom: 10, top: 10),
                itemBuilder: (BuildContext ctx, index) {
                  return SizedBox(
                      height: 150, child: PostItem(postList[index]));
                }));
  }
}
