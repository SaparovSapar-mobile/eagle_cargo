// import 'package:flutter/material.dart';
// import 'package:eagle_cargo/core/api/models/location_model.dart';
// import 'package:eagle_cargo/core/api/services/location_service.dart';

// class ShipmentProvider extends ChangeNotifier {
//   /// All countries
//   List<LocationModel> countries = [];

//   /// Selected FROM
//   LocationModel? selectedFromCountry;
//   LocationModel? selectedFromCity;
//   List<LocationModel> fromCities = [];

//   /// Selected TO
//   LocationModel? selectedToCountry;
//   LocationModel? selectedToCity;
//   List<LocationModel> toCities = [];

//   // -----------------------------
//   // Load all countries
//   // -----------------------------
//   Future<void> loadCountries() async {
//     final res = await LocationService.getLocations(limit: 200);
//     countries = res["data"];
//     notifyListeners();
//   }

//   // -----------------------------
//   // FROM Country Selected
//   // -----------------------------
//   Future<void> selectFromCountry(LocationModel country) async {
//     selectedFromCountry = country;
//     selectedFromCity = null;

//     // Load cities for selected country
//     final res = await LocationService.getCities(guid: country.locationGuid);
//     fromCities = res["data"];

//     // If TO country is same → reset
//     if (selectedToCountry?.locationGuid == country.locationGuid) {
//       selectedToCountry = null;
//       selectedToCity = null;
//       toCities = [];
//     }

//     notifyListeners();
//   }

//   // -----------------------------
//   // TO Country Selected
//   // -----------------------------
//   Future<void> selectToCountry(LocationModel country) async {
//     selectedToCountry = country;
//     selectedToCity = null;

//     // Load cities for selected country
//     final res = await LocationService.getCities(guid: country.locationGuid);
//     toCities = res["data"];

//     // If FROM country is same → reset
//     if (selectedFromCountry?.locationGuid == country.locationGuid) {
//       selectedFromCountry = null;
//       selectedFromCity = null;
//       fromCities = [];
//     }

//     notifyListeners();
//   }

//   // -----------------------------
//   // Cities Selected
//   // -----------------------------
//   void selectFromCity(LocationModel city) {
//     selectedFromCity = city;
//     notifyListeners();
//   }

//   void selectToCity(LocationModel city) {
//     selectedToCity = city;
//     notifyListeners();
//   }

//   // -----------------------------
//   // Filter countries (opposite side)
//   // -----------------------------
//   List<LocationModel> get fromCountryList {
//     return countries.where((c) => c.locationGuid != selectedToCountry?.locationGuid).toList();
//   }

//   List<LocationModel> get toCountryList {
//     return countries.where((c) => c.locationGuid != selectedFromCountry?.locationGuid).toList();
//   }
// }
