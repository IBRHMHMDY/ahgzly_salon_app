import 'package:ahgzly_salon_app/features/booking/domain/entities/employee_entity.dart';
import 'package:ahgzly_salon_app/features/booking/domain/entities/slot_entity.dart';
import 'package:ahgzly_salon_app/features/booking/domain/usecases/create_appointment_usecase.dart';
import 'package:ahgzly_salon_app/features/booking/domain/usecases/get_available_slots_usecase.dart';
import 'package:ahgzly_salon_app/features/booking/domain/usecases/get_employees_usecase.dart';
import 'package:ahgzly_salon_app/features/booking/presentation/cubit/booking_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class BookingCubit extends Cubit<BookingState> {
  final GetAvailableSlotsUseCase getAvailableSlotsUseCase;
  final CreateAppointmentUseCase createAppointmentUseCase;
  final GetEmployeesUseCase getEmployeesUseCase; // إضافة UseCase الموظفين

  // بيانات ديناميكية
  DateTime selectedDate = DateTime.now();
  List<EmployeeEntity> employees = [];
  EmployeeEntity? selectedEmployee;
  SlotEntity? selectedSlot;

  BookingCubit({
    required this.getAvailableSlotsUseCase,
    required this.createAppointmentUseCase,
    required this.getEmployeesUseCase,
  }) : super(BookingInitial());

  // 1. جلب الموظفين فور دخول الشاشة بناءً على الفرع
  Future<void> fetchEmployees(int branchId, int serviceId) async {
    emit(BookingSlotsLoading());
    final result = await getEmployeesUseCase(
      branchId: branchId,
      serviceId: serviceId,
    );

    result.fold((failure) => emit(BookingSlotsError(failure.message)), (
      employeesData,
    ) {
      employees = employeesData;
      if (employees.isNotEmpty) {
        selectedEmployee = employees.first;
        // جلب الأوقات تلقائياً لأول موظف
        fetchAvailableSlots(branchId: branchId, serviceId: serviceId);
      } else {
        emit(BookingSlotsError("لا يوجد موظفون متاحون"));
      }
    });
  }

  // 2. تغيير الموظف المختار
  void selectEmployee(EmployeeEntity employee, int branchId, int serviceId) {
    selectedEmployee = employee;
    selectedSlot = null; // تصفير الوقت عند تغيير الموظف
    fetchAvailableSlots(branchId: branchId, serviceId: serviceId);
  }

  // 3. تغيير التاريخ المختار
  void selectDate(DateTime date, int branchId, int serviceId) {
    selectedDate = date;
    selectedSlot = null;
    fetchAvailableSlots(branchId: branchId, serviceId: serviceId);
  }

  // 4. جلب الأوقات المتاحة ديناميكياً
  Future<void> fetchAvailableSlots({
    required int branchId,
    required int serviceId,
  }) async {
    if (selectedEmployee == null) return;

    emit(BookingSlotsLoading());
    final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    final result = await getAvailableSlotsUseCase(
      branchId: branchId,
      employeeId: selectedEmployee!.id,
      serviceId: serviceId,
      date: formattedDate,
    );

    result.fold((failure) => emit(BookingSlotsError(failure.message)), (slots) {
      // التعديل المنطقي هنا: معالجة قائمة الأوقات
      final processedSlots = slots.map((slot) {
        if (_isTimeInPast(slot.time)) {
          return SlotEntity(time: slot.time, isAvailable: false);
        }
        return slot;
      }).toList();

      emit(BookingSlotsLoaded(processedSlots));
    });
  }

  // 5. اختيار وقت محدد
  void selectSlot(SlotEntity slot) {
    if (slot.isAvailable) {
      selectedSlot = slot;
      if (state is BookingSlotsLoaded) {
        emit(BookingSlotsLoaded((state as BookingSlotsLoaded).slots));
      }
    }
  }

  // 6. تنفيذ عملية الحجز النهائية
  Future<void> submitBooking({
    required int branchId,
    required int serviceId,
  }) async {
    if (selectedSlot == null || selectedEmployee == null) {
      emit(BookingSubmitError("برجاء اختيار الموظف والوقت أولاً."));
      return;
    }

    emit(BookingSubmitLoading());
    final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    final result = await createAppointmentUseCase(
      branchId: branchId,
      employeeId: selectedEmployee!.id, // إرسال ID الموظف المختار
      serviceId: serviceId,
      date: formattedDate,
      startTime: selectedSlot!.time,
    );

    result.fold(
      (failure) => emit(BookingSubmitError(failure.message)),
      (_) => emit(BookingSubmitSuccess()),
    );
  }

  bool _isTimeInPast(String slotTime) {
    final now = DateTime.now();

    // التحقق أولاً: هل التاريخ المختار هو اليوم؟
    // إذا كان التاريخ المختار هو غداً أو بعده، فالوقت ليس "ماضياً"
    bool isToday =
        selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;

    if (!isToday) return false;

    try {
      // تقسيم الوقت (مثلاً 14:30) إلى ساعات ودقائق
      final parts = slotTime.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      // مقارنة الوقت باللحظة الحالية
      if (hour < now.hour) return true;
      if (hour == now.hour && minute < now.minute) return true;

      return false;
    } catch (e) {
      return false; // في حال وجود خطأ في التنسيق
    }
  }

  // دالة لتصفير البيانات عند تسجيل الخروج
  void reset() {
    selectedEmployee = null;
    selectedSlot = null;
    emit(BookingInitial());
  }
}
