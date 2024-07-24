class CommonFolderRequest {
  final bool isCommon;
  final String name;
  final String officeId;
  final String? parentFolder;

  CommonFolderRequest({
    required this.isCommon,
    required this.name,
    required this.officeId,
    this.parentFolder,
  });

  Map<String, dynamic> toJson() => parentFolder == null
      ? {
          "is_common": isCommon,
          "name": name,
          "office_id": officeId,
        }
      : {
          "is_common": isCommon,
          "name": name,
          "office_id": officeId,
          "parent_folder": parentFolder,
        };
}
