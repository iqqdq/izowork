class ObjectStageRequest {
  ObjectStageRequest({
    required this.id,
    required this.objectStageId,
  });

  String id;
  String objectStageId;

  Map<String, dynamic> toJson() => {
        "id": id,
        "object_stage_id": objectStageId,
      };
}
