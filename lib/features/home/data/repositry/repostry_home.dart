import 'package:dartz/dartz.dart';
import 'package:raghad_pro/core/api/api_consumer.dart';
import 'package:raghad_pro/core/api/end_point.dart';
import 'package:raghad_pro/core/errors/exceptions.dart';
import 'package:raghad_pro/features/home/data/model/booking_model.dart';
import 'package:raghad_pro/features/home/data/model/doctor_spicializ_model.dart';
import 'package:raghad_pro/features/home/data/model/get_booking.dart';
import 'package:raghad_pro/features/home/data/model/rate_model.dart';
import 'package:raghad_pro/features/home/data/model/scedual_mode.dart';
import 'package:raghad_pro/features/home/data/model/search_model.dart';
import 'package:raghad_pro/features/home/data/model/slote_model.dart';
import 'package:raghad_pro/features/home/data/model/spizialize_model.dart';
import 'package:raghad_pro/features/home/data/model/top_doctor_model.dart';

class RepostryHome {
  final ApiConsumer api;
  RepostryHome(this.api);
// get spitialization
Future<Either<String, SpecializationResponse>> getSpecializations() async {
    try {
      final response = await api.get(EndPoint.specializations); 
      final Map<String, dynamic> rawData = response is Map<String, dynamic> ? response : {};
      return right(SpecializationResponse.fromJson(rawData));
    } on ServerException catch (e) {
      return left(e.errorModel.message);
    } catch (e) {
      return left("حدث خطأ أثناء تحميل الاختصاصات");
    }
  }
  // get top doctor

