import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_popular_stays.dart';
import '../../domain/usecases/register_device.dart';
import 'hotel_event.dart';
import 'hotel_state.dart';

class HotelBloc extends Bloc<HotelEvent, HotelState> {
  HotelBloc({
    required RegisterDevice registerDevice,
    required GetPopularStays getPopularStays,
  }) : _registerDevice = registerDevice,
       _getPopularStays = getPopularStays,
       super(const HotelInitial()) {
    on<LoadPopularHotelsEvent>(_onLoadPopularHotels);
  }

  final RegisterDevice _registerDevice;
  final GetPopularStays _getPopularStays;

  Future<void> _onLoadPopularHotels(
    LoadPopularHotelsEvent event,
    Emitter<HotelState> emit,
  ) async {
    emit(const HotelLoading());

    final registrationResult = await _registerDevice(NoParams());
    final token = registrationResult.fold<String?>((failure) {
      emit(
        HotelError(
          failure.message ?? 'Unable to register device. Please try again.',
        ),
      );
      return null;
    }, (value) => value);

    if (token == null) {
      return;
    }

    final result = await _getPopularStays(
      PopularStaysParams(
        city: event.city,
        state: event.state,
        country: event.country,
      ),
    );

    result.fold(
      (failure) => emit(HotelError(failure.message ?? 'Unable to load hotels')),
      (hotels) => emit(HotelLoaded(hotels)),
    );
  }
}
