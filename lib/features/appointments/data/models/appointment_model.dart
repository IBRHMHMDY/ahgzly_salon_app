import '../../domain/entities/appointment_entity.dart';

class AppointmentModel extends AppointmentEntity {
  AppointmentModel({
    required super.id,
    required super.serviceName,
    required super.branchName,
    required super.date,
    required super.startTime,
    required super.status,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] ?? 0,
      // استخراج اسم الخدمة من العلاقة المتداخلة في Laravel
      serviceName: json['service']?['name'] ?? 'خدمة غير معروفة',
      // استخراج اسم الفرع من العلاقة المتداخلة
      branchName: json['branch']?['name'] ?? 'فرع غير معروف',
      date: json['appointment_date'] ?? '',
      startTime: json['start_time'] ?? '',
      status: json['status'] ?? 'pending',
    );
  }
}
