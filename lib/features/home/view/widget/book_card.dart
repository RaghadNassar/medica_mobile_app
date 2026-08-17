import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raghad_pro/core/constanse/app_spacing.dart';
import 'package:raghad_pro/core/constanse/string_manager.dart';
import 'package:raghad_pro/core/theme/app_colors.dart';
import 'package:raghad_pro/core/utilis/size_config.dart';
import 'package:raghad_pro/core/widget/custom_botton.dart';
import 'package:raghad_pro/features/home/data/model/get_booking.dart';

/*
class AppointmentCard extends StatelessWidget {
  
  final BookingModel? appointment; 
  final bool showActions;
  final VoidCallback? onCancel;
  final VoidCallback? onReschedule;

  const AppointmentCard({
    super.key,
    this.appointment, 
    required this.showActions,
    this.onCancel,
    this.onReschedule,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    
    final String formattedDate = appointment != null
        ? "${appointment!.dateTime.day}/${appointment!.dateTime.month}/${appointment!.dateTime.year}"
        : "00/00/0000";
        
    final String formattedTime = appointment != null
        ? "${appointment!.dateTime.hour.toString().padLeft(2, '0')}:${appointment!.dateTime.minute.toString().padLeft(2, '0')}"
        : "00:00";

    Color statusColor;
    String statusText;
    
  
    switch (appointment?.status) {
      case 'has booked':
        statusColor = AppColors.success;
        statusText = StringManager.statusConfirmed.tr;
        break;
      case 'is waiting':
        statusColor = AppColors.warning;
        statusText = StringManager.statusWaiting.tr;
        break;
      case 'has changed':
        statusColor = AppColors.info;
        statusText = StringManager.statusChanged.tr;
        break;
      case 'canceled':
        statusColor = AppColors.error;
        statusText = StringManager.statusCancelled.tr;
        break;  
      default:
        statusColor = AppColors.success;
        statusText = StringManager.statusVisited.tr;
    }

    return Card(
      color: theme.colorScheme.surface,
      margin: EdgeInsets.only(bottom: context.heightPct(0.02),top: context.heightPct(0.02) ),
      elevation: 0.6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.primaryContainer.withOpacity(0.15),
        ),
      ),
      child: Padding(
        padding: AppSpacing.screenPadding16_20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: context.widthPct(0.087),
                  backgroundColor: theme.primaryColor.withOpacity(0.1),
                  backgroundImage: appointment?.doctor.image != null &&
                          appointment!.doctor.image!.isNotEmpty
                      ? NetworkImage(appointment!.doctor.image!)
                      : null,
                  child: appointment?.doctor.image == null ||
                          appointment!.doctor.image!.isEmpty
                      ? Icon(
                          Icons.person,
                          color: theme.primaryColor,
                          size: context.widthPct(0.07),
                        )
                      : null,
                ),
                SizedBox(width: context.widthPct(0.03)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment?.doctor.name ?? "Dr. Name Placeholder", // نص افتراضي للتحميل
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: context.heightPct(0.005)),
                      Text(
                        appointment?.doctor.specialization ?? "Specialization", // نص افتراضي للتحميل
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: context.heightPct(0.019)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoRow(
                  context,
                  Icons.calendar_today_outlined,
                  formattedDate,
                  theme.colorScheme.onSurface.withOpacity(0.7),
                ),
                _buildInfoRow(
                  context,
                  Icons.access_time_rounded,
                  formattedTime,
                  theme.colorScheme.onSurface.withOpacity(0.7),
                ),
                Row(
                  children: [
                    Container(
                      width: context.widthPct(0.02),
                      height: context.widthPct(0.02),
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: context.widthPct(0.015)),
                    Text(
                      statusText,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              ],
            ),
            if (showActions) ...[
              SizedBox(height: context.heightPct(0.02)),
              Row(
                children: [
                  Expanded(
                    child: CustomBottomWidget(
                      text: StringManager.cancel.tr,
                      colortext: theme.primaryColor,
                      textColor: theme.primaryColor,
                      backgroundColor: Colors.transparent,
                      border: Border.all(
                        color: theme.primaryColor.withOpacity(0.4),
                      ),
                      borderradius: 12,
                      hight: context.heightPct(0.05),
                      fontSize: 13,
                      onTap: onCancel,
                    ),
                  ),
                  SizedBox(width: context.widthPct(0.03)),
                  Expanded(
                    child: CustomBottomWidget(
                      text: StringManager.reschedule.tr,
                      colortext: theme.scaffoldBackgroundColor,
                      textColor: theme.scaffoldBackgroundColor,
                      backgroundColor: theme.primaryColor,
                      borderradius: 12,
                      hight: context.heightPct(0.05),
                      fontSize: 13,
                      border: Border.all(color: Colors.transparent),
                      onTap: onReschedule,
                    ),
                  ),
                ],
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      BuildContext context, IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: context.widthPct(0.04), color: color.withOpacity(0.6)),
        SizedBox(width: context.widthPct(0.015)),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: color,
                fontSize: 13,
              ),
        ),
      ],
    );
  }
}








*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppointmentCard extends StatelessWidget {
  final BookingModel? appointment;
  final bool showActions;
  final VoidCallback? onCancel;
  final VoidCallback? onReschedule;

  const AppointmentCard({
    super.key,
    this.appointment,
    required this.showActions,
    this.onCancel,
    this.onReschedule,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final String formattedDate = appointment != null
        ? "${appointment!.dateTime.day}/${appointment!.dateTime.month}/${appointment!.dateTime.year}"
        : "00/00/0000";

    final String formattedTime = appointment != null
        ? "${appointment!.dateTime.hour.toString().padLeft(2, '0')}:${appointment!.dateTime.minute.toString().padLeft(2, '0')}"
        : "00:00";

    Color statusColor;
    String statusText;

    switch (appointment?.status) {
      case 'has booked':
        statusColor = AppColors.success;
        statusText = StringManager.statusConfirmed.tr;
        break;
      case 'is waiting':
        statusColor = AppColors.warning;
        statusText = StringManager.statusWaiting.tr;
        break;
      case 'has changed':
        statusColor = AppColors.info;
        statusText = StringManager.statusChanged.tr;
        break;
      case 'canceled':
        statusColor = AppColors.error;
        statusText = StringManager.statusCancelled.tr;
        break;
      default:
        statusColor = AppColors.success;
        statusText = StringManager.statusVisited.tr;
    }

    return Card(
      color: theme.colorScheme.surface,
      margin: EdgeInsets.only(
        bottom: context.heightPct(0.02),
        top: context.heightPct(0.02),
      ),
      elevation: 0.6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.primaryContainer.withOpacity(0.15),
        ),
      ),
      child: Padding(
        padding: AppSpacing.screenPadding16_20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: context.widthPct(0.07),
                  backgroundColor: theme.primaryColor.withOpacity(0.1),
                  backgroundImage: appointment?.doctor.image != null &&
                          appointment!.doctor.image!.isNotEmpty
                      ? NetworkImage(appointment!.doctor.image!)
                      : null,
                  child: appointment?.doctor.image == null ||
                          appointment!.doctor.image!.isEmpty
                      ? Icon(
                          Icons.person,
                          color: theme.primaryColor,
                          size: context.widthPct(0.07),
                        )
                      : null,
                ),
                SizedBox(width: context.widthPct(0.03)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment?.doctor.name ?? "Dr. Name Placeholder",
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: context.heightPct(0.005)),
                      Text(
                        appointment?.doctor.specialization ?? "Specialization",
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color:
                        statusColor.withOpacity(0.12), // خلفية خفيفة نفس اللون
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    statusText,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.heightPct(0.019)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoRow(
                  context,
                  Icons.calendar_today_outlined,
                  formattedDate,
                  theme.colorScheme.onSurface.withOpacity(0.7),
                ),
                const Spacer(flex: 2),
                _buildInfoRow(
                  context,
                  Icons.access_time_rounded,
                  formattedTime,
                  theme.colorScheme.onSurface.withOpacity(0.7),
                ),
                const Spacer(flex: 3)
              ],
            ),
            if (showActions) ...[
              SizedBox(height: context.heightPct(0.02)),
              Row(
                children: [
                  Expanded(
                    child: CustomBottomWidget(
                      text: StringManager.cancel.tr,
                      colortext: theme.primaryColor,
                      textColor: theme.primaryColor,
                      backgroundColor: Colors.transparent,
                      border: Border.all(
                        color: theme.primaryColor.withOpacity(0.4),
                      ),
                      borderradius: 12,
                      hight: context.heightPct(0.05),
                      fontSize: 13,
                      onTap: onCancel,
                    ),
                  ),
                  SizedBox(width: context.widthPct(0.03)),
                  Expanded(
                    child: CustomBottomWidget(
                      text: StringManager.reschedule.tr,
                      colortext: theme.scaffoldBackgroundColor,
                      textColor: theme.scaffoldBackgroundColor,
                      backgroundColor: theme.primaryColor,
                      borderradius: 12,
                      hight: context.heightPct(0.05),
                      fontSize: 13,
                      border: Border.all(color: Colors.transparent),
                      onTap: onReschedule,
                    ),
                  ),
                ],
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      BuildContext context, IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: context.widthPct(0.04), color: color.withOpacity(0.6)),
        SizedBox(width: context.widthPct(0.015)),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: color,
                fontSize: 13,
              ),
        ),
      ],
    );
  }
}




























































/*
class AppointmentCard extends StatelessWidget {
  final BookingModel appointment;
  final bool showActions;
  final VoidCallback? onCancel;
  final VoidCallback? onReschedule;

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.showActions,
    this.onCancel,
    this.onReschedule,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final String formattedDate =
        "${appointment.dateTime.day}/${appointment.dateTime.month}/${appointment.dateTime.year}";
    final String formattedTime =
        "${appointment.dateTime.hour.toString().padLeft(2, '0')}:${appointment.dateTime.minute.toString().padLeft(2, '0')}";

    Color statusColor;
    String statusText;
    switch (appointment.status) {
      case 'has booked':
        statusColor = AppColors.success;
        statusText = StringManager.statusConfirmed.tr;
        break;
      case 'is waiting':
        statusColor = AppColors.warning;
        statusText = StringManager.statusWaiting.tr;
        break;
      case 'has changed':
        statusColor = AppColors.info;
        statusText = StringManager.statusChanged.tr;
        break;
      default:
        statusColor = AppColors.success;
        statusText = StringManager.statusVisited.tr;
    }

    return Card(
      color: theme.colorScheme.surface,
      margin: EdgeInsets.only(bottom: context.heightPct(0.02)),
      elevation: 0.6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.primaryContainer.withOpacity(0.15),
        ),
      ),
      child: Padding(
        padding: AppSpacing.screenPadding16_20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: context.widthPct(0.07),
                  backgroundColor: theme.primaryColor.withOpacity(0.1),
                  backgroundImage: appointment.doctor.image != null &&
                          appointment.doctor.image!.isNotEmpty
                      ? NetworkImage(appointment.doctor.image!)
                      : null,
                  child: appointment.doctor.image == null ||
                          appointment.doctor.image!.isEmpty
                      ? Icon(
                          Icons.person,
                          color: theme.primaryColor,
                          size: context.widthPct(0.07),
                        )
                      : null,
                ),
                SizedBox(width: context.widthPct(0.03)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.doctor.name,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: context.heightPct(0.005)),
                      Text(
                        appointment.doctor.specialization,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: context.heightPct(0.019)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoRow(
                  context,
                  Icons.calendar_today_outlined,
                  formattedDate,
                  theme.colorScheme.onSurface.withOpacity(0.7),
                ),
                _buildInfoRow(
                  context,
                  Icons.access_time_rounded,
                  formattedTime,
                  theme.colorScheme.onSurface.withOpacity(0.7),
                ),
                Row(
                  children: [
                    Container(
                      width: context.widthPct(0.02),
                      height: context.widthPct(0.02),
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: context.widthPct(0.015)),
                    Text(
                      statusText,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              ],
            ),
            if (showActions) ...[
              SizedBox(height: context.heightPct(0.02)),
              Row(
                children: [
                  Expanded(
                    child: CustomBottomWidget(
                      text: StringManager.cancel.tr,
                      colortext: theme.primaryColor,
                      textColor: theme.primaryColor,
                      backgroundColor: Colors.transparent,
                      border: Border.all(
                        color: theme.primaryColor.withOpacity(0.4),
                      ),
                      borderradius: 12,
                      hight: context.heightPct(0.05),
                      fontSize: 13,
                      onTap: onCancel,
                    ),
                  ),
                  SizedBox(width: context.widthPct(0.03)),
                  Expanded(
                    child: CustomBottomWidget(
                      text: StringManager.reschedule.tr,
                      colortext: theme.scaffoldBackgroundColor,
                      textColor: theme.scaffoldBackgroundColor,
                      backgroundColor: theme.primaryColor,
                      borderradius: 12,
                      hight: context.heightPct(0.05),
                      fontSize: 13,
                      border: Border.all(color: Colors.transparent),
                      onTap: onReschedule,
                    ),
                  ),
                ],
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      BuildContext context, IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: context.widthPct(0.04), color: color.withOpacity(0.6)),
        SizedBox(width: context.widthPct(0.015)),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: color,
                fontSize: 13,
              ),
        ),
      ],
    );
  }
}
*/










































































































































