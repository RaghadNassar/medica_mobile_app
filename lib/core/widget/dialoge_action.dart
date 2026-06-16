import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/utilis/size_config.dart'; // تأكدي من المسار الصحيح للـ size_config

class CustomActionDialog {
  static void show({
    required BuildContext context,
    required IconData icon,               // الأيقونة (مثال: Icons.check أو Icons.logout)
    required Color iconColor,             // لون الأيقونة
    required Color iconBackgroundColor,   // لون خلفية دائرة الأيقونة
    required String title,                // العنوان الرئيسي للديالوغ
    String? subtitle,                     // الوصف الفرعي (اختياري)
    String? hintText,                     // نص إضافي باهت (اختياري مثل نص الـ 24 ساعة)
    required String confirmButtonText,    // نص زر التأكيد الأساسي
    required VoidCallback onConfirm,      // الأكشن عند الضغط على زر التأكيد
    bool isSecondaryButtonVisible = false,// هل تريدين إظهار زر ثانٍ (مثل إلغاء الأمر / تراجع)؟
    String? secondaryButtonText,          // نص الزر الثاني (اختياري)
    VoidCallback? onCancel,               // الأكشن عند الضغط على الزر الثاني (اختياري)
  }) {
    final theme = Theme.of(context);

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: theme.colorScheme.surface,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min, // يأخذ حجم المحتوى فقط
            children: [
              // 1. دائرة الأيقونة الديناميكية
              Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: iconBackgroundColor,
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 45,
                  ),
                ),
              ),
              
              SizedBox(height: context.heightPct(0.03)),

              // 2. العنوان الرئيسي
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: theme.colorScheme.onSurface,
                ),
              ),

              // 3. الوصف الفرعي (يظهر فقط إذا تم تمريره)
              if (subtitle != null) ...[
                SizedBox(height: context.heightPct(0.015)),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 15,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                    height: 1.4,
                  ),
                ),
              ],

              // 4. النص الباهت الإضافي (يظهر فقط إذا تم تمريره)
              if (hintText != null) ...[
                SizedBox(height: context.heightPct(0.01)),
                Text(
                  hintText,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 13,
                    color: theme.disabledColor.withOpacity(0.6),
                  ),
                ),
              ],

              SizedBox(height: context.heightPct(0.04)),

              // 5. قسم الأزرار (يدعم زر واحد أو زرين تلقائياً بجانب بعضهما أو فوق بعضهما)
              Row(
                children: [
                  // إذا كان هناك زر ثانٍ (مثل إلغاء/تراجع)، يظهر هنا أولاً
                  if (isSecondaryButtonVisible) ...[
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: theme.colorScheme.outline.withOpacity(0.5)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          ),
                          onPressed: () {
                            Get.back(); // إغلاق الديالوغ
                            if (onCancel != null) onCancel();
                          },
                          child: Text(
                            secondaryButtonText ?? "Cancel",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12), // مسافة بين الزرين
                  ],

                  // زر التأكيد الأساسي (مثل OK أو تسجيل الخروج)
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: iconColor, // يأخذ نفس طابع لون الأيقونة الممرر ديناميكياً
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Get.back(); // إغلاق الديالوغ تلقائياً عند الضغط
                          onConfirm(); // تنفيذ الأكشن المطلوبة
                        },
                        child: Text(
                          confirmButtonText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false, // لضمان عدم إغلاقه بالخطأ خارج الديالوغ
    );
  }
}