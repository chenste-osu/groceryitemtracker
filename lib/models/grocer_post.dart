import 'package:cloud_firestore/cloud_firestore.dart';

class GrocerPost {
  DateTime date;
  String description;
  String imageURL;
  int cost;
  double latitude;
  double longitude;

  GrocerPost({
    DateTime? date,
    this.description = '',
    this.imageURL = '',
    this.cost = 0,
    this.latitude = 360.360,
    this.longitude = 360.360,
  }) : date = date ?? DateTime.now();

  factory GrocerPost.fromDocument(DocumentSnapshot document) {
    return GrocerPost(
      date: document['date'].toDate(),
      description: document['description'],
      imageURL: document['imageURL'],
      cost: document['cost'],
      latitude: (document['latitude'] == null) ? null : document['latitude'],
      longitude: (document['longitude'] == null) ? null : document['longitude'],
    );
  }

  factory GrocerPost.fromMap(Map docMap) {
    return GrocerPost(
      date: docMap['date'],
      description: docMap['description'],
      imageURL: docMap['imageURL'],
      cost: docMap['cost'],
      latitude: (docMap['latitude'] == null) ? null : docMap['latitude'],
      longitude: (docMap['longitude'] == null) ? null : docMap['longitude'],
    );
  }
}
