import 'package:eagle_cargo/core/api/models/firm_model.dart';
import 'package:eagle_cargo/core/api/models/package_model.dart';

class OrderModel {
  String? orderGuid;
  String? orderNumber;
  String? orderCode;
  String? orderLine;
  String? firmGuid;
  String? customerGuid;
  String? fromLocationGuid;
  String? toLocationGuid;
  String? senderName;
  String? senderPhone;
  String? receiverName;
  String? receiverPhone;
  String? receiverAddress;
  String? status;
  String? serviceType;
  String? transportType;
  num? estimatedCost;
  num? finalCost;
  String? currency;
  String? currencyPickup;
  String? currencyDelive;
  String? currencyPackage;
  String? note;
  num? pickupCost;
  num? packageCost;
  num? deliveryCost;
  num? mainTransportCost;
  String? exchangeRateDate;
  Map<String, dynamic>? exchangeRatesSnapshot;
  String? totalCostTmt;
  String? removerGuid;
  String? createdDt;
  String? updatedDt;
  FirmModel? firm;
  Customer? customer;
  PackageModel? package;
  FromLocation? fromLocation;
  FromLocation? toLocation;

  OrderModel({
    this.orderGuid,
    this.orderNumber,
    this.orderCode,
    this.orderLine,
    this.firmGuid,
    this.customerGuid,
    this.fromLocationGuid,
    this.toLocationGuid,
    this.senderName,
    this.senderPhone,
    this.receiverName,
    this.receiverPhone,
    this.receiverAddress,
    this.status,
    this.serviceType,
    this.transportType,
    this.estimatedCost,
    this.finalCost,
    this.currency,
    this.currencyPickup,
    this.currencyDelive,
    this.currencyPackage,
    this.note,
    this.pickupCost,
    this.packageCost,
    this.deliveryCost,
    this.mainTransportCost,
    this.exchangeRateDate,
    this.exchangeRatesSnapshot,
    this.totalCostTmt,
    this.removerGuid,
    this.createdDt,
    this.updatedDt,
    this.firm,
    this.package,
    this.customer,
    this.fromLocation,
    this.toLocation,
  });

  OrderModel.fromJson(Map<String, dynamic> json) {
    orderGuid = json['order_guid'];
    orderNumber = json['order_number'];
    orderCode = json['order_code'];
    orderLine = json['order_line']?.toString();
    firmGuid = json['firm_guid'];
    customerGuid = json['customer_guid'];
    fromLocationGuid = json['from_location_guid'];
    toLocationGuid = json['to_location_guid'];
    senderName = json['sender_name'];
    senderPhone = json['sender_phone'];
    receiverName = json['receiver_name'];
    receiverPhone = json['receiver_phone'];
    receiverAddress = json['receiver_address'];
    status = json['status'];
    serviceType = json['service_type'];
    transportType = json['transport_type'];
    estimatedCost = num.tryParse(json['estimated_cost']?.toString() ?? '');
    finalCost = num.tryParse(json['final_cost']?.toString() ?? '');
    currency = json['currency'];
    currencyPickup = json['currency_pickup'];
    currencyDelive = json['currency_delive'];
    currencyPackage = json['currency_package'];
    note = json['note'];
    pickupCost = num.tryParse(json['pickup_cost']?.toString() ?? '');
    packageCost = num.tryParse(json['package_cost']?.toString() ?? '');
    deliveryCost = num.tryParse(json['delivery_cost']?.toString() ?? '');
    mainTransportCost = num.tryParse(
      json['main_transport_cost']?.toString() ?? '',
    );
    exchangeRateDate = json['exchange_rate_date'];
    exchangeRatesSnapshot = json['exchange_rates_snapshot'] is Map
        ? json['exchange_rates_snapshot'] as Map<String, dynamic>
        : null;
    totalCostTmt = (json['total_cost_tmt'] ?? json['total_cost'])?.toString();
    removerGuid = json['remover_guid'];
    createdDt = json['created_dt'];
    updatedDt = json['updated_dt'];

    firm = json['firm'] != null ? FirmModel.fromJson(json['firm']) : null;
    customer = json['customer'] != null
        ? Customer.fromJson(json['customer'])
        : null;
    package = json['package'] != null
        ? PackageModel.fromJson(json['package'])
        : null;
    fromLocation = json['from_location'] != null
        ? FromLocation.fromJson(json['from_location'])
        : null;
    toLocation = json['to_location'] != null
        ? FromLocation.fromJson(json['to_location'])
        : null;
  }
}

