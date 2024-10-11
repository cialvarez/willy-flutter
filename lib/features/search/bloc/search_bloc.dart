import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:willyweather/services/weather_info_service.dart';
import 'package:stream_transform/stream_transform.dart';

import 'search_event.dart';
import 'search_state.dart';

EventTransformer<Event> debounce<Event>({
  Duration duration = const Duration(milliseconds: 1500),
}) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class WeatherSearchBloc extends Bloc<WeatherSearchEvent, WeatherSearchState> {
  final WeatherInfoService weatherInfoService;
  WeatherSearchBloc(this.weatherInfoService)
      : super(WeatherSearchInitialState()) {
    on<WeatherSearchTypingEvent>((event, emit) async {
      emit(WeatherSearchInProgressState());
      try {
        final weatherInfo =
            await weatherInfoService.getWeatherInfo(event.cityName);
        emit(WeatherSearchSuccessState(weatherInfo));
      } catch (error) {
        emit(WeatherSearchErrorState());
      }
    }, transformer: debounce());
  }
}
