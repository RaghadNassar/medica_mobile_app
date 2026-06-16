
import 'package:get_storage/get_storage.dart';

class CacheHelperGetStorage {

  static final GetStorage _storage = GetStorage();

  
  static Future<void> init() async {
    await GetStorage.init();
  }

  static Future<void> saveData({required String key, required dynamic value}) async {
    return await _storage.write(key, value);
  }

  
  static dynamic getData({required String key}) {
    return _storage.read(key);
  }

 
  static String? getString({required String key}) => _storage.read<String>(key);
  static bool? getBool({required String key}) => _storage.read<bool>(key);
  static int? getInt({required String key}) => _storage.read<int>(key);
  static double? getDouble({required String key}) => _storage.read<double>(key);

 
  static Future<void> removeData({required String key}) async {
    return await _storage.remove(key);
  }

  
  static bool containsKey({required String key}) {
    return _storage.hasData(key);
  }

  
  static Future<void> clearData() async {
    return await _storage.erase();
  }
}