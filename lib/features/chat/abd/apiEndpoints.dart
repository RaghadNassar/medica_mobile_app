class ApiEndpoints {
  static const String host = '192.168.1.3';
  static const String baseUrl = "http://$host:8000/api";
  static const String socketUrl = r'http://[0-9.]+:8000';
  static const String socketPath = 'http://$host:8000'; 

  // --- Auth (خارج الـ prefix /doctor) ---
  static const String login = "/doctor/login";                   // POST
  static const String register = "/doctor/register";             // POST

  // --- Doctor Group (داخل الـ prefix /doctor) ---
  
  // Auth
  static const String logout = "/doctor/logout";                 // POST
  static const String getProfile = "/doctor/profile";            // GET
  static const String uploadProfileImage = "/doctor/upload-profile-image"; // POST
  static const String updateProfileImage = "/doctor/update-profile-image"; // PUT (لتحديث الصورة في قاعدة البيانات)
  static const String updateProfile = "/doctor/update-profile";  // PUT
  static const String updatePassword = "/doctor/update-password"; // PUT
  static const String forgetPassword = "/doctor/forgot-password"; // POST
  static const String verifyPassword = "/doctor/verify-otp"; // POST
  

  // Medical History
  static const String getHistoryByClass = "/doctor/medical-history/"; // GET (+ Classification)
  static const String getPatientHistory = "/doctor/medical-history/patient/"; // GET (+ uuid)
  static const String addHistory = "/doctor/medical-history/add";    // POST
  static const String updateHistory = "/doctor/medical-history/update"; // PUT

  // Appointments
  static const String getHomePage = "/doctor/homePage";          // GET
  static const String getMySchedule = "/doctor/my-schedule";     // GET
  static const String getAllPatients = "/doctor/patients";    // GET 
  static const String showAppointment = "/doctor/show-appointment"; // POST
  static const String getAppointmentInfo = "/doctor/appointment/"; // GET (+ uuid)
  static const String addAppointment = "/doctor/add-appointment/";  // POST (+ uuid)
  static const String editAppointment = "/doctor/edit-appointment/"; // PUT (+ uuid)
  static const String deleteAppointment = "/doctor/delete-appointment/"; // DELETE (+ uuid)
  
  // Shift Swap
  static const String storeShiftSwap = "/doctor/shift-swap";     // POST
  static const String respondShiftSwap = "/doctor/shift-swap/";   // PATCH (+ uuid/respond)
  static const String myRequests = "/doctor/shift-swap/sent"; // GET
  static const String sentRequests = "/doctor/shift-swap/received";   // GET
  static const String getDoctors = "/doctor/doctors";            // GET
  static const String getDoctorSchedule = "/doctor/schedule/";    // GET (+ doctor_uuid)

  // Statistics
  static const String getStatistics = "/doctor/analytics";      // GET

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
  

}
