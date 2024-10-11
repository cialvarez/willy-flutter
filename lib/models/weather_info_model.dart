class WeatherInfo {
  final String cityName;
  final double temperature;
  final String mainCondition;

  WeatherInfo({
    required this.cityName,
    required this.temperature,
    required this.mainCondition
  });

  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    return WeatherInfo(
      cityName: json['name'], 
      temperature: json['main']['temp'].toDouble(), 
      mainCondition: json['weather'][0]['main']
      );
  }
}