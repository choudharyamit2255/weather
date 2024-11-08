import 'package:flutter/material.dart';
import 'package:weather/models/weather_model.dart';

class WeatherCard extends StatefulWidget {
  final WeatherModel weather;

  const WeatherCard({Key? key, required this.weather}) : super(key: key);

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
    ),
    margin: EdgeInsets.symmetric(vertical: 8),
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    // Left Column - Temperature and Location
    Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    RichText(
    text: TextSpan(
    style: TextStyle(color: Colors.black),
    children: <TextSpan>[
    TextSpan(
    text: 'Temp: ',
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    ),
    TextSpan(
    text: " ${widget.weather.current?.tempC ?? ''}",
    style: TextStyle(fontSize: 40),
    ),
    TextSpan(
    text: "°C",
    style: TextStyle(fontSize: 25),),
    ],
    ),
    ),
      SizedBox(height: 8),
      Text(
        'Feels like: ${widget.weather.current?.feelslikeC ?? ''}°C',
        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
      ),
    ],
    ),
      // Right Column - Weather Details
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          weatherDetail('Wind', '${widget.weather.current?.gustKph ?? ''} km/h', Icons.air),
          weatherDetail('Wind Dir.', widget.weather.current?.windDir ?? '', Icons.explore),
          weatherDetail('Pressure', '${widget.weather.current?.pressureIn ?? ''} in', Icons.compress),
          weatherDetail('Humidity', '${widget.weather.current?.humidity ?? ''}%', Icons.water_drop),
          weatherDetail('Wind Chill', '${widget.weather.current?.windchillC ?? ''} °C', Icons.thermostat),
          weatherDetail('Dewpoint', '${widget.weather.current?.dewpointC ?? ''}°C', Icons.grain),
          weatherDetail('Latitude', '${widget.weather.location?.lat ?? ''}', Icons.location_on),
        ],
      ),
    ],
    ),
    ),
    );
  }

  Widget weatherDetail(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          SizedBox(width: 8),
          Text(
            '$label: $value',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
