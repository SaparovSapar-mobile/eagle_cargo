class PaymentInfoResponse {
  final String? firmGuid;
  final String? name;
  final String? slug;
  final String? image;
  final String? imagePrint;
  final SettingsTheme? settingsTheme;
  final PaymentData? paymentData;
  final Contact? contact;
  final String? rating;
  final bool? isActive;

  PaymentInfoResponse({
    this.firmGuid,
    this.name,
    this.slug,
    this.image,
    this.imagePrint,
    this.settingsTheme,
    this.paymentData,
    this.contact,
    this.rating,
    this.isActive,
  });

  factory PaymentInfoResponse.fromJson(Map<String, dynamic> json) => PaymentInfoResponse(
        firmGuid: json["firm_guid"],
        name: json["name"],
        slug: json["slug"],
        image: json["image"],
        imagePrint: json["image_print"],
        settingsTheme: json["settings_theme"] == null 
            ? null 
            : SettingsTheme.fromJson(json["settings_theme"]),
        paymentData: json["payment_data"] == null 
            ? null 
            : PaymentData.fromJson(json["payment_data"]),
        contact: json["contact"] == null 
            ? null 
            : Contact.fromJson(json["contact"]),
        rating: json["rating"],
        isActive: json["is_active"],
      );
}

class SettingsTheme {
  final ThemeBase? base;

  SettingsTheme({this.base});

  factory SettingsTheme.fromJson(Map<String, dynamic> json) => SettingsTheme(
        base: json["base"] == null ? null : ThemeBase.fromJson(json["base"]),
      );
}

class ThemeBase {
  final String? btnColor;
  final String? iconColor;
  final String? borderColor;
  final String? headerColor;
  final String? sidebarColor;

  ThemeBase({
    this.btnColor,
    this.iconColor,
    this.borderColor,
    this.headerColor,
    this.sidebarColor,
  });

  factory ThemeBase.fromJson(Map<String, dynamic> json) => ThemeBase(
        btnColor: json["btnColor"],
        iconColor: json["iconColor"],
        borderColor: json["borderColor"],
        headerColor: json["headerColor"],
        sidebarColor: json["sidebarColor"],
      );
}

class PaymentData {
  final PaymentBase? base;

  PaymentData({this.base});

  factory PaymentData.fromJson(Map<String, dynamic> json) => PaymentData(
        base: json["base"] == null ? null : PaymentBase.fromJson(json["base"]),
      );
}

class PaymentBase {
  final String? otherQr;
  final String? alipayQr;
  final String? wechatQr;
  final String? otherLink;
  final String? alipayLink;
  final String? wechatLink;

  PaymentBase({
    this.otherQr,
    this.alipayQr,
    this.wechatQr,
    this.otherLink,
    this.alipayLink,
    this.wechatLink,
  });

  factory PaymentBase.fromJson(Map<String, dynamic> json) => PaymentBase(
        otherQr: json["other_qr"],
        alipayQr: json["alipay_qr"],
        wechatQr: json["wechat_qr"],
        otherLink: json["other_link"],
        alipayLink: json["alipay_link"],
        wechatLink: json["wechat_link"],
      );
}

class Contact {
  final ContactBase? base;

  Contact({this.base});

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        base: json["base"] == null ? null : ContactBase.fromJson(json["base"]),
      );
}

class ContactBase {
  final String? email;
  final String? phone;

  ContactBase({this.email, this.phone});

  factory ContactBase.fromJson(Map<String, dynamic> json) => ContactBase(
        email: json["email"],
        phone: json["phone"],
      );
}