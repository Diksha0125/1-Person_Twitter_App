import 'package:cloud_firestore/cloud_firestore.dart';

class Tweets {
  String id;
  String description;
  String image;
  Timestamp createdAt;
  Timestamp updatedAt;

  Tweets();

  Tweets.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    image = data['image'];
    description = data['description'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }
}
