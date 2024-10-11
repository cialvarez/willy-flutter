import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:willyweather/services/weather_info_service.dart';

import 'weather_event.dart';
import 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherInfoService weatherInfoService;
  WeatherBloc(this.weatherInfoService) : super(WeatherInitialFetch()) {
    on<WeatherInitialFetchEvent>(weatherInitialFetchEvent);
    on<WeatherChangeEvent>((event, emit) {
      emit(WeatherFetchSuccessState(event.weatherInfo));
    });
  }

  FutureOr<void> weatherInitialFetchEvent(
      WeatherInitialFetchEvent event, Emitter<WeatherState> emit) async {
    emit(WeatherFetchLoadingState());
    String cityName = await weatherInfoService.getCurrentCity();
    try {
      final weatherInfo = await weatherInfoService.getWeatherInfo(cityName);
      emit(WeatherFetchSuccessState(weatherInfo));
    } catch (error) {
      emit(WeatherFetchErrorState());
      print(error);
    }
  }
}
