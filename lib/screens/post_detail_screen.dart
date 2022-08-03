import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:groceryitemtracker/models/grocer_post.dart';
import 'package:groceryitemtracker/widgets/grocer_pic.dart';
import 'package:groceryitemtracker/widgets/custom_text.dart';

class PostDetailScreen extends StatefulWidget {
  final GrocerPost grocerpost;
  const PostDetailScreen({Key? key, required this.grocerpost})
      : super(key: key);

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");
    return Scaffold(
        appBar: AppBar(title: const Text('Grocer Post')),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(children: [
            dateText(dateFormat.format(widget.grocerpost.date)),
            locationText('Latitude: ${widget.grocerpost.latitude.toString()}'),
            locationText(
                'Longitude: ${widget.grocerpost.longitude.toString()}'),
            networkPicture(context, widget.grocerpost.imageURL),
            Column(children: [
              descText(widget.grocerpost.description.toString()),
              costText('\$ ${widget.grocerpost.cost.toString()}')
            ])
          ]),
        ));
  }
}
