/*class EndPoint {
  static String baseUrl = 'http://10.34.127.205:8000/api/patient';
  static String signIn = '/login';
  static String signUp = '/register';
  static String profile = '/profile';
  static String specializations = '/specializations';
 static String search = '/search';
  static String getspecializationsId(id) {
    return '/specializations/$id/doctors';
  }

  static String schedules = '/schedules';
  static String myHistory = '/my-history';
  static String appointmentsStore = '/appointments/store';
  static String doctorRate = '/doctor/rate';
  static String topDoctors = '/top-doctors';
  static String doctorSlots = '/doctor-slots';
  static String logout = '/logout';
  static String updateProfile = '/profile/update';
  // FCM token update and chat endpoints
 
 // Chat
  static const String getAllPotentialContacts = "/chat/potential-contacts"; // GET

 // notifications
  static const String updateFcmToken = "/update-fcm-token"; // 👈 الرابط الجديد لتوكن الإشعارات

  static const String myNotifications = "/notification/my-notifications"; // جلب الكل (أضف /doctor إذا كان محمي بنفس البريفكس)
  static const String notificationCount = "/notification/my-notifications/count"; // عداد الإشعارات
  static const String deleteAllNotifications = "/notification/my-notifications/delete-all"; // مسح الكل

  // دوال ديناميكية لتوليد الروابط بناءً على الـ UUID الخاص بالإشعار
  static String markAsReadUrl(String uuid) => "/notification/my-notifications/$uuid/seen"; // (أو حسب مسار التحديث لديك)
  static String deleteNotificationUrl(String uuid) => "/notification/my-notifications/$uuid/delete";

 // --- Chat (المستخدمة في الكود ولكن غير موجودة - أضفها) ---
  static const String getOrCreateRoom = "/chat/get-or-create-room";     // POST
  static const String uploadFile = "/chat/upload";                       // POST
  static const String uploadAttachment = "/chat/attachments/upload";     // POST
  static const String storeMessage = "/chat/store-message";   
  
  //
  static String getProfile = 'auth/me';
}*/
class EndPoint {
  static const String host = '10.34.127.205';
  static String baseUrl = 'http://$host:8000/api/';
  static const String socketUrl = r'http://[0-9.]+:8000';
  static const String socketPath = 'http://$host:8000';
  static String signIn = 'patient/login';
  static String signUp = 'patient/register';
  static String profile = 'patient/profile';
  static String logout = 'patient/logout';
  static String updateProfile = 'patient/profile/update';
  static String forgetPassword = 'patient/password/forgot-password';
  static String verifyOtp = "patient/password/verify-otp";
  static String  resetPassword="patient/password/reset-password";
  static String specializations = 'patient/specializations';
  static String search = 'patient/search';
  static String getspecializationsId(id) {
    return 'patient/specializations/$id/doctors';
  }

  static String schedules = 'patient/schedules';
  static String myHistory = 'patient/my-history';
  static String appointmentsStore = 'patient/appointments/store';
  static String doctorRate = 'patient/doctor/rate';
  static String topDoctors = 'patient/top-doctors';
  static String doctorSlots = 'patient/doctor-slots';
  static String patientAppointments = 'patient/appointments';
  static String booksomeowen= 'patient/book-for-someone';
  static String deleteAppointment(String uuid) => 'patient/appointments/$uuid';

  //static String getProfile = 'patient/auth/me';

// firebase and notifications
  static const String updateFcmToken = "update-fcm-token";
  static const String myNotifications = "notification/my-notifications";
  static const String notificationCount = "notification/my-notifications/count";
  static const String deleteAllNotifications =
      "notification/my-notifications/delete-all";
  static String markAsReadUrl(String uuid) =>
      "notification/my-notifications/$uuid/seen";

  static String deleteNotificationUrl(String uuid) =>
      "notification/my-notifications/$uuid/delete";

  static const String getAllPotentialContacts = "chat/potential-contacts";
  static const String getOrCreateRoom = "chat/get-or-create-room";
  static const String uploadFile = "chat/upload";
  static const String uploadAttachment = "chat/attachments/upload";
  static const String storeMessage = "chat/store-message";
}

class ApiKey {
  static String message = 'message';
  static String success = 'success';
  static String errors = 'errors';
  static String email = 'email';
  static String user = 'user';
  static String uuid = 'uuid';
  static String role = 'role';
  static String info = 'info';
  static String token = 'token';
  static String data = 'data';
  //regester
  static String name = 'name';
  static String nickName = 'nick_name';
  static String password = 'password';
  static String confirmPassword = 'confirm_password';
  static String phone = 'phone';
  static String gender = 'gender';
  static String dateOfBirth = 'date_of_birth';
  
  static String username = 'username';
  static String contact = "contact";
  static String code = "code";
  static String passwordConfirmation = "password_confirmation";
  // spitialize
  static String stats = 'stats';
  static String total_specializations_count = "total_specializations_count";
  static String max_check_up_price = "max_check_up_price";
  static String min_check_up_price = "min_check_up_price";
  static String average_check_up_price = "average_check_up_price";
  static String most_requested_specialization = "most_requested_specialization";
  static String least_requested_specialization =
      "least_requested_specialization";
  static String check_up_price = "check_up_price";
  static String appointments_count = "appointments_count";
  //top doctor
  static String specialization = 'specialization';
  static String average_rating = "average_rating";
  static String visit_time = "visit_time";
  // doctorByspicialize
  static String clinic = 'clinic';
  static String patients_count = 'patients_count';
  static String reviewers_count = 'reviewers_count';
  static String rating = 'rating';
  //doctor schedule
  static String doctor_uuid = "doctor_uuid";
  static String day = "day";
  static String start_time = "start_time";
  static String end_time = "end_time";
  static String doctor_name = "doctor_name";
  static String is_modified = "is_modified";
  static String status_note = "status_note";
//booking
  static String appointment = 'appointment';
  static String age = 'age';
  static String status = 'status';
  static String date_time = 'date_time';
  static String type = 'type';
  
//profile
  static String personal_info = 'personal_info';
  static String birthday = 'birthday';
  static String fcm_token = 'fcm_token';
  static String created_at = 'created_at';
  static String active = 'active';
  static String medical_history = 'medical_history';
  static String number = 'number';
  static String visit_type = 'visit_type';
  static String prescription = 'prescription';
  static String diagnosis = 'diagnosis';
  static String visit_date = 'visit_date';
  static String appointment_uuid = 'appointment_uuid';
  static String query = 'query';
// slotes
  static String date = 'date';
  static String time = 'time';
  static String fullDate = 'full_date';
  static String isAvailable = 'is_available';
  static String statusText = 'status_text';
  // search
  static String specializations = 'specializations';
  static String doctors = 'doctors';
  static String doctor = 'doctor';
  // rate
  static String stars = 'stars';
  static String patient_id = 'patient_id';
  static String doctor_id = 'doctor_id';
  static String comment = 'comment';
  static String rating_date = 'rating_date';
  //  firebase
  static String lastMessage = 'last_message';
  static String unreadCount = 'unread_count';
  static const String id = 'id';
  static const String image = 'image';

  static const String isActive = 'is_active';
  static String expiresInMins = 'expiresInMins';
  static String accessToken = 'accessToken';
  static String refreshToken = 'refreshToken';

  static String firstName = 'firstName';
  static String lastName = 'lastName';

  static String phoneNumber = 'phone Neumber';
  static String profilePicture = 'profiePicture';
}
