// import 'package:shared_preferences/shared_preferences.dart';

// class CacheHelper {
//   static late SharedPreferences sharedPreferences;

// //! Here The Initialize of cache .
//   Future<void> init() async {
//     sharedPreferences = await SharedPreferences.getInstance();
//   }

//   String? getString({required String key}) {
//     return sharedPreferences.getString(key);
//   }

//   bool? getBool({required String key}) {
//     return sharedPreferences.getBool(key);
//   }

//   int? getInt({required String key}) {
//     return sharedPreferences.getInt(key);
//   }

//   double? getDouble({required String key}) {
//     return sharedPreferences.getDouble(key);
//   }

// //! this method to put data in local database using key

//   Future<bool> saveData({required String key, required dynamic value}) async {
//     if (value is bool) {
//       return await sharedPreferences.setBool(key, value);
//     }

//     if (value is String) {
//       return await sharedPreferences.setString(key, value);
//     }

//     if (value is int) {
//       return await sharedPreferences.setInt(key, value);
//     } else {
//       return await sharedPreferences.setDouble(key, value);
//     }
//   }

// //! this method to get data already saved in local database

//   dynamic getData({required String key}) {
//     return sharedPreferences.get(key);
//   }

//   Future<bool> setBool({required String key, required bool value}) async {
//     return sharedPreferences.setBool(key, value);
//   }

//   Future<bool> setString({required String key, required String value}) async {
//     return sharedPreferences.setString(key, value);
//   }

//   Future<bool> setInt({required String key, required int value}) async {
//     return sharedPreferences.setInt(key, value);
//   }

//   Future<bool> setDouble({required String key, required double value}) async {
//     return sharedPreferences.setDouble(key, value);
//   }

// //! remove data using specific key

//   Future<bool> removeData({required String key}) async {
//     return await sharedPreferences.remove(key);
//   }

// //! this method to check if local database contains {key}
//   Future<bool> containsKey({required String key}) async {
//     return sharedPreferences.containsKey(key);
//   }

//   Future<bool> clearData() async {
//     return sharedPreferences.clear();
//   }

// //! this fun to put data in local data base using key
//   Future<dynamic> put({
//     required String key,
//     required dynamic value,
//   }) async {
//     if (value is String) {
//       return await sharedPreferences.setString(key, value);
//     } else if (value is bool) {
//       return await sharedPreferences.setBool(key, value);
//     } else {
//       return await sharedPreferences.setInt(key, value);
//     }
//   }
// }