class Customer {
  String? userGuid;
  String? login;
  String? password;
  String? role;
  String? fullname;
  String? phone;
  String? email;
  String? avatar;
  bool? isActive;
  bool? isVerified;
  String? lastOnline;
  String? createdDt;
  String? updatedDt;

  Customer({
    this.userGuid,
    this.login,
    this.password,
    this.role,
    this.fullname,
    this.phone,
    this.email,
    this.avatar,
    this.isActive,
    this.isVerified,
    this.lastOnline,
    this.createdDt,
    this.updatedDt,
  });

  Customer.fromJson(Map<String, dynamic> json) {
    userGuid = json['user_guid'];
    login = json['login'];
    password = json['password'];
    role = json['role'];
    fullname = json['fullname'];
    phone = json['phone'];
    email = json['email'];
    avatar = json['avatar'];
    isActive = json['is_active'];
    isVerified = json['is_verified'];
    lastOnline = json['last_online'];
    createdDt = json['created_dt'];
    updatedDt = json['updated_dt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_guid'] = userGuid;
    data['login'] = login;
    data['password'] = password;
    data['role'] = role;
    data['fullname'] = fullname;
    data['phone'] = phone;
    data['email'] = email;
    data['avatar'] = avatar;
    data['is_active'] = isActive;
    data['is_verified'] = isVerified;
    data['last_online'] = lastOnline;
    data['created_dt'] = createdDt;
    data['updated_dt'] = updatedDt;
    return data;
  }
}

class FromLocation {
  String? locationGuid;
  LocationTitle? title;
  String? name;
  String? nameEn;
  String? parentGuid;
  int? level;
  bool? isActive;
  String? latitude;
  String? longitude;
  String? createdDt;

  FromLocation({
    this.locationGuid,
    this.title,
    this.name,
    this.nameEn,
    this.parentGuid,
    this.level,
    this.isActive,
    this.latitude,
    this.longitude,
    this.createdDt,
  });

  FromLocation.fromJson(Map<String, dynamic> json) {
    locationGuid = json['location_guid'];
    title = json['title'] != null
        ? LocationTitle.fromJson(json['title'])
        : null;
    name = json['name'];
    nameEn = json['name_en'];
    parentGuid = json['parent_guid'];
    level = json['level'];
    isActive = json['is_active'];
    latitude = json['latitude']?.toString();
    longitude = json['longitude']?.toString();
    createdDt = json['created_dt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['location_guid'] = locationGuid;
    data['name'] = name;
    data['name_en'] = nameEn;
    data['parent_guid'] = parentGuid;
    data['level'] = level;
    data['is_active'] = isActive;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['created_dt'] = createdDt;
    return data;
  }

  String getLocalizedTitle(String langCode) {
    final base = title?.base;
    if (base == null) return name ?? "";
    switch (langCode) {
      case 'tk':
        return base.titleTk ?? name ?? "";
      case 'ru':
        return base.titleRu ?? nameEn ?? "";
      case 'en':
        return base.titleEn ?? nameEn ?? "";
      case 'tr':
        return base.titleTr ?? base.titleTk ?? name ?? "";
      case 'uz':
        return base.titleUz ?? base.titleTk ?? name ?? "";
      default:
        return name ?? "";
    }
  }
}

class LocationTitle {
  LocationTitleBase? base;

  LocationTitle({this.base});

  LocationTitle.fromJson(Map<String, dynamic> json) {
    base = json['base'] != null
        ? LocationTitleBase.fromJson(json['base'])
        : null;
  }
}

class LocationTitleBase {
  String? titleEn;
  String? titleRu;
  String? titleTk;
  String? titleTr;
  String? titleUz;

  LocationTitleBase({
    this.titleEn,
    this.titleRu,
    this.titleTk,
    this.titleTr,
    this.titleUz,
  });

  LocationTitleBase.fromJson(Map<String, dynamic> json) {
    titleEn = json['title_en'];
    titleRu = json['title_ru'];
    titleTk = json['title_tk'];
    titleTr = json['title_tr'];
    titleUz = json['title_uz'];
  }
}
