import 'package:equatable/equatable.dart';

import '../../domain/entities/hotel.dart';

abstract class HotelState extends Equatable {
  const HotelState();

  @override
  List<Object?> get props => [];
}

class HotelInitial extends HotelState {
  const HotelInitial();
}

class HotelLoading extends HotelState {
  const HotelLoading();
}

class HotelLoaded extends HotelState {
  const HotelLoaded(this.hotels);

  final List<Hotel> hotels;

  @override
  List<Object?> get props => [hotels];
}

class HotelError extends HotelState {
  const HotelError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
