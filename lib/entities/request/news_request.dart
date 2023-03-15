import 'dart:convert';

String newsRequestToJson(NewsRequest data) => json.encode(data.toJson());

class NewsRequest {
  NewsRequest({
    required this.description,
    required this.important,
    required this.name,
  });

  String description;
  bool important;
  String name;

  Map<String, dynamic> toJson() => {
        "description": description,
        "important": important,
        "name": name,
      };
}
