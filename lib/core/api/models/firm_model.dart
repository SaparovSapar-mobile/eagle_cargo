class FirmModel {
  String? firmGuid;
  String? name;
  String? slug;
  String? phone;
  String? email;
  String? image;
  String? about;
  bool? isActive;
  String? rating;
  String? createdDt;
  String? updatedDt;

  FirmModel(
      {this.firmGuid,
      this.name,
      this.slug,
      this.phone,
      this.email,
      this.image,
      this.about,
      this.isActive,
      this.rating,
      this.createdDt,
      this.updatedDt});

  FirmModel.fromJson(Map<String, dynamic> json) {
    firmGuid = json['firm_guid'];
    name = json['name'];
    slug = json['slug'];
    phone = json['phone'];
    email = json['email'];
    image = json['image'];
    about = json['about'];
    isActive = json['is_active'];
    rating = json['rating'];
    createdDt = json['created_dt'];
    updatedDt = json['updated_dt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firm_guid'] = firmGuid;
    data['name'] = name;
    data['slug'] = slug;
    data['phone'] = phone;
    data['email'] = email;
    data['image'] = image;
    data['about'] = about;
    data['is_active'] = isActive;
    data['rating'] = rating;
    data['created_dt'] = createdDt;
    data['updated_dt'] = updatedDt;
    return data;
  }
}