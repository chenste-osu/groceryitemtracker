import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:groceryitemtracker/models/grocer_post.dart';
import 'package:groceryitemtracker/widgets/custom_text.dart';
import 'package:groceryitemtracker/widgets/grocer_pic.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen(
      {Key? key,
      required this.image,
      required this.analytics,
      required this.observer})
      : super(key: key);

  final File? image;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final newPost = GrocerPost();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");
  DateTime timeNow = DateTime.now();
  LocationData? currentLocation;

  @override
  void initState() {
    super.initState();
    retrieveLocation();
  }

  void retrieveLocation() async {
    var locationService = Location();
    currentLocation = await locationService.getLocation();
    if (currentLocation != null) {
      newPost.latitude = currentLocation!.latitude!;
      newPost.longitude = currentLocation!.longitude!;
    }
    setState(() {});
  }

  Future getImageUrl() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference storageRef = storage.ref().child(DateTime.now().toString());
    UploadTask uploadTask = storageRef.putFile(widget.image!);
    await uploadTask;
    final url = await storageRef.getDownloadURL();
    return url;
  }

  Future<void> sendAnalyticsPost(GrocerPost post) async {
    await widget.analytics.logEvent(name: 'New_Post', parameters: {
      'date': post.date.toString(),
      'description': post.description,
      'imageURL': post.imageURL,
      'cost': post.cost,
      'latitude': post.latitude,
      'longitude': post.longitude
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentLocation == null) {
      return loadingScreen();
    }
    return addPostForm(context);
  }

  Widget addPostForm(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Add Grocer Entry')),
      body: Padding(
          padding: const EdgeInsets.all(20),
          child:
              Form(key: _formKey, child: FocusScope(child: formList(context)))),
    );
  }

  Widget formList(BuildContext context) {
    return ListView(children: [
      dateText(dateFormat.format(timeNow).toString()),
      locationText('Latitude: ${currentLocation?.latitude ?? ''}'),
      locationText('Longitude: ${currentLocation?.longitude ?? ''}'),
      localPicture(context, widget.image),
      descriptionField(),
      costField(),
      submitButton(context)
    ]);
  }

  Widget descriptionField() {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Semantics(
        textField: true,
        label: 'Text Form Field to Enter Grocer Description',
        child: TextFormField(
          maxLength: 15,
          decoration: const InputDecoration(
            labelText: 'Description: ',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.text,
          onSaved: (value) {
            newPost.description = (value!);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a description';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget costField() {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Semantics(
        textField: true,
        label: 'Text Form Field to Enter Grocer Cost',
        child: TextFormField(
          maxLength: 5,
          decoration: const InputDecoration(
            labelText: 'Total Cost: ',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onSaved: (value) {
            newPost.cost = int.parse(value!);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an amount';
            }
            final validNum = int.tryParse(value);
            if (validNum == null) {
              return 'Please enter an integer';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget submitButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Semantics(
          button: true,
          label: 'Send New Grocer Post to Cloud',
          child: ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                newPost.date = timeNow;
                final newURL = await getImageUrl();
                newPost.imageURL = newURL;

                FirebaseFirestore.instance.collection('grocercollection').add({
                  'date': newPost.date,
                  'description': newPost.description,
                  'imageURL': newPost.imageURL,
                  'cost': newPost.cost,
                  'latitude': newPost.latitude,
                  'longitude': newPost.longitude
                });

                sendAnalyticsPost(newPost);
                if (!mounted) return;
                Navigator.pop(context);
              }
            },
            child: const Text('Add Grocer Post'),
          ),
        ),
      ),
    );
  }

  Widget loadingScreen() {
    return Scaffold(
        appBar: AppBar(title: const Text('Add Grocer Entry')),
        body: const Center(child: CircularProgressIndicator(value: null)));
  }
}
