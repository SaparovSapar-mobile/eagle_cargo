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

  /// Countries the shipment passes on its way; empty when the firm set none.
  ShipmentRoute? route;
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
    this.route,
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
    route = json['route'] != null
        ? ShipmentRoute.fromJson(json['route'])
        : null;
    if (json['photos'] != null) {
      photos = <Photos>[];
      json['photos'].forEach((v) {
        photos!.add(Photos.fromJson(v));
      });
    }
  }
}

/// Countries a shipment passes on its way to Turkmenistan, set by the firm
/// admin. Always rendered as served: the admin can move back to an earlier
/// country to correct a mistake.
class ShipmentRoute {
  /// Country the shipment is in now; `null` before departure.
  RouteCheckpoint? current;

  /// All countries in route order — already sorted by `sequence`.
  List<RouteCheckpoint> checkpoints;

  ShipmentRoute({this.current, this.checkpoints = const []});

  bool get isEmpty => checkpoints.isEmpty;

  ShipmentRoute.fromJson(Map<String, dynamic> json)
    : current = json['current'] != null
          ? RouteCheckpoint.fromJson(json['current'])
          : null,
      checkpoints = (json['checkpoints'] as List? ?? [])
          .map((e) => RouteCheckpoint.fromJson(e))
          .toList();
}

class RouteCheckpoint {
  String? locationGuid;
  int? sequence;

  /// Flag emoji; may be missing — [code] stands in for it then.
  String? emoji;
  String? code;

  /// Turkmen name, used when [title] has nothing for the language.
  String? name;
  LocationTitle? title;

  /// UTC. Can be `null` on a passed country the admin skipped.
  String? arrivedDt;
  bool isPassed;
  bool isCurrent;

  RouteCheckpoint({
    this.locationGuid,
    this.sequence,
    this.emoji,
    this.code,
    this.name,
    this.title,
    this.arrivedDt,
    this.isPassed = false,
    this.isCurrent = false,
  });

  RouteCheckpoint.fromJson(Map<String, dynamic> json)
    : locationGuid = json['location_guid'],
      sequence = int.tryParse('${json['sequence']}'),
      emoji = json['emoji'],
      code = json['code'],
      name = json['name'],
      title = json['title'] != null
          ? LocationTitle.fromJson(json['title'])
          : null,
      arrivedDt = json['arrived_dt'],
      isPassed = json['is_passed'] == true,
      isCurrent = json['is_current'] == true;

  /// Flag, or the ISO code when the admin set no flag.
  String get mark => emoji ?? code ?? '';

  /// Same fallbacks as [FromLocation.getLocalizedTitle].
  String localizedName(String langCode) {
    final base = title?.base;
    final fallback = name ?? code ?? '';
    if (base == null) return fallback;
    switch (langCode) {
      case 'tk':
        return base.titleTk ?? fallback;
      case 'ru':
        return base.titleRu ?? base.titleEn ?? fallback;
      case 'en':
        return base.titleEn ?? fallback;
      case 'tr':
        return base.titleTr ?? base.titleTk ?? fallback;
      case 'uz':
        return base.titleUz ?? base.titleTk ?? fallback;
      default:
        return fallback;
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