   Future<Either<String, TopDoctorResponse>> getTopDoctors() async {
    try {
      final response = await api.get(EndPoint.topDoctors); 
      final Map<String, dynamic> rawData = response is Map<String, dynamic> ? response : {};
      return right(TopDoctorResponse.fromJson(rawData));
    } on ServerException catch (e) {
      return left(e.errorModel.message);
    } catch (e) {
      return left("حدث خطأ أثناء تحميل الأطباء الأعلى تقييماً");
    }
  }
  //get doctor by spicialize
  Future<Either<String, DoctorBySpecialtyResponse>> getDoctorsBySpecialty(String specialtyId) async {
  try {
    final response = await api.get(EndPoint.getspecializationsId(specialtyId)); 
    
    final Map<String, dynamic> rawData = response is Map<String, dynamic> ? response : {};
    return right(DoctorBySpecialtyResponse.fromJson(rawData));
  } on ServerException catch (e) {
    return left(e.errorModel.message);
  } catch (e) {
    return left("حدث خطأ أثناء تحميل أطباء هذا الاختصاص");
  }
}
//get doctor schedual
/*Future<Either<String, DoctorScheduleResponse>> getDoctorSchedules(String doctorUuid) async {
  try {

    final response = await api.get(
      EndPoint.schedules, 
      queryParameters: {
        ApiKey.doctor_uuid: doctorUuid,
      },
    ); 
    
    final Map<String, dynamic> rawData = response is Map<String, dynamic> ? response : {};
    return right(DoctorScheduleResponse.fromJson(rawData));
  } on ServerException catch (e) {
    return left(e.errorModel.message);
  } catch (e) {
    return left("حدث خطأ أثناء تحميل جدول دوام الطبيب");
  }
}*/
// في الـ Repository: إلغاء إرسال Query Parameters
Future<Either<String, DoctorScheduleResponse>> getDoctorSchedules(String doctorUuid) async {
  try {
    final response = await api.get(
      EndPoint.schedules, // بدون queryParameters
    ); 
    
    final Map<String, dynamic> rawData = response is Map<String, dynamic> ? response : {};
    return right(DoctorScheduleResponse.fromJson(rawData));
  } on ServerException catch (e) {
    return left(e.errorModel.message);
  } catch (e) {
    return left("حدث خطأ أثناء تحميل جدول دوام الطبيب");
  }
}

//booking 
Future<Either<String, AppointmentResponse>> bookAppointment({
  required String doctorUuid,
  required String dateTime,
  required String type,
}) async {
  try {
    final response = await api.post(
      EndPoint.appointmentsStore,
      data: {
         ApiKey.doctor_uuid: doctorUuid,
        ApiKey.date_time: dateTime,
        ApiKey.type: type,
      },
    );

    final Map<String, dynamic> rawData = response is Map<String, dynamic> ? response : {};
    return right(AppointmentResponse.fromJson(rawData));
  } on ServerException catch (e) {
    return left(e.errorModel.message);
  } catch (e) {
    return left("حدث خطأ أثناء إتمام عملية الحجز");
  }
}
// get slots
Future<Either<String, DoctorSlotsResponse>> getDoctorSlots({
  required String doctorUuid,
  required String date,
}) async {
  try {
    final response = await api.get(
      EndPoint.doctorSlots,
      queryParameters: {
        ApiKey.doctor_uuid: doctorUuid,
        ApiKey.date: date,             
      },
    ); 
    
    final Map<String, dynamic> rawData = response is Map<String, dynamic> ? response : {};
    return right(DoctorSlotsResponse.fromJson(rawData));
  } on ServerException catch (e) {
    return left(e.errorModel.message);
  } catch (e) {
    return left("حدث خطأ أثناء تحميل الفترات المتاحة");
  }
}
// search
Future<Either<String, SearchResponseModel>> getSearch({
  required String query,
  required String searchType, 
}) async {
  try {
    final response = await api.get(
      '${EndPoint.search}/$searchType', 
      queryParameters: {ApiKey.query: query},
    );
    
    final Map<String, dynamic> rawData = response is Map<String, dynamic> ? response : {};
    
    
    return right(SearchResponseModel.fromJson(rawData, searchType));
    
  } on ServerException catch (e) {
    return left(e.errorModel.message);
  } catch (e) {
    return left("حدث خطأ أثناء جلب نتائج البحث الطبي");
  }
}
//rating
Future<Either<String, RatingResponse>> rateDoctor({
  required String doctorUuid,
  required int stars,
}) async {
  try {
    final response = await api.post(
      EndPoint.doctorRate,
      data: {
        ApiKey.doctor_uuid: doctorUuid,
        ApiKey.stars: stars,
      },
    );

    final Map<String, dynamic> rawData = response is Map<String, dynamic> ? response : {};
    return right(RatingResponse.fromJson(rawData));
  } on ServerException catch (e) {
    return left(e.errorModel.message);
  } catch (e) {
    return left("حدث خطأ أثناء إرسال التقييم");
  }
}
//getPatientAppointments
Future<Either<String, BookingResponse>> getPatientAppointments() async {
  try {
    // الرابط: /api/patient/appointments
    final response = await api.get(EndPoint.patientAppointments); 
    final Map<String, dynamic> rawData = response is Map<String, dynamic> ? response : {};
    return right(BookingResponse.fromJson(rawData));
  } on ServerException catch (e) {
    return left(e.errorModel.message);
  } catch (e) {
    return left("حدث خطأ أثناء تحميل قائمة المواعيد");
  }
}


Future<Either<String, String>> deleteAppointment(String appointmentUuid) async {
  try {
    
    final response = await api.delete(EndPoint.deleteAppointment(appointmentUuid)); 
    
    final Map<String, dynamic> rawData = response is Map<String, dynamic> ? response : {};
    
    if (rawData[ApiKey.success] == true) {
      return right(rawData[ApiKey.message] ?? "تم إلغاء وحذف الموعد بنجاح.");
    } else {
      return left(rawData[ApiKey.message] ?? "فشل إلغاء الموعد");
    }
  } on ServerException catch (e) {
    return left(e.errorModel.message);
  } catch (e) {
    return left("حدث خطأ أثناء محاولة إلغاء الموعد");
  }
}
//update PPOINMENT
Future<Either<String, BookingModel>> updateAppointment({
  required String appointmentUuid,
  required String doctorUuid,
  required String dateTime,
  required String type,
}) async {
  try {
   
    final response = await api.put(
      '${EndPoint.patientAppointments}/$appointmentUuid',
      data: {
        ApiKey.doctor_uuid: doctorUuid,
        ApiKey.date_time: dateTime,
        ApiKey.type: type,
      },
    );

    final Map<String, dynamic> rawData = response is Map<String, dynamic> ? response : {};
    if (rawData.containsKey(ApiKey.appointment)) {
      return right(BookingModel.fromJson(rawData[ApiKey.appointment]));
    } else {
      return left("فشل في قراءة بيانات الموعد المحدث من السيرفر");
    }
  } on ServerException catch (e) {
    return left(e.errorModel.message);
  } catch (e) {
    return left("حدث خطأ غير متوقع أثناء تعديل الموعد");
  }
}
//  book to some one 
Future<Either<String, AppointmentResponse>> bookForSomeone({
  required String name,
  required String nickName,
  required String phone,
  required String gender,
  required String birthday,
  required String doctorUuid,
  required String dateTime,
  required String type,
}) async {
  try {
    final response = await api.post(
      EndPoint.booksomeowen, 
      data: {
        ApiKey.name: name,
        ApiKey.nickName: nickName,
        ApiKey.phone: phone,
        ApiKey.gender: gender,
        ApiKey.birthday: birthday,
        ApiKey.doctor_uuid: doctorUuid,
        ApiKey.date_time: dateTime,
        ApiKey.type: type,
      },
    );
    
    final Map<String, dynamic> rawData = response is Map<String, dynamic> ? response : {};
    return right(AppointmentResponse.fromJson(rawData));
  } on ServerException catch (e) {
    return left(e.errorModel.message);
  } catch (e) {
    return left("حدث خطأ أثناء محاولة الحجز لشخص آخر");
  }
}
}





































