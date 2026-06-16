import 'package:dartz/dartz.dart';
import 'package:raghad_pro/core/api/api_consumer.dart';
import 'package:raghad_pro/core/api/end_point.dart';
import 'package:raghad_pro/core/errors/exceptions.dart';
import 'package:raghad_pro/features/profile/data/model/hestory_medical.dart';
import 'package:raghad_pro/features/profile/data/model/profile_model.dart';
class ProfileRepostry {
  final ApiConsumer api;

  ProfileRepostry(this.api);
 
  // profile 
  Future<Either<String, ProfileModel>> getPatientProfile() async {
  try {
   
    final response = await api.get(EndPoint.profile);
    
    final Map<String, dynamic> rawData = response is Map<String, dynamic> ? response : {};
    
   
    final profileData = ProfileModel.fromJson(rawData);
    
    return right(profileData);
  } on ServerException catch (e) {
    return left(e.errorModel.message);
  } catch (e) {
    return left("حدث خطأ أثناء جلب بيانات الملف الشخصي");
  }
}
// get histiry medical 
Future<Either<String, List<MedicalRecordModel>>> getMedicalHistory() async {
    try {
     
      final response = await api.get(EndPoint.myHistory); 
      
      final Map<String, dynamic> rawData = response is Map<String, dynamic> ? response : {};
      final List<dynamic> dataList = rawData[ApiKey.data] ?? [];

      final medicalRecords = dataList
          .map((json) => MedicalRecordModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return right(medicalRecords);
    } on ServerException catch (e) {
      return left(e.errorModel.message);
    } catch (e) {
      return left("حدث خطأ أثناء جلب الملف المرضي");
    }
  }
  //logout
  Future<Either<String, String>> logout() async {
  try {
   
    final response = await api.post(EndPoint.logout,);
    
    final Map<String, dynamic> rawData = response is Map<String, dynamic> ? response : {};
    final String successMessage = rawData[ApiKey.message] ?? "Sign out successful";

    return right(successMessage);
  } on ServerException catch (e) {
    return left(e.errorModel.message);
  } catch (e) {
    return left("حدث خطأ أثناء تسجيل الخروج");
  }
}
//  update profile 
Future<Either<String, ProfileModel>> updatePatientProfile({
  required Map<String, dynamic> updateData,
}) async {
  try {
    
    final response = await api.post(
      EndPoint.updateProfile,
      data: updateData,
      isFormData: true,
    );

    final Map<String, dynamic> rawData = response is Map<String, dynamic> ? response : {};
    return right(ProfileModel.fromJson(rawData));
  } on ServerException catch (e) {
    return left(e.errorModel.message);
  } catch (e) {
    return left("حدث خطأ أثناء تحديث بيانات الملف الشخصي");
  }
} 
} 

