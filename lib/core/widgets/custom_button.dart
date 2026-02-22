import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false, // الوضع الافتراضي هو عدم التحميل
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // إذا كان في حالة تحميل، نقوم بتعطيل الزر عن طريق إعطاء onPressed قيمة null
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            )
          : Text(text),
    );
  }
}
