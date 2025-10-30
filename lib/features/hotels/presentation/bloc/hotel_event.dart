import 'package:equatable/equatable.dart';

class HotelEvent extends Equatable {
  const HotelEvent();

  @override
  List<Object?> get props => [];
}

class LoadPopularHotelsEvent extends HotelEvent {
  const LoadPopularHotelsEvent({
    required this.city,
    required this.state,
    required this.country,
  });

  final String city;
  final String state;
  final String country;

  @override
  List<Object?> get props => [city, state, country];
}
