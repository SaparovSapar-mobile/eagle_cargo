class LocationModel {
  String? locationGuid;
  String? name;
  String? nameEn;
  String? parentGuid;
  int? level;
  double? latitude;
  double? longitude;
  bool? isActive;
  String? createdDt;

  LocationModel(
      {this.locationGuid,
      this.name,
      this.nameEn,
      this.parentGuid,
      this.level,
      this.latitude,
      this.longitude,
      this.isActive,
      this.createdDt});

  LocationModel.fromJson(Map<String, dynamic> json) {
    locationGuid = json['location_guid'];
    name = json['name'];
    nameEn = json['name_en'];
    parentGuid = json['parent_guid'];
    level = json['level'];
    latitude = json['latitude'] == null
        ? null
        : double.tryParse(json['latitude'].toString());
    longitude = json['longitude'] == null
        ? null
        : double.tryParse(json['longitude'].toString());
    isActive = json['is_active'];
    createdDt = json['created_dt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['location_guid'] = locationGuid;
    data['name'] = name;
    data['name_en'] = nameEn;
    data['parent_guid'] = parentGuid;
    data['level'] = level;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['is_active'] = isActive;
    data['created_dt'] = createdDt;
    return data;
  }
}