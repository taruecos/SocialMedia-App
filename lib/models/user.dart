import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? username;
  String? email;
  String? photoUrl;
  String? country;
  String? bio;
  String? id;
  DateTime? signedUpAt;
  DateTime? lastSeen;
  bool? isOnline;

  UserModel(
      {this.username,
      this.email,
      this.id,
      this.photoUrl,
      this.signedUpAt,
      this.isOnline,
      this.lastSeen,
      this.bio,
      this.country});

  UserModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    country = json['country'];
    photoUrl = json['photoUrl'];
    signedUpAt = json['signedUpAt'] != null
        ? (json['signedUpAt'] as Timestamp).toDate()
        : null;
    lastSeen = json['lastSeen'] != null
        ? (json['lastSeen'] as Timestamp).toDate()
        : null;
    isOnline = json['isOnline'];
    bio = json['bio'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['country'] = this.country;
    data['email'] = this.email;
    data['photoUrl'] = this.photoUrl;
    data['bio'] = this.bio;
    data['signedUpAt'] =
        this.signedUpAt == null ? null : Timestamp.fromDate(this.signedUpAt!);
    data['lastSeen'] =
        this.lastSeen == null ? null : Timestamp.fromDate(this.lastSeen!);
    data['isOnline'] = this.isOnline;
    data['id'] = this.id;
    return data;
  }
}
