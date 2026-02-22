class AppointmentEntity {
  final int id;
  final String serviceName;
  final String branchName;
  final String date;
  final String startTime;
  final String status;

  AppointmentEntity({
    required this.id,
    required this.serviceName,
    required this.branchName,
    required this.date,
    required this.startTime,
    required this.status,
  });
}
