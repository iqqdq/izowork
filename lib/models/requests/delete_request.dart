class DeleteRequest {
  DeleteRequest({
    required this.id,
  });

  String id;

  factory DeleteRequest.fromJson(Map<String, dynamic> json) => DeleteRequest(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
