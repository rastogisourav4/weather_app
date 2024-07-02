import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherService {
  static const String apiKey = 'b1965cc4ee76317d4013a959f3fdbef3'; // Replace with your OpenWeatherMap API key
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  static const String lastCityKey = 'last_city';

  Future<Weather> fetchWeather(String city) async {
    final url = Uri.parse('$baseUrl?q=$city&units=metric&appid=$apiKey');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(lastCityKey, city);

        return Weather.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load weather');
      }
    } catch (e) {
      throw Exception('Failed to load weather');
    }
  }

  Future<String?> getLastCity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(lastCityKey);
  }
}


