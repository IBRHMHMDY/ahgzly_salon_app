part of 'booking_cubit.dart';


abstract class BookingState {}

class BookingInitial extends BookingState {}

// حالات جلب الأوقات
class BookingSlotsLoading extends BookingState {}

class BookingSlotsLoaded extends BookingState {
  final List<SlotEntity> slots;
  BookingSlotsLoaded(this.slots);
}

class BookingSlotsError extends BookingState {
  final String message;
  BookingSlotsError(this.message);
}

// حالات تأكيد الحجز
class BookingSubmitLoading extends BookingState {}

class BookingSubmitSuccess extends BookingState {}

class BookingSubmitError extends BookingState {
  final String message;
  BookingSubmitError(this.message);
}
