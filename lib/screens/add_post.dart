import 'dart:io';

import 'package:blog_app/widgets/round_button.dart';
import 'package:flutter/material.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  File? _image;
  final _formkey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String title = "", description = "";
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
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(children: [
            Center(
                child: Container(
                    height: MediaQuery.of(context).size.height * .2,
                    width: MediaQuery.of(context).size.width * .1,
                    child: _image != null
                        ? ClipRect(
                            child: Image.file(
                            _image!.absolute,
                            height: 100,
                            width: 100,
                            fit: BoxFit.fitHeight,
                          ))
                        : Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade100),
                            child: const Icon(Icons.camera_alt,
                                color: Colors.blue)))),
            const SizedBox(height: 30),
            Form(
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
                        prefixIcon: Icon(Icons.email)),
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
                    maxLength: 5,
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
          ]),
        )));
  }
}
