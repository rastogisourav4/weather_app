import 'package:flutter/material.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:provider/provider.dart';

class WeatherDetailsScreen extends StatelessWidget {
  final Weather weather;

  WeatherDetailsScreen({required this.weather});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather in ${weather.cityName}'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => _refreshWeather(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Temperature: ${weather.temperature}°C',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'Condition: ${weather.description}',
              style: TextStyle(fontSize: 24),
            ),
            Image.network(
              'http://openweathermap.org/img/wn/${weather.icon}.png',
              scale: 0.5,
            ),
            Text(
              'Humidity: ${weather.humidity}%',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'Wind Speed: ${weather.windSpeed} m/s',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }

  void _refreshWeather(BuildContext context) async {
    final weatherService = Provider.of<WeatherService>(context, listen: false);
    try {
      final newWeather = await weatherService.fetchWeather(weather.cityName);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WeatherDetailsScreen(weather: newWeather),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to refresh weather')),
      );
    }
  }
}


