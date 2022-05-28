import 'package:flutter/material.dart';
import 'package:petkeeper/widgets/job_item.dart';
import 'package:provider/provider.dart';

import '../providers/request_provider.dart';
import '../widgets/past_jobs_item.dart';
import '../providers/auth_provider.dart';
import '../providers/posts_provider.dart';
import '../widgets/post_item.dart';
import '../widgets/gradient_icons.dart';

class JobScreen extends StatefulWidget {
  static const routename = '/jobs-screen';

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final uid = Provider.of<AuthProvider>(context).user.uid;
    final acceptedPostsId =
        Provider.of<RequestProvider>(context).getAcceptedRequestsPostIds(uid);
    final pendingPostsId =
        Provider.of<RequestProvider>(context).getPendingRequestsPostIds(uid);
    final pendingRequests =
        Provider.of<RequestProvider>(context).getPendingRequests(uid);

    final pendingPosts =
        Provider.of<PostsProvider>(context).getPostsById(pendingPostsId);

    final acceptedPosts =
        Provider.of<PostsProvider>(context).getPostsById(acceptedPostsId);
    final pastJobs =
        Provider.of<PostsProvider>(context).getPastPosts(acceptedPosts);
    final ongoingJobs =
        Provider.of<PostsProvider>(context).getOngingPosts(acceptedPosts);
    return Scaffold(
        backgroundColor: const Color(0xffeaeaea),
        bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: const Color(0xffee9617),
            selectedIconTheme: const IconThemeData(color: Colors.white),
            currentIndex: _selectedIndex,
            onTap: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: RadiantGradientMask(child: const Icon(Icons.work)),
                  label: 'Ongoing jobs'),
              BottomNavigationBarItem(
                  icon: RadiantGradientMask(child: const Icon(Icons.timer)),
                  label: 'Past jobs'),
              BottomNavigationBarItem(
                  icon: RadiantGradientMask(child: const Icon(Icons.pending)),
                  label: 'Job requests')
            ]),
        appBar: AppBar(
            flexibleSpace: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: <Color>[
                  Color(0xfffe5858),
                  Color(0xffee9617)
                ]))),
            title: const Text('Jobs')),
        body: _selectedIndex == 0 && ongoingJobs.isNotEmpty
            ? SizedBox.expand(
                child: ListView.builder(
                    itemCount: ongoingJobs.length,
                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                    itemBuilder: (BuildContext ctx, index) {
                      return PostItem(ongoingJobs[index], false, false, false);
                    }),
              )
            : _selectedIndex == 0 && ongoingJobs.isEmpty
                ? const Center(
                    child: Text(
                      'You have no ongoing jobs.',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  )
                : _selectedIndex == 1 && pastJobs.isNotEmpty
                    ? SizedBox.expand(
                        child: ListView.builder(
                            itemCount: pastJobs.length,
                            padding: const EdgeInsets.only(bottom: 10, top: 10),
                            itemBuilder: (BuildContext ctx, index) {
                              return PastJobsItem(pastJobs[index]);
                            }),
                      )
                    : _selectedIndex == 1 && pastJobs.isEmpty
                        ? const Center(
                            child: Text(
                              'You have no past jobs.',
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : _selectedIndex == 2 && pendingPosts.isEmpty
                            ? const Center(
                                child: Text(
                                  'You have no pending applications.',
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : _selectedIndex == 2 && pendingPosts.isNotEmpty
                                ? SizedBox.expand(
                                    child: ListView.builder(
                                        itemCount: pendingPosts.length,
                                        padding: const EdgeInsets.only(
                                            bottom: 10, top: 10),
                                        itemBuilder: (BuildContext ctx, index) {
                                          return JobRequests(
                                              pendingPosts[index],
                                              false,
                                              pendingRequests[index]);
                                        }),
                                  )
                                : const Center(
                                    child: CircularProgressIndicator()));
  }
}
