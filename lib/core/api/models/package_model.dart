import 'package:eagle_cargo/core/api/models/order_model.dart';
import 'package:eagle_cargo/core/api/models/warehouse_model.dart';

class PackageModel {
  String? packageGuid;
  String? packageCode;
  String? packageFirmCode;
  String? orderGuid;
  String? shipmentGuid;
  String? firmGuid;
  String? senderUserGuid;
  String? status;
  String? description;
  int? quantity;
  double? weightKg;
  String? lengthCm;
  String? widthCm;
  String? heightCm;
  String? declaredValue;
  String? currentWarehouseGuid;
  String? createdDt;
  String? updatedDt;
  String? orderNumber;
  OrderModel? order;
  bool? isVerified;
  String? checkerUserName;
  String? checkerNote;
  String? checkerGuid;
  String? creatorUser;
  String? creatorGuid;
  String? removerGuid;
  WarehouseModel? warehouse;
  Shipment? shipments;
  List<Photos>? photos;

  PackageModel({
    this.packageGuid,
    this.packageCode,
    this.packageFirmCode,
    this.orderGuid,
    this.shipmentGuid,
    this.firmGuid,
    this.senderUserGuid,
    this.status,
    this.description,
    this.quantity,
    this.weightKg,
    this.lengthCm,
    this.widthCm,
    this.heightCm,
    this.declaredValue,
    this.currentWarehouseGuid,
    this.createdDt,
    this.updatedDt,
    this.orderNumber,
    this.order,
    this.isVerified,
    this.checkerUserName,
    this.checkerNote,
    this.checkerGuid,
    this.creatorUser,
    this.creatorGuid,
    this.removerGuid,
    this.warehouse,
    this.shipments,
    this.photos,
  });

  PackageModel.fromJson(Map<String, dynamic> json) {
    packageGuid = json['package_guid'];
    packageCode = json['package_code'];
    packageFirmCode = json['package_firm_code'];
    orderGuid = json['order_guid'];
    shipmentGuid = json['shipment_guid'];
    firmGuid = json['firm_guid'];
    senderUserGuid = json['sender_user_guid'];
    status = json['status'];
    description = json['description'];
    quantity = json['quantity'];
    weightKg = double.tryParse(json['weight_kg']?.toString() ?? '0');
    lengthCm = json['length_cm']?.toString();
    widthCm = json['width_cm']?.toString();
    heightCm = json['height_cm']?.toString();
    declaredValue = json['declared_value']?.toString();
    currentWarehouseGuid = json['current_warehouse_guid'];
    createdDt = json['created_dt'];
    updatedDt = json['updated_dt'];
    orderNumber = json['order_number'];
    order = json['order'] != null ? OrderModel.fromJson(json['order']) : null;
    isVerified = json['is_verified'];
    checkerUserName = json['checker_user_name'];
    checkerNote = json['checker_note'];
    checkerGuid = json['checker_guid'];
    creatorUser = json['creator_user'];
    creatorGuid = json['creator_guid'];
    removerGuid = json['remover_guid'];
    warehouse = json['warehouse'] != null
        ? WarehouseModel.fromJson(json['warehouse'])
        : null;
    shipments = json['shipments'] != null
        ? Shipment.fromJson(json['shipments'])
        : null;
    if (json['photos'] != null) {
      photos = <Photos>[];
      json['photos'].forEach((v) {
        photos!.add(Photos.fromJson(v));
      });
    }
  }
}

class Shipment {
  String? shipmentGuid;
  String? shipmentCode;
  String? note;
  String? status;
  int? totalPackages;
  String? totalWeightKg;
  String? arrivalDt;
  String? departureDt;
  String? createdDt;
  String? updatedDt;

  Shipment({
    this.shipmentGuid,
    this.shipmentCode,
    this.note,
    this.status,
    this.totalPackages,
    this.totalWeightKg,
    this.arrivalDt,
    this.departureDt,
    this.createdDt,
    this.updatedDt,
  });

  Shipment.fromJson(Map<String, dynamic> json) {
    shipmentGuid = json['shipment_guid'];
    shipmentCode = json['shipment_code'];
    note = json['note'];
    status = json['status'];
    totalPackages = json['total_packages'];
    totalWeightKg = json['total_weight_kg']?.toString();
    arrivalDt = json['arrival_dt'];
    departureDt = json['departure_dt'];
    createdDt = json['created_dt'];
    updatedDt = json['updated_dt'];
  }
}

class Photos {
  String? photoGuid;
  String? packageGuid;
  String? userGuid;
  String? photoUrl;
  String? photoType;
  String? createdDt;

  Photos({
    this.photoGuid,
    this.packageGuid,
    this.userGuid,
    this.photoUrl,
    this.photoType,
    this.createdDt,
  });

  Photos.fromJson(Map<String, dynamic> json) {
    photoGuid = json['photo_guid'];
    packageGuid = json['package_guid'];
    userGuid = json['user_guid'];
    photoUrl = json['photo_url'];
    photoType = json['photo_type'];
    createdDt = json['created_dt'];
  }
}