//get schedual
/*
Future<Either<String, DoctorScheduleResponse>> getDoctorSchedules(String doctorUuid) async {
  try {
    final response = await api.get(
      EndPoint.schedules, 
      queryParameters: {
        ApiKey.doctor_uuid: doctorUuid,
      },
    ); 
    
    final Map<String, dynamic> rawData = response is Map<String, dynamic> ? response : {};
    var fullResponse = DoctorScheduleResponse.fromJson(rawData);
    
    final filteredData = fullResponse.data
        .where((schedule) => schedule.doctorUuid == doctorUuid)
        .toList();
    
    final modifiedSchedules = filteredData.where((s) => s.isModified).toList();
    final regularSchedules = filteredData.where((s) => !s.isModified).toList();
    
    List<DoctorScheduleModel> finalSchedule = [];
    finalSchedule.addAll(regularSchedules);
    
    for (var modified in modifiedSchedules) {
      final index = finalSchedule.indexWhere(
        (regular) => regular.day == modified.day
      );
      
      if (index != -1) {
       
        finalSchedule[index] = modified;
      } else {
        
        finalSchedule.add(modified);
      }
    }
    finalSchedule.sort((a, b) => 
      _dayOrder(a.day).compareTo(_dayOrder(b.day))
    );
    
    return right(DoctorScheduleResponse(
      success: fullResponse.success,
      data: finalSchedule,
    ));
    
  } on ServerException catch (e) {
    return left(e.errorModel.message);
  } catch (e) {
    return left("حدث خطأ أثناء تحميل جدول دوام الطبيب");
  }
}
int _dayOrder(String arabicDay) {
  const order = {
    'الأحد': 0,
    'الاثنين': 1,
    'الثلاثاء': 2,
    'الأربعاء': 3,
    'الخميس': 4,
    'الجمعة': 5,
    'السبت': 6,
  };
  return order[arabicDay] ?? 7;
}

*/