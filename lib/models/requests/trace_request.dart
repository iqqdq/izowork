class TraceRequest {
  String action;
  String objectId;

  TraceRequest({
    required this.action,
    required this.objectId,
  });

  factory TraceRequest.fromJson(Map<String, dynamic> json) => TraceRequest(
        action: json["action"],
        objectId: json["object_id"],
      );

  Map<String, dynamic> toJson() => {
        "action": action,
        "object_id": objectId,
      };
}
