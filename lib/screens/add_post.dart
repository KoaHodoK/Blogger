import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:blog_app/widgets/round_button.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  File? _image;
  bool showSpinner = false;
  final _picker = ImagePicker();
  final _formkey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String title = "", description = "";
  FirebaseAuth _auth = FirebaseAuth.instance;
  final postRef = FirebaseDatabase.instance.ref().child('Posts');
  FirebaseStorage storage = FirebaseStorage.instance;

  void dialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              content: SizedBox(
                  height: 120,
                  child: Column(children: [
                    ListTile(
                        onTap: () {
                          getCameraImage();
                          Navigator.pop(context);
                        },
                        leading: const Icon(Icons.camera),
                        title: const Text('Camera')),
                    ListTile(
                        onTap: () {
                          getImageGallery();
                          Navigator.pop(context);
                        },
                        leading: const Icon(Icons.photo_library),
                        title: const Text('Gallery')),
                  ])));
        });
  }

  Future getImageGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('Image no  selected!');
      }
    });
  }

  Future getCameraImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('Image no  selected!');
      }
    });
  }

  void toastMessage(String message) {
    Fluttertoast.showToast(
      msg: message.toString(),
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: Container(
              padding: const EdgeInsets.all(8.0),
              child: const Text('POST'),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: Column(children: [
              InkWell(
                onTap: () {
                  dialog(context);
                },
                child: Center(
                    child: SizedBox(
                        height: 50,
                        width: 50,
                        child: _image != null
                            ? ClipRect(
                                child: Image.file(
                                _image!.absolute,
                                height: 50,
                                width: 80,
                                fit: BoxFit.fill,
                              ))
                            : Container(
                                width: 80,
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey.shade200),
                                child: const Icon(Icons.camera_alt,
                                    color: Colors.blue)))),
              ),
              const SizedBox(height: 10),
              Form(
                key: _formkey,
                child: Expanded(
                  child: Column(children: [
                    TextFormField(
                      onChanged: (val) {
                        title = val;
                      },
                      controller: titleController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'Blog Title',
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) {
                        return val!.isEmpty ? 'Enter Title' : null;
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      onChanged: (val) {
                        description = val;
                      },
                      validator: (val) {
                        return val!.isEmpty ? 'Enter Description' : null;
                      },
                      minLines: 1,
                      maxLines: 5,
                      keyboardType: TextInputType.text,
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Description',
                      ),
                    ),
                    const Spacer(),
                    RoundButton(
                        title: 'UPLOAD',
                        onPress: () async {
                          print(
                              '*************************************************');
                          setState(() {
                            showSpinner = true;
                          });
                          try {
                            print(
                                '********************** Trying  ***************************');
                            int date = DateTime.now().microsecondsSinceEpoch;
                            var ref =
                                FirebaseStorage.instance.ref('/blogapp$date');
                            UploadTask uploadTask =
                                ref.putFile(_image!.absolute);
                            await Future.value(uploadTask);
                            var newUrl = await ref.getDownloadURL();
                            print(
                                '************************ $newUrl *************************');
                            final User? user = _auth.currentUser;
                            postRef
                                .child('Post List')
                                .child(date.toString())
                                .set({
                              'pId': date.toString(),
                              'pImage': newUrl.toString(),
                              'pTime': date.toString(),
                              'pTitle': titleController.text.toString(),
                              'pDescription':
                                  descriptionController.text.toString(),
                              'pEmail': user!.email.toString(),
                              'uid': user.uid.toString(),
                            }).then((value) {
                              toastMessage('Post Published!');
                              setState(() {
                                showSpinner = false;
                              });
                            }).onError((e, stackTrace) {
                              toastMessage(e.toString());
                              setState(() {
                                showSpinner = false;
                              });
                            });
                          } catch (e) {
                            setState(() {
                              showSpinner = false;
                            });
                            toastMessage(e.toString());
                          }
                        }),
                  ]),
                ),
              ),
            ]),
          )),
    );
  }
}
