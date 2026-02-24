import 'package:ahgzly_salon_app/features/booking/domain/entities/slot_entity.dart';
import 'package:equatable/equatable.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {
  const BookingInitial();
}

// حالات جلب الأوقات
class BookingSlotsLoading extends BookingState {}

class BookingSlotsLoaded extends BookingState {
  final List<SlotEntity> slots;
  const BookingSlotsLoaded(this.slots);
  @override
  List<Object?> get props => [slots];
}

class BookingSlotsError extends BookingState {
  final String message;
  const BookingSlotsError(this.message);

   @override
  List<Object?> get props => [message];
}

// حالات تأكيد الحجز
class BookingSubmitLoading extends BookingState {}

class BookingSubmitSuccess extends BookingState {}

class BookingSubmitError extends BookingState {
  final String message;
  const BookingSubmitError(this.message);

  @override
  List<Object?> get props => [message];
}
