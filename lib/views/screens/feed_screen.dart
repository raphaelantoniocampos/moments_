import 'package:flutter/material.dart';
import 'package:moments/controllers/post_controller.dart';
import 'package:get/get.dart';

import '../widgets/config_button.dart';
import '../widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("moments"),
        actions: [
          ConfigButton(),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Obx(
          () {
        final postList = Get.find<PostController>().postList;
        if (postList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('No posts here yet'),
                Text('Try adding some friends or using the Search Tab'),
              ],
            ),
          );
        } else {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: postList.length,
            itemBuilder: (context, index) {
              final post = postList[index];
              return PostCard(
                post: post,
              );
            },
          );
        }
      },
    );
  }
}

