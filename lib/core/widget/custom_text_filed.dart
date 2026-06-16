import 'package:flutter/material.dart';
import 'package:raghad_pro/core/constanse/app_spacing.dart';
import 'package:raghad_pro/core/theme/app_colors.dart';

/*class CustomTextFiled extends StatelessWidget {
  const CustomTextFiled({ 
    super.key,
    this.onChanged,
    this.obscureText = false, 
    this.hinttext,
    this.labl,
    this.color,
    this.colorborder,
    this.textInputType,
    this.suffixIcon, 
    this.prefixIcon,
    this.textcontroler,
    this.maxlines = 1, 
    this.onSave,
    this.onTap,
    this.onTapSuffixIcon,
    this.readOnly = false,
    this.validate ,
  });

  final Function(String)? onChanged;
  final void Function(String?)? onSave;
  final String? hinttext;
  final String? labl;
  final bool obscureText;
  final Color? color;
  final Color? colorborder;
  final bool readOnly;
  final int? maxlines;
  final VoidCallback? onTap;
  final VoidCallback? onTapSuffixIcon;
  final TextInputType? textInputType;
  final IconData? suffixIcon;
  final IconData? prefixIcon; // الأيقونة الأمامية
  final TextEditingController? textcontroler;
  final String? Function(String?)? validate;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.vertical8,
      child: TextFormField(
        onTap: onTap,
        readOnly: readOnly,
        onSaved: onSave,
        maxLines: maxlines,
        obscureText: obscureText, 
        controller: textcontroler,
        keyboardType: textInputType,
        validator:validate ?? (data) {
          if (data?.trim().isEmpty ?? true) {
            return 'Field is required';
          }
          return null;
        },
        onChanged: onChanged,
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
        decoration: InputDecoration(
          filled: true,
          fillColor:Theme.of(context).colorScheme.surface , 
          
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, color:AppColors.primaryTeal) : null,
          
          suffixIcon: suffixIcon != null 
              ? IconButton(
                  icon: Icon(suffixIcon, color: AppColors.primaryTeal, size: 20),
                  onPressed: onTapSuffixIcon,
                ) 
              : null,
          
          hintText: hinttext,
          hintStyle: Theme.of(context).textTheme.bodyMedium,
        

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide:  BorderSide(color: Theme.of(context).colorScheme.primaryContainer, width: 0.5),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
          ),
           // حدود الخطأ
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: AppColors.error, width: 1),
          ),
        ),
      ),
    );
  }
}*/
class CustomTextFiled extends StatelessWidget {
  const CustomTextFiled({ 
    super.key,
    this.onChanged,
    this.obscureText = false, 
    this.hinttext,
    this.labl, 
    this.color,
    this.colorborder,
    this.textInputType,
    this.suffixIcon, 
    this.prefixIcon,
    this.textcontroler,
    this.maxlines = 1, 
    this.onSave,
    this.onTap,
    this.onTapSuffixIcon,
    this.readOnly = false,
    this.validate ,
  });

  final Function(String)? onChanged;
  final void Function(String?)? onSave;
  final String? hinttext;
  final String? labl;
  final bool obscureText;
  final Color? color;
  final Color? colorborder;
  final bool readOnly;
  final int? maxlines;
  final VoidCallback? onTap;
  final VoidCallback? onTapSuffixIcon;
  final TextInputType? textInputType;
  final IconData? suffixIcon;
  final IconData? prefixIcon; 
  final TextEditingController? textcontroler;
  final String? Function(String?)? validate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.vertical8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          //  فحص: إذا قمتِ بتمرير نص للـ labl سيظهر هنا فوق الحقل بشكل أنيق جداً
         if (labl != null) ...[
            Padding(
              padding:AppSpacing.only,
              child: Text(
                labl!,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primaryContainer, 
                ),
              ),
            ),
          ],
          TextFormField(
            onTap: onTap,
            readOnly: readOnly,
            onSaved: onSave,
            maxLines: maxlines,
            obscureText: obscureText, 
            controller: textcontroler,
            keyboardType: textInputType,
            validator: validate ?? (data) {
              if (data?.trim().isEmpty ?? true) {
                return 'Field is required';
              }
              return null;
            },
            onChanged: onChanged,
            style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 15),
            decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface, 
              
             
              isDense: true, 
              contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0), 
              
              prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: AppColors.primaryTeal, size: 22) : null,
              
              suffixIcon: suffixIcon != null 
                  ? IconButton(
                      icon: Icon(suffixIcon, color: AppColors.primaryTeal, size: 18),
                      onPressed: onTapSuffixIcon,
                    ) 
                  : null,
              
              hintText: hinttext,
              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color:Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5)), // لون خافت للنص التلميحي

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16), // تدويرة ناعمة ومطابقة للـ Toggle
                borderSide: BorderSide(color: Theme.of(context).colorScheme.primaryContainer, width: 0.5),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.error, width: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}