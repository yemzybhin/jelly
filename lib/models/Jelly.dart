// To parse this JSON data, do
//
//     final allJellies = allJelliesFromJson(jsonString);

import 'dart:convert';

AllJellies allJelliesFromJson(String str) => AllJellies.fromJson(json.decode(str));

String allJelliesToJson(AllJellies data) => json.encode(data.toJson());

class AllJellies {
  List<Jelly> jellies;

  AllJellies({
    required this.jellies,
  });

  factory AllJellies.fromJson(Map<String, dynamic> json) => AllJellies(
    jellies: List<Jelly>.from(json["jellies"].map((x) => Jelly.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "jellies": List<dynamic>.from(jellies.map((x) => x.toJson())),
  };
}

class Jelly {
  String userName;
  String handle;
  String profileImage;
  String description;
  String video;

  Jelly({
    required this.userName,
    required this.handle,
    required this.profileImage,
    required this.description,
    required this.video,
  });

  factory Jelly.fromJson(Map<String, dynamic> json) => Jelly(
    userName: json["userName"],
    handle: json["handle"],
    profileImage: json["profileImage"],
    description: json["description"],
    video: json["video"],
  );

  Map<String, dynamic> toJson() => {
    "userName": userName,
    "handle": handle,
    "profileImage": profileImage,
    "description": description,
    "video": video,
  };
}
