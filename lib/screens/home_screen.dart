import 'package:blog_app/model/post.dart';
import 'package:blog_app/screens/add_post.dart';
import 'package:blog_app/screens/option_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbRef = FirebaseDatabase.instance.reference().child('Posts');
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Container(
          padding: const EdgeInsets.all(16.0),
          child: Text('Blogs',
              style: Theme.of(context)
                  .textTheme
                  .headline3!
                  .copyWith(color: Colors.white)),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => AddPost()));
              }),
          IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                auth.signOut().then((_) => Navigator.of(context)
                    .pushReplacement(
                        MaterialPageRoute(builder: (_) => OptionScreen())));
              }),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: FirebaseAnimatedList(
            query: dbRef.child('Post List'),
            itemBuilder: (context, snapshot, animation, index) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: FadeInImage.assetNetwork(
                          width: MediaQuery.of(context).size.width,
                          height: 250,
                          placeholder: 'images/blog_logo.png',
                          image: snapshot.value['pImage'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                            snapshot.value['pTitle'].toString().toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.black)),
                      ),
                      Text(snapshot.value['pDescription'],
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(color: Colors.black87))
                    ],
                  ),
                ),
              );
            },
          ))
        ],
      ),
    );
  }
}
