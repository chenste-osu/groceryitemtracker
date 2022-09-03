import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:groceryitemtracker/models/grocer_post.dart';
import 'package:groceryitemtracker/screens/add_post_screen.dart';
import 'package:groceryitemtracker/screens/post_detail_screen.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key, required this.analytics, required this.observer})
      : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final picker = ImagePicker();
  File? image;

  @override
  void initState() {
    super.initState();
  }

  void getImageAndCreatePost() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      if (!mounted) return;
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddPostScreen(
                  image: image,
                  analytics: widget.analytics,
                  observer: widget.observer)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery Item Tracker'),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('grocercollection')
              .orderBy('date', descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Error: Could not connect to Firestore');
            } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var post = snapshot.data!.docs[index];
                    return buildListItem(context, post, index);
                  });
            } else {
              return const Center(
                child: CircularProgressIndicator(value: null),
              );
            }
          }),
      floatingActionButton: selectPicButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget buildListItem(BuildContext context, var fsDocument, int index) {
    GrocerPost postFromDoc = GrocerPost.fromDocument(fsDocument);
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    return Semantics(
      button: true,
      label: 'Grocer Post $index',
      child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: SizedBox(
                    width: 100,
                    child: Text(dateFormat.format(postFromDoc.date))),
              ),
              Flexible(
                flex: 2,
                child:
                    SizedBox(width: 200, child: Text(postFromDoc.description)),
              ),
              Flexible(
                  flex: 1,
                  child: SizedBox(
                      width: 60, child: Text('\$ ${postFromDoc.cost}')))
            ],
          ),
          onTap: () {
            goDetailScreen(context, postFromDoc);
          }),
    );
  }

  Widget selectPicButton() {
    return Semantics(
      button: true,
      label: 'Select Picture Button',
      child: FloatingActionButton(
          tooltip: 'Add a New Grocery Item',
          child: const Icon(Icons.add),
          onPressed: () async {
            getImageAndCreatePost();
          }),
    );
  }

  void goDetailScreen(BuildContext context, GrocerPost post) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PostDetailScreen(grocerpost: post)));
  }
}
