import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String? id;
  String? description;
  String? invoiceImage;
  String? itemImage;
  String? userId;
  Timestamp? timestamp;

  PostModel(
      {this.id,
      this.description,
      this.invoiceImage,
      this.itemImage,
      this.userId,
      this.timestamp});

  PostModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    invoiceImage = json['invoiceImage'];
    itemImage = json['itemImage'];
    userId = json['userId'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['invoiceImage'] = this.invoiceImage;
    data['itemImage'] = this.itemImage;
    data['userId'] = this.userId;
    data['timestamp'] = this.timestamp;
    return data;
  }
}
