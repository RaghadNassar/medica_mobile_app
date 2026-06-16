import 'package:dartz/dartz.dart';
import 'package:raghad_pro/core/api/api_consumer.dart';
import 'package:raghad_pro/core/api/end_point.dart';
import 'package:raghad_pro/core/cache/cashe_helper_getStorage.dart';
import 'package:raghad_pro/core/errors/exceptions.dart';
import 'package:raghad_pro/features/auth/data/model/login_model.dart';
import 'package:raghad_pro/features/profile/data/model/profile_model.dart';

class AuthRepostry {
  final ApiConsumer api;

  AuthRepostry(this.api);
  //login
  Future<Either<String, LoginModel>> login(
      {required email, required password}) async {
    try {
      final response = await api.post(EndPoint.signIn,
          data: {ApiKey.email: email, ApiKey.password: password});
      final Map<String, dynamic> finalData =
          (response is List && response.isNotEmpty)
              ? response[0] as Map<String, dynamic>
              : response as Map<String, dynamic>;
      final user = LoginModel.fromJson(finalData);
      CacheHelperGetStorage.saveData(key: ApiKey.token, value: user!.token);
      CacheHelperGetStorage.saveData(key: ApiKey.uuid, value: user!.user.uuid);
      return right(user);
    } on ServerException catch (e) {
      return left(e.errorModel.message);
    }
  }
  // regester

  Future<Either<String, LoginModel>> register({
    required String name,
    required String nickName,
    required String email,
    required String password,
    required String confirmPassword,
    required String phone,
    required String gender,
    required String dateOfBirth,
  }) async {
    try {
      final response = await api.post(
        EndPoint.signUp,
        data: {
          ApiKey.name: name,
          ApiKey.nickName: nickName,
          ApiKey.email: email,
          ApiKey.password: password,
          ApiKey.confirmPassword: confirmPassword,
          ApiKey.phone: phone,
          ApiKey.gender: gender,
          ApiKey.dateOfBirth: dateOfBirth,
        },
      );
      final Map<String, dynamic> rawData =
          response is Map<String, dynamic> ? response : {};
      final Map<String, dynamic> finalData = rawData[ApiKey.data] ?? rawData;

      final userModel = LoginModel.fromJson(finalData);

      await CacheHelperGetStorage.saveData(
          key: ApiKey.token, value: userModel.token);
      await CacheHelperGetStorage.saveData(
          key: ApiKey.uuid, value: userModel.user.uuid);

      return right(userModel);
    } on ServerException catch (e) {
      return left(e.errorModel.message);
    } catch (e) {
      return left("حدث خطأ أثناء إنشاء الحساب، يرجى المحاولة لاحقاً");
    }
  }

  // profile
  Future<Either<String, ProfileModel>> getPatientProfile() async {
    try {
      final response = await api.get(EndPoint.profile);

      final Map<String, dynamic> rawData =
          response is Map<String, dynamic> ? response : {};

      final profileData = ProfileModel.fromJson(rawData);

      return right(profileData);
    } on ServerException catch (e) {
      return left(e.errorModel.message);
    } catch (e) {
      return left("حدث خطأ أثناء جلب بيانات الملف الشخصي");
    }
  }

// Forget Password
  Future<Either<String, Map<String, dynamic>>> forgetPassword(
      {required String email}) async {
    try {
      // تمرير الـ EndPoint والـ Body المطلوب "email"
      final response = await api.post(
        EndPoint.forgetPassword,
        data: {ApiKey.email: email},
      );

      final Map<String, dynamic> rawData =
          response is Map<String, dynamic> ? response : {};
      if (rawData[ApiKey.success] == true) {
        return right(rawData);
      } else {
        return left(
            rawData[ApiKey.success] ?? "حدث خطأ ما، يرجى المحاولة لاحقاً");
      }
    } on ServerException catch (e) {
      return left(e.errorModel.message);
    } catch (e) {
      return left("فشل الاتصال بالسيرفر، يرجى التحقق من الشبكة");
    }
  }

  // Verify OTP
  Future<Either<String, Map<String, dynamic>>> verifyOtp({
    required String email,
    required String code,
  }) async {
    try {
      // ملاحظة: الـ API يتوقع حقل 'contact' عند التحقق من الكود، لذلك نرسل القيمة تحت هذا المفتاح
      final response = await api.post(
        EndPoint.verifyOtp,
        data: {
          ApiKey.contact: email,
          ApiKey.code: code,
        },
      );

      final Map<String, dynamic> rawData =
          response is Map<String, dynamic> ? response : {};

      if (rawData[ApiKey.success] == true) {
        return right(rawData);
      } else {
        return left(rawData[ApiKey.message] ?? "الكود المدخل غير صحيح");
      }
    } on ServerException catch (e) {
      return left(e.errorModel.message);
    } catch (e) {
      return left("فشل التحقق من الكود، يرجى المحاولة لاحقاً");
    }
  }

  // Reset Password
  Future<Either<String, Map<String, dynamic>>> resetPassword({
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await api.post(
        EndPoint.resetPassword,
        data: {
          ApiKey.contact: email,
          ApiKey.password: password,
          // الخادم يتوقع المفتاح 'password_confirmation'
          ApiKey.passwordConfirmation: passwordConfirmation,
        },
      );

      final Map<String, dynamic> rawData =
          response is Map<String, dynamic> ? response : {};

      if (rawData[ApiKey.success] == true) {
        return right(rawData);
      } else {
        return left(
            rawData[ApiKey.message] ?? "حدث خطأ أثناء تحديث كلمة المرور");
      }
    } on ServerException catch (e) {
      return left(e.errorModel.message);
    } catch (e) {
      return left("فشل الاتصال بالسيرفر، يرجى المحاولة لاحقاً");
    }
  }
}
