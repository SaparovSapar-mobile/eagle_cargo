import 'package:eagle_cargo/core/api/models/location_model.dart';

class WarehouseModel {
  String? warehouseGuid;
  String? firmGuid;
  String? locationGuid;
  String? code;
  String? name;
  String? address;
  double? latitude;
  double? longitude;
  String? phone;
  bool? isActive;

  /// Warehouses located abroad (China, Turkey, ...) are flagged by the firm
  /// admin; the backend defaults every legacy warehouse to `false`.
  bool? isForeign;
  String? createdDt;
  LocationModel? location;

  WarehouseModel(
      {this.warehouseGuid,
      this.firmGuid,
      this.locationGuid,
      this.code,
      this.name,
      this.address,
      this.latitude,
      this.longitude,
      this.phone,
      this.isActive,
      this.isForeign,
      this.createdDt,
      this.location});

  WarehouseModel.fromJson(Map<String, dynamic> json) {
    warehouseGuid = json['warehouse_guid'];
    firmGuid = json['firm_guid'];
    locationGuid = json['location_guid'];
    code = json['code'];
    name = json['name'];
    address = json['address'];
    phone = json['phone'];
    isActive = json['is_active'];
    isForeign = json['is_foreign'] == true;
    createdDt = json['created_dt'];
    location = json['location'] != null
        ? LocationModel.fromJson(json['location'])
        : null;
    // Coordinates are documented on the warehouse itself, but the backend
    // currently only sets them on the nested location — fall back to that.
    latitude = json['latitude'] == null
        ? location?.latitude
        : double.tryParse(json['latitude'].toString());
    longitude = json['longitude'] == null
        ? location?.longitude
        : double.tryParse(json['longitude'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['warehouse_guid'] = warehouseGuid;
    data['firm_guid'] = firmGuid;
    data['location_guid'] = locationGuid;
    data['code'] = code;
    data['name'] = name;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['phone'] = phone;
    data['is_active'] = isActive;
    data['is_foreign'] = isForeign;
    data['created_dt'] = createdDt;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    return data;
  }
}
