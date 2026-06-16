import 'package:flutter/material.dart';

class BookingTimeGrid extends StatelessWidget {
  
  final List<dynamic> slots; 
  final String? selectedTime;

  final Function(String time, bool isAvailable) onTimeSelected;

  const BookingTimeGrid({
    super.key,
    required this.slots,
    required this.selectedTime,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        final slot = slots[index];
        
       
        final String timeText = slot.time;
        final bool isAvailable = slot.isAvailable ?? true; 
        final bool isSelected = timeText == selectedTime;

        return GestureDetector(
         
          onTap: () => onTimeSelected(timeText, isAvailable),
          child: Container(
            decoration: BoxDecoration(
              color: !isAvailable
                  ? theme.disabledColor.withOpacity(0.06)
                  : (isSelected ? theme.primaryColor : theme.colorScheme.surface),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected 
                    ? theme.primaryColor 
                    : theme.colorScheme.primaryContainer.withOpacity(isAvailable ? 0.2 : 0.05),
              ),
            ),
            child: Center(
              child: Text(
                timeText,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: !isAvailable
                      ? theme.disabledColor.withOpacity(0.35) 
                      : (isSelected ? Colors.white : theme.colorScheme.onSurface),
                 
                  decoration: !isAvailable ? TextDecoration.lineThrough : null, 
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}



/*
class BookingTimeGrid extends StatelessWidget {
  final List<String> availableTimes;
  final String? selectedTime;
  final Function(String) onTimeSelected;

  const BookingTimeGrid({
    super.key,
    required this.availableTimes,
    required this.selectedTime,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: availableTimes.length,
      itemBuilder: (context, index) {
        String time = availableTimes[index];
        bool isSelected = time == selectedTime;

        return GestureDetector(
          onTap: () => onTimeSelected(time),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? theme.primaryColor : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? theme.primaryColor : theme.colorScheme.primaryContainer.withOpacity(0.2)
              ),
            ),
            child: Center(
              child: Text(
                time,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}*/