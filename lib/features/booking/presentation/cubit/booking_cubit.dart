import 'package:ahgzly_salon_app/features/booking/domain/entities/employee_entity.dart';
import 'package:ahgzly_salon_app/features/booking/domain/entities/slot_entity.dart';
import 'package:ahgzly_salon_app/features/booking/domain/usecases/create_appointment_usecase.dart';
import 'package:ahgzly_salon_app/features/booking/domain/usecases/get_available_slots_usecase.dart';
import 'package:ahgzly_salon_app/features/booking/domain/usecases/get_employees_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/error/failures.dart';


part 'booking_state.dart';

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
    try {
      // التأكد من استدعاء UseCase بالمعاملات الجديدة
      employees = await getEmployeesUseCase(
        branchId: branchId,
        serviceId: serviceId,
      );

      if (employees.isNotEmpty) {
        selectedEmployee = employees.first;
        // جلب الأوقات تلقائياً لأول موظف
        await fetchAvailableSlots(branchId: branchId, serviceId: serviceId);
      } else {
        emit(BookingSlotsError("لا يوجد موظفون متاحون"));
      }
    } on Failure catch (failure) {
      emit(BookingSlotsError(failure.message));
    } catch (e) {
      emit(BookingSlotsError("حدث خطأ أثناء جلب البيانات."));
    }
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
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      final slots = await getAvailableSlotsUseCase(
        branchId: branchId,
        employeeId: selectedEmployee!.id,
        serviceId: serviceId,
        date: formattedDate,
      );

      // 💥 التعديل المنطقي هنا:
      // نقوم بمعالجة قائمة الأوقات قبل إرسالها للواجهة
      final processedSlots = slots.map((slot) {
        if (_isTimeInPast(slot.time)) {
          // إذا كان الوقت قد مضى، نجعله غير متاح حتى لو جاء من السيرفر متاحاً
          return SlotEntity(time: slot.time, isAvailable: false);
        }
        return slot;
      }).toList();

      emit(BookingSlotsLoaded(processedSlots));
    } on Failure catch (failure) {
      emit(BookingSlotsError(failure.message));
    } catch (e) {
      emit(BookingSlotsError("حدث خطأ أثناء جلب الأوقات المتاحة."));
    }
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
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      await createAppointmentUseCase(
        branchId: branchId,
        employeeId: selectedEmployee!.id, // 💥 إرسال ID الموظف المختار
        serviceId: serviceId,
        date: formattedDate,
        startTime: selectedSlot!.time,
      );
      emit(BookingSubmitSuccess());
    } on Failure catch (failure) {
      emit(BookingSubmitError(failure.message));
    } catch (e) {
      emit(BookingSubmitError("حدث خطأ غير متوقع أثناء إرسال طلب الحجز."));
    }
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
}
