import '../../domain/entities/slot_entity.dart';

class SlotModel extends SlotEntity {
SlotModel({required super.time, required super.isAvailable});

  // 💥 الحل هنا: استقبال نص (String) بدلاً من Map
  factory SlotModel.fromString(String time) {
    return SlotModel(
      time: time,
      isAvailable: true, // بما أنها في قائمة "المتاحة" فهي متاحة
    );
  }

  // نحتفظ بـ fromJson كاحتياط إذا تغير الـ API مستقبلاً
  factory SlotModel.fromJson(Map<String, dynamic> json) {
    return SlotModel(
      time: json['time'] ?? '',
      isAvailable: json['is_available'] == true,
    );
  }
}
