class FirmDetailResponse {
  String? firmGuid;
  String? name;
  String? slug;
  String? phone;
  String? phone2;
  String? phone3;
  String? email;
  String? image;
  String? imagePrint;
  String? about;
  String? headColor;
  String? navColor;
  String? buttonColor;
  ContactInfo? contact;
  AppSettings? settingsApp;
  ThemeSettings? settingsTheme;
  PaymentData? paymentData;
  bool? isActive;
  String? rating;
  DateTime? createdDt;
  DateTime? updatedDt;

  FirmDetailResponse({
    this.firmGuid,
    this.name,
    this.slug,
    this.phone,
    this.phone2,
    this.phone3,
    this.email,
    this.image,
    this.imagePrint,
    this.about,
    this.headColor,
    this.navColor,
    this.buttonColor,
    this.contact,
    this.settingsApp,
    this.settingsTheme,
    this.paymentData,
    this.isActive,
    this.rating,
    this.createdDt,
    this.updatedDt,
  });

  factory FirmDetailResponse.fromJson(Map<String, dynamic> json) {
    return FirmDetailResponse(
      firmGuid: json['firm_guid'],
      name: json['name'],
      slug: json['slug'],
      phone: json['phone'],
      phone2: json['phone2'],
      phone3: json['phone3'],
      email: json['email'],
      image: json['image'],
      imagePrint: json['image_print'],
      about: json['about'],
      headColor: json['headColor'],
      navColor: json['navColor'],
      buttonColor: json['buttonColor'],
      contact: json['contact'] != null ? ContactInfo.fromJson(json['contact']) : null,
      settingsApp: json['settings_app'] != null ? AppSettings.fromJson(json['settings_app']) : null,
      settingsTheme: json['settings_theme'] != null ? ThemeSettings.fromJson(json['settings_theme']) : null,
      paymentData: json['payment_data'] != null ? PaymentData.fromJson(json['payment_data']) : null,
      isActive: json['is_active'],
      rating: json['rating'],
      createdDt: json['created_dt'] != null ? DateTime.parse(json['created_dt']) : null,
      updatedDt: json['updated_dt'] != null ? DateTime.parse(json['updated_dt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firm_guid': firmGuid,
      'name': name,
      'slug': slug,
      'phone': phone,
      'phone2': phone2,
      'phone3': phone3,
      'email': email,
      'image': image,
      'image_print': imagePrint,
      'about': about,
      'headColor': headColor,
      'navColor': navColor,
      'buttonColor': buttonColor,
      'contact': contact?.toJson(),
      'settings_app': settingsApp?.toJson(),
      'settings_theme': settingsTheme?.toJson(),
      'payment_data': paymentData?.toJson(),
      'is_active': isActive,
      'rating': rating,
      'created_dt': createdDt?.toIso8601String(),
      'updated_dt': updatedDt?.toIso8601String(),
    };
  }
}

class ContactInfo {
  String? email;
  String? phone;

  ContactInfo({this.email, this.phone});

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    final base = json['base'] ?? {};
    return ContactInfo(
      email: base['email'],
      phone: base['phone'],
    );
  }

  Map<String, dynamic> toJson() => {
    'base': {'email': email, 'phone': phone}
  };
}

class AppSettings {
  bool? mizanBtn;
  bool? orderLine;
  bool? deleteNote;
  bool? deleteOrder;
  bool? pickupInput;
  bool? firmAllView;
  bool? packageInput;
  bool? deliveryInput;
  bool? orderAddMain;
  bool? mainTransportInput;
  bool? orderShipmentNullable;
  bool? whDeliverShipmentAdd;

  AppSettings({
    this.mizanBtn, this.orderLine, this.deleteNote, this.deleteOrder,
    this.pickupInput, this.firmAllView, this.packageInput, this.deliveryInput,
    this.orderAddMain, this.mainTransportInput, this.orderShipmentNullable,
    this.whDeliverShipmentAdd,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    final b = json['base'] ?? {};
    return AppSettings(
      mizanBtn: b['mizan_btn'],
      orderLine: b['order_line'],
      deleteNote: b['delete_note'],
      deleteOrder: b['delete_order'],
      pickupInput: b['pickup_input'],
      firmAllView: b['firm_all_view'],
      packageInput: b['package_input'],
      deliveryInput: b['delivery_input'],
      orderAddMain: b['order_add_main'],
      mainTransportInput: b['main_transport_input'],
      orderShipmentNullable: b['order_shipment_nullable'],
      whDeliverShipmentAdd: b['wh_deliver_shipment_add'],
    );
  }

  Map<String, dynamic> toJson() => {
    'base': {
      'mizan_btn': mizanBtn,
      'order_line': orderLine,
      'delete_note': deleteNote,
      'delete_order': deleteOrder,
      'pickup_input': pickupInput,
      'firm_all_view': firmAllView,
      'package_input': packageInput,
      'delivery_input': deliveryInput,
      'order_add_main': orderAddMain,
      'main_transport_input': mainTransportInput,
      'order_shipment_nullable': orderShipmentNullable,
      'wh_deliver_shipment_add': whDeliverShipmentAdd,
    }
  };
}

class ThemeSettings {
  String? btnColor;
  String? iconColor;
  String? borderColor;
  String? headerColor;
  String? sidebarColor;

  ThemeSettings({this.btnColor, this.iconColor, this.borderColor, this.headerColor, this.sidebarColor});

  factory ThemeSettings.fromJson(Map<String, dynamic> json) {
    final b = json['base'] ?? {};
    return ThemeSettings(
      btnColor: b['btnColor'],
      iconColor: b['iconColor'],
      borderColor: b['borderColor'],
      headerColor: b['headerColor'],
      sidebarColor: b['sidebarColor'],
    );
  }

  Map<String, dynamic> toJson() => {
    'base': {
      'btnColor': btnColor,
      'iconColor': iconColor,
      'borderColor': borderColor,
      'headerColor': headerColor,
      'sidebarColor': sidebarColor,
    }
  };
}

class PaymentData {
  String? otherQr;
  String? alipayQr;
  String? wechatQr;
  String? otherLink;
  String? alipayLink;
  String? wechatLink;

  PaymentData({this.otherQr, this.alipayQr, this.wechatQr, this.otherLink, this.alipayLink, this.wechatLink});

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    final b = json['base'] ?? {};
    return PaymentData(
      otherQr: b['other_qr'],
      alipayQr: b['alipay_qr'],
      wechatQr: b['wechat_qr'],
      otherLink: b['other_link'],
      alipayLink: b['alipay_link'],
      wechatLink: b['wechat_link'],
    );
  }

  Map<String, dynamic> toJson() => {
    'base': {
      'other_qr': otherQr,
      'alipay_qr': alipayQr,
      'wechat_qr': wechatQr,
      'other_link': otherLink,
      'alipay_link': alipayLink,
      'wechat_link': wechatLink,
    }
  };
}