import 'package:flutter/material.dart';
import 'package:petkeeper/models/post.dart';
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
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    authProvider.fetchExtraUserInfo();
    final postProvider = Provider.of<PostsProvider>(context);
    postProvider.fetchPosts();
    bool _isLoading;
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
          ],
        ),
        drawer: AppDrawer(),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed('/new_post-screen');
          },
        ),
        body: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemCount: postList.length,
            itemBuilder: (BuildContext ctx, index) {
              return PostItem(postList[index]);
            }));
  }
}
