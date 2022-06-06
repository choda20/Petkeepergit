import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/request.dart';
import '../models/post.dart';
import '../widgets/post_item.dart';
import '../widgets/gradient_icons.dart';
import '../providers/request_provider.dart';

class JobRequests extends StatelessWidget {
  Post postData;
  Request requestData;
  JobRequests(this.postData, this.requestData);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: PostItem(postData, false, true, false),
          flex: 7,
        ),
        Expanded(
          flex: 1,
          child: IconButton(
              onPressed: () {
                Provider.of<RequestProvider>(context, listen: false)
                    .deleteRequest(requestData.requestId);
              },
              icon: RadiantGradientMask(
                  child:
                      const Icon(Icons.delete, color: Colors.white, size: 30))),
        )
      ],
    );
  }
}
