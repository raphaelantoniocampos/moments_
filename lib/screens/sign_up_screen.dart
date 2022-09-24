import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moments/resources/auth_method.dart';
import 'package:moments/screens/camera_screen.dart';
import 'package:moments/utils/colors.dart';
import 'package:moments/utils/image_picker.dart';
import 'package:moments/widgets/text_field_input.dart';
import 'dart:io';

import '../utils/utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  File? image;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        file: await image!.readAsBytes());
    setState(() {
      _isLoading = false;
    });
    if (res != 'sucess') {
      showSnackBar(res, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            //svg image
            SvgPicture.asset(
              'assets/moments_logo.svg',
              color: primaryColor,
              height: 200,
            ),

            // add photo widget
            Stack(
              children: [
                image != null
                    ? CircleAvatar(
                        radius: 64,
                        backgroundImage: FileImage(File(image!.path)))
                    : const CircleAvatar(
                        backgroundColor: Colors.white38,
                        radius: 64,
                        backgroundImage: NetworkImage(
                            'https://www.pngall.com/wp-content/uploads/5/Profile-PNG-File.png'),
                      ),
                Positioned(
                    bottom: -10,
                    left: 90,
                    child: IconButton(
                      color: primaryColor,
                      iconSize: 25,
                      onPressed: () async {
                        final getingImage = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CameraScreen(
                                      isRecordingAvailable: false,
                                    )));
                        print('print image: ${getingImage.toString()}');
                        setState(() {
                          image = getingImage;
                        });
                      },
                      icon: const Icon(Icons.add_a_photo),
                    )),
              ],
            ),
            const SizedBox(
              height: 24,
            ),

            //text field input username
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your username';
                      }
                      return null;
                    },
                    decoration:
                        const InputDecoration(hintText: 'Enter your username'),
                    keyboardType: TextInputType.text,
                    controller: _usernameController,
                  ),
                  const SizedBox(
                    height: 24,
                  ),

                  //text field input email
                  TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your email';
                        } else {
                          bool emailValid = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value);
                          if (!emailValid) {
                            return 'Email not valid';
                          }
                          return null;
                        }
                      },
                      decoration:
                          const InputDecoration(hintText: 'Enter your email'),
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController),
                  const SizedBox(
                    height: 24,
                  ),

                  //text field input password
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must have at least 6 characters';
                      }
                      return null;
                    },
                    decoration:
                        const InputDecoration(hintText: 'Enter your password'),
                    keyboardType: TextInputType.text,
                    controller: _passwordController,
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 24,
                  ),

                  //button signup
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate() && !_isLoading) {
                        signUpUser();
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: const ShapeDecoration(
                          color: primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)))),
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : const Text('Sign up'),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 2,
              child: Container(),
            ),
          ],
        ),
      )),
    );
  }
}
