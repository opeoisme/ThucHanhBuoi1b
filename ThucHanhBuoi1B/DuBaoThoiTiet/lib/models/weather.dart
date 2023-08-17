import 'package:equatable/equatable.dart';
enum WeatherCondition {
  snow,
  sleet,
  hail,
  thunderstorm,
  heavyRain,
  lightRain,
  showers,
  heavyCloud,
  lightCloud,
  clear,
  unknown
}
class Weather extends Equatable {
  final WeatherCondition weatherCondition;
  final String formattedCondition;
  final double minTemp;
  final double temp;
  final double maxTemp;
  final int locationId;
  final String created;
  final DateTime lastUpdated;
  final String location;
  //constructor
  const Weather({
    required this.weatherCondition,
    required this.formattedCondition,
    required this.minTemp,
    required this.temp,
    required this.maxTemp,
    required this.locationId,
    required this.created,
    required this.lastUpdated,
    required this.location,
  });
  @override
  // TODO: implement props
  List<Object> get props => [
    weatherCondition,
    formattedCondition,
    minTemp,
    temp,
    maxTemp,
    locationId,
    created,
    lastUpdated,
    location,
  ];
  //convert from JSON to Weather object
/*
consolidated_weather": [
    {
      "id": 5001437304061952,
      "weather_state_name": "Light Cloud",
      "weather_state_abbr": "lc",
      "wind_direction_compass": "SSE",
      "created": "2020-07-26T00:22:18.967978Z",
      "applicable_date": "2020-07-25",
      "min_temp": 22.825,
      "max_temp": 31.585,
      "the_temp": 32.2,
      "wind_speed": 4.388510937739601,
      "wind_direction": 165.1056162097894,
      "air_pressure": 1018.5,
      "humidity": 56,
      "visibility": 15.249070428696413,
      "predictability": 70
    },
    ...
 */
  factory Weather.fromJson(dynamic jsonObject) {
    // Kiểm tra và xử lý dữ liệu đầu vào
    if (jsonObject == null ||
        jsonObject['consolidated_weather'] == null ||
        jsonObject['consolidated_weather'].isEmpty) {
      // Xử lý trường hợp dữ liệu không hợp lệ
      return Weather.unknown();
    }
    final consolidatedWeather = jsonObject['consolidated_weather'][0];
    return Weather(
      weatherCondition: _mapStringToWeatherCondition(
        consolidatedWeather['weather_state_abbr'] ?? '',
      ),
      formattedCondition: consolidatedWeather['weather_state_name'] ?? '',
      minTemp: (consolidatedWeather['min_temp'] as num).toDouble(),
      temp: (consolidatedWeather['the_temp'] as num).toDouble(),
      maxTemp: (consolidatedWeather['max_temp'] as num).toDouble(),
      locationId: jsonObject['woeid'] as int,
      created: consolidatedWeather['created'] ?? '',
      lastUpdated: DateTime.now(),
      location: jsonObject['title'] ?? '',
    );
  }
  // Thêm hàm tạo cho trường hợp không hợp lệ
  factory Weather.unknown() {
    return Weather(
      weatherCondition: WeatherCondition.unknown,
      formattedCondition: 'Unknown',
      minTemp: 0.0,
      temp: 0.0,
      maxTemp: 0.0,
      locationId: 0,
      created: '',
      lastUpdated: DateTime.now(),
      location: 'Unknown',
    );
  }

  static WeatherCondition _mapStringToWeatherCondition(String inputString) {
    Map<String, WeatherCondition> map = {
      'sn': WeatherCondition.snow,
      'sl': WeatherCondition.sleet,
      'h': WeatherCondition.hail,
      't': WeatherCondition.thunderstorm,
      'hr': WeatherCondition.heavyRain,
      'lr': WeatherCondition.lightRain,
      's': WeatherCondition.showers,
      'hc': WeatherCondition.heavyCloud,
      'lc': WeatherCondition.lightCloud,
      'c': WeatherCondition.clear
    };
    return map[inputString] ?? WeatherCondition.unknown;
  }
}