import 'dart:io';

import 'package:blog_app/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  File? _image;
  final _picker = ImagePicker();
  final _formkey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String title = "", description = "";

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Container(
            padding: const EdgeInsets.all(16.0),
            child: const Text('POST'),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(children: [
            InkWell(
              onTap: () {
                dialog(context);
              },
              child: Center(
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height * .2,
                      width: MediaQuery.of(context).size.width * 1,
                      child: _image != null
                          ? ClipRect(
                              child: Image.file(
                              _image!.absolute,
                              height: 100,
                              width: 100,
                              fit: BoxFit.fill,
                            ))
                          : Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.shade100),
                              child: const Icon(Icons.camera_alt,
                                  color: Colors.blue)))),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Form(
                  key: _formkey,
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
                      height: 30,
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
                    RoundButton(title: 'UPLOAD', onPress: () {}),
                    const SizedBox(
                      height: 30,
                    ),
                  ])),
            ),
          ]),
        ));
  }
}
