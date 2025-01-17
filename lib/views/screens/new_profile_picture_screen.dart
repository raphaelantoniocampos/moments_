import 'package:flutter/material.dart';
import 'package:moments/controllers/post_controller.dart';
import 'package:moments/views/screens/main_screen.dart';
import 'package:get/get.dart';
import 'package:moments/views/widgets/config_button.dart';

import '../../constants.dart';
import '../../controllers/user_controller.dart';
import '../../models/post.dart';
import 'camera_screen.dart';

class NewProfilePictureScreen extends StatefulWidget {
  const NewProfilePictureScreen({Key? key}) : super(key: key);

  @override
  State<NewProfilePictureScreen> createState() =>
      _NewProfilePictureScreenState();
}

class _NewProfilePictureScreenState extends State<NewProfilePictureScreen> {
  bool isLoading = false;
  final PostController postController = Get.put(PostController());
  final UserController profileController = Get.put(UserController());

  Future<Post?> _uploadPost(image) async {
    setState(() {
      isLoading = true;
    });
    return await postController.uploadPost(image);
  }

  void _changeDescription(String postId, String description) {
    postController.changeDescription(postId, description);
  }

  void _changeProfilePic(Post post) async {
    profileController.changeProfilePic(post);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(actions: [
              ConfigButton(),
            ]),
            body: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                width: double.infinity,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Container(),
                      ),
                      const Text("moments"),
                      const Center(
                        child: Text(
                          'Take your profile pic',
                          style: TextStyle(fontSize: 20, color: secondaryColor),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),

                      // add photo widget
                      Stack(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.white38,
                            radius: 150,
                            backgroundImage: NetworkImage(
                                'https://www.pngall.com/wp-content/uploads/5/Profile-PNG-File.png'),
                          ),
                          Positioned(
                              bottom: 0,
                              left: 200,
                              child: IconButton(
                                color: primaryColor,
                                iconSize: 50,
                                onPressed: () async {
                                  final image =
                                      await Get.to(() => const CameraScreen(
                                            isRecordingAvailable: false,
                                          ));
                                  Post post =
                                      (await _uploadPost(image)) as Post;
                                  _changeProfilePic(post);
                                  _changeDescription(post.postId,
                                      'I created my moments account.');

                                  Get.offAll(() => const MainScreen());
                                },
                                icon: const Icon(Icons.add_a_photo),
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Flexible(
                        flex: 2,
                        child: Container(),
                      ),
                    ]),
              ),
            ),
          );
  }
}
