// class Organization_Details {
//   final String id;
//   final String name;
//   final String logo;
//   final String description;

//   Organization_Details({
//     required this.id,
//     required this.name,
//     required this.logo,
//     required this.description,
//   });

//   factory Organization_Details.fromJson(Map<String, dynamic> json) {
//     return Organization_Details(
//       id: json['_id'] ?? '',
//       name: json['name'] ?? '',
//       logo: json['logo'] ?? '',
//       description: json['description'] ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'name': name,
//       'logo': logo,
//       'description': description,
//     };
//   }
// }


// To parse this JSON data, do
//
//     final organizationDetails = organizationDetailsFromJson(jsonString);

import 'dart:convert';

List<Organization_Details> organizationDetailsFromJson(String str) => List<Organization_Details>.from(json.decode(str).map((x) => Organization_Details.fromJson(x)));

String organization_DetailsToJson(List<Organization_Details> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Organization_Details {
    int userId;
    int id;
    String title;
    String body;

    Organization_Details({
        required this.userId,
        required this.id,
        required this.title,
        required this.body,
    });

    factory Organization_Details.fromJson(Map<String, dynamic> json) => Organization_Details(
        userId: json["userId"],
        id: json["id"],
        title: json["title"],
        body: json["body"],
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "title": title,
        "body": body,
    };
}