/*
class AppointmentCard extends StatelessWidget {
  final BookingModel appointment;
  final bool         showActions;
  final VoidCallback? onCancel;
  final VoidCallback? onReschedule;

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.showActions,
    this.onCancel,
    this.onReschedule,
  });

  ({Color color, String textKey}) get _statusInfo {
    return switch (appointment.status) {
      'has booked'  => (color: AppColors.success, textKey: StringManager.statusConfirmed.tr),
      'is waiting'  => (color: AppColors.warning, textKey: StringManager.statusWaiting.tr),
      'has changed' => (color: AppColors.info,    textKey: StringManager.statusChanged.tr),
      _             => (color: AppColors.success, textKey: StringManager.statusVisited.tr),
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final status = _statusInfo;

    final formattedDate =
        '${appointment.dateTime.day}/${appointment.dateTime.month}/${appointment.dateTime.year}';
    final formattedTime =
        '${appointment.dateTime.hour.toString().padLeft(2, '0')}:'
        '${appointment.dateTime.minute.toString().padLeft(2, '0')}';

    return Card(
      color:     theme.colorScheme.surface,
      margin:    EdgeInsets.only(bottom: context.heightPct(0.02)),
      elevation: 0.6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.primaryContainer.withOpacity(0.15),
        ),
      ),
      child: Padding(
        padding: AppSpacing.screen16v20h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor Info Row
            _DoctorInfoRow(appointment: appointment, theme: theme),

            SizedBox(height: context.heightPct(0.019)),

            // Date / Time / Status Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _InfoChip(icon: Icons.calendar_today_outlined, text: formattedDate, theme: theme),
                _InfoChip(icon: Icons.access_time_rounded,     text: formattedTime, theme: theme),
                _StatusBadge(color: status.color, textKey: status.textKey, theme: theme),
              ],
            ),

            // Actions
            if (showActions) ...[
              SizedBox(height: context.heightPct(0.02)),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text:            StringManager.cancel.tr,
                      textColor:       theme.primaryColor,
                      backgroundColor: Colors.transparent,
                      border:          Border.all(color: theme.primaryColor.withOpacity(0.4)),
                      borderRadius:    12,
                      height:          context.heightPct(0.05),
                      fontSize:        13,
                      onTap:           onCancel,
                    ),
                  ),
                  SizedBox(width: context.widthPct(0.03)),
                  Expanded(
                    child: AppButton(
                      text:            StringManager.reschedule.tr,
                      textColor:       theme.scaffoldBackgroundColor,
                      backgroundColor: theme.primaryColor,
                      borderRadius:    12,
                      height:          context.heightPct(0.05),
                      fontSize:        13,
                      onTap:           onReschedule,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DoctorInfoRow extends StatelessWidget {
  final BookingModel appointment;
  final ThemeData    theme;
  const _DoctorInfoRow({required this.appointment, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: context.widthPct(0.07),
          backgroundColor: theme.primaryColor.withOpacity(0.1),
          backgroundImage: (appointment.doctor.image?.isNotEmpty ?? false)
              ? NetworkImage(appointment.doctor.image!)
              : null,
          child: (appointment.doctor.image?.isEmpty ?? true)
              ? Icon(Icons.person, color: theme.primaryColor, size: context.widthPct(0.07))
              : null,
        ),
        SizedBox(width: context.widthPct(0.03)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(appointment.doctor.name,
                  style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
              SizedBox(height: context.heightPct(0.005)),
              Text(appointment.doctor.specialization,
                  style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String   text;
  final ThemeData theme;
  const _InfoChip({required this.icon, required this.text, required this.theme});

  @override
  Widget build(BuildContext context) {
    final color = theme.colorScheme.onSurface.withOpacity(0.7);
    return Row(
      children: [
        Icon(icon, size: context.widthPct(0.04), color: color),
        SizedBox(width: context.widthPct(0.015)),
        Text(text, style: theme.textTheme.bodyMedium?.copyWith(color: color, fontSize: 13)),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final Color    color;
  final String   textKey;
  final ThemeData theme;
  const _StatusBadge({required this.color, required this.textKey, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: context.widthPct(0.02),
          height: context.widthPct(0.02),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: context.widthPct(0.015)),
        // 🟢 .tr للترجمة
        Text(textKey.tr,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: color, fontWeight: FontWeight.w600)),
      ],
    );
  }
}*/