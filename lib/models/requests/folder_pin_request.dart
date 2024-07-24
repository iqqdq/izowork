class FolderPinRequest {
  final String folderId;

  FolderPinRequest({required this.folderId});

  Map<String, dynamic> toJson() => {"folder_id": folderId};
}
