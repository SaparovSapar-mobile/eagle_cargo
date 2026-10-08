class FirmRateModel {
  String? firmRateGuid;
  String? firmGuid;
  String? fromLocGuid;
  String? toLocGuid;
  RateLocation? fromLocation;
  RateLocation? toLocation;
  String? transportType;
  String? rateType;
  String? serviceType;
  String? pricePerKg;
  String? pricePerM3;
  String? minCharge;
  String? currency;
  String? deadline;
  String? deadlineText;
  bool? isActive;
  String? createdDt;

  FirmRateModel({
    this.firmRateGuid,
    this.firmGuid,
    this.fromLocGuid,
    this.toLocGuid,
    this.fromLocation,
    this.toLocation,
    this.transportType,
    this.rateType,
    this.serviceType,
    this.pricePerKg,
    this.pricePerM3,
    this.minCharge,
    this.currency,
    this.deadline,
    this.deadlineText,
    this.isActive,
    this.createdDt,
  });

  FirmRateModel.fromJson(Map<String, dynamic> json) {
    firmRateGuid = json['firm_rate_guid'];
    firmGuid = json['firm_guid'];
    fromLocGuid = json['from_loc_guid'];
    toLocGuid = json['to_loc_guid'];
    fromLocation = json['from_location'] != null
        ? RateLocation.fromJson(json['from_location'])
        : null;
    toLocation = json['to_location'] != null
        ? RateLocation.fromJson(json['to_location'])
        : null;
    transportType = json['transport_type'];
    rateType = json['rate_type'];
    serviceType = json['service_type'];
    pricePerKg = json['price_per_kg'];
    pricePerM3 = json['price_per_m3'];
    minCharge = json['min_charge'];
    currency = json['currency'];
    deadline = json['deadline'];
    deadlineText = json['deadline_text'];
    isActive = json['is_active'];
    createdDt = json['created_dt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firm_rate_guid'] = firmRateGuid;
    data['firm_guid'] = firmGuid;
    data['from_loc_guid'] = fromLocGuid;
    data['to_loc_guid'] = toLocGuid;
    if (fromLocation != null) {
      data['from_location'] = fromLocation!.toJson();
    }
    if (toLocation != null) {
      data['to_location'] = toLocation!.toJson();
    }
    data['transport_type'] = transportType;
    data['rate_type'] = rateType;
    data['service_type'] = serviceType;
    data['price_per_kg'] = pricePerKg;
    data['price_per_m3'] = pricePerM3;
    data['min_charge'] = minCharge;
    data['currency'] = currency;
    data['deadline'] = deadline;
    data['deadline_text'] = deadlineText;
    data['is_active'] = isActive;
    data['created_dt'] = createdDt;
    return data;
  }
}

class RateLocation {
  String? locationGuid;
  RateTitle? title;

  RateLocation({this.locationGuid, this.title});

  RateLocation.fromJson(Map<String, dynamic> json) {
    locationGuid = json['location_guid'];
    title = json['title'] != null ? RateTitle.fromJson(json['title']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['location_guid'] = locationGuid;
    if (title != null) {
      data['title'] = title!.toJson();
    }
    return data;
  }

  String getLocalizedTitle(String langCode) {
    final base = title?.base;
    if (base == null) return "";
    switch (langCode) {
      case 'tk':
        return base.titleTk ?? "";
      case 'ru':
        return base.titleRu ?? "";
      case 'en':
        return base.titleEn ?? "";
      case 'tr':
        return base.titleTr ?? base.titleTk ?? "";
      case 'uz':
        return base.titleUz ?? base.titleTk ?? "";
      default:
        return "";
    }
  }
}

class RateTitle {
  RateTitleBase? base;

  RateTitle({this.base});

  RateTitle.fromJson(Map<String, dynamic> json) {
    base = json['base'] != null ? RateTitleBase.fromJson(json['base']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (base != null) {
      data['base'] = base!.toJson();
    }
    return data;
  }
}

class RateTitleBase {
  String? titleEn;
  String? titleRu;
  String? titleTk;
  String? titleTr;
  String? titleUz;

  RateTitleBase({
    this.titleEn,
    this.titleRu,
    this.titleTk,
    this.titleTr,
    this.titleUz,
  });

  RateTitleBase.fromJson(Map<String, dynamic> json) {
    titleEn = json['title_en'];
    titleRu = json['title_ru'];
    titleTk = json['title_tk'];
    titleTr = json['title_tr'];
    titleUz = json['title_uz'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title_en'] = titleEn;
    data['title_ru'] = titleRu;
    data['title_tk'] = titleTk;
    data['title_tr'] = titleTr;
    data['title_uz'] = titleUz;
    return data;
  }
}
