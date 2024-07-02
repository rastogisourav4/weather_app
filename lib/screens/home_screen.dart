import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/screens/weather_details_screen.dart';
import 'package:weather_app/models/weather.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadLastCity();
  }

  Future<void> _loadLastCity() async {
    WeatherService weatherService = Provider.of<WeatherService>(context, listen: false);
    String? lastCity = await weatherService.getLastCity();
    if (lastCity != null) {
      _controller.text = lastCity;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Enter city name',
                ),
              ),
              SizedBox(height: 20.0),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () => _searchWeather(context),
                      child: Text('Get Weather'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _searchWeather(BuildContext context) async {
    String cityName = _controller.text.trim();

    if (cityName.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      try {
        WeatherService weatherService = Provider.of<WeatherService>(context, listen: false);
        Weather weather = await weatherService.fetchWeather(cityName);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WeatherDetailsScreen(weather: weather),
          ),
        );
      } catch (e) {
        print('Error fetching weather: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch weather data')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a city name')),
      );
    }
  }
}


