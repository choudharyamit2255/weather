import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather/models/weather_model.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final firstController = TextEditingController();
  List<WeatherModel> weatherList = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                "https://images.pexels.com/photos/912364/pexels-photo-912364.jpeg?auto=compress&cs=tinysrgb&w=600"),
            fit: BoxFit.cover,)),
      child: Scaffold(backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            'Weather App',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          leading: const Icon(Icons.menu, size: 30),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextFormField(
                controller: firstController,
                decoration: InputDecoration(
                  fillColor: Colors.grey[200],
                  labelText: 'Enter City Name...',
                  labelStyle: const TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:
                    const BorderSide(color: Colors.black, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:
                    const BorderSide(color: Colors.black, width: 2.0),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search, color: Colors.black),
                    onPressed: () async {
                      if (firstController.text.isNotEmpty) {
                        setState(() {
                          isLoading = true;
                          errorMessage = null; // Clear previous error
                        });
                        await getData(firstController.text);
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (isLoading) const CircularProgressIndicator(),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(errorMessage!,
                    style: const TextStyle(color: Colors.red)),
              ),
            Text("November 08,",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),

            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  WeatherModel weather = weatherList[index];
                  return ListTile(
                    title: Text(
                      weather.location?.name ?? 'Unknown',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    subtitle: Column(
                      children: [
                        Row(mainAxisAlignment: MainAxisAlignment.start,
                          children: [

                            const SizedBox(width: 20),
                            RichText(text: TextSpan(style: TextStyle() , children: <TextSpan>[TextSpan(text: 'Temp',
                                          style: const TextStyle(
                                          fontWeight: FontWeight.bold, color: Colors.black),),

                            TextSpan(text: " ${weather.current?.tempC ?? ''}",style: TextStyle(fontSize: 40,color: Colors.white)),
                            TextSpan(text: "°C",style: TextStyle(fontSize: 25,color: Colors.white))])),SizedBox(width: 31,),
                            Column(verticalDirection: VerticalDirection.down,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Feels like: ${weather.current?.feelslikeC ?? ''}°C',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                Text(
                                  'Wind: ${weather.current?.gustKph ?? ''} km/h',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                                Text('WindDir.: ${weather.current?.windDir ?? ''} ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                Text(
                                    'WindDegree.: ${weather.current?.windDegree ??
                                        ''} ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                Text('Pressure: ${weather.current?.pressureIn ?? ''} ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                Text('Humidity: ${weather.current?.humidity ?? ''} ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                Text(
                                    'WindChill: ${weather.current?.windchillC ??
                                        ''} °C',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                Text('Dewpoint: ${weather.current?.dewpointC ?? ''}°C ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                Text(
                                  'Lat: ${weather.location?.lat ?? ''}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                              ],
                            )

                          ],
                        ),
                      ],
                    ),


                  );
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: weatherList.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getData(String cityName) async {
    try {
      String url =
          'https://api.weatherapi.com/v1/current.json?key=f0e539a476bd47eca3c60508240711&q=$cityName';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print('Data fetched successfully');
        final json = jsonDecode(response.body);
        WeatherModel weather = WeatherModel.fromJson(json);
        setState(() {
          weatherList = [weather];
        });
      } else {
        print('Failed to fetch data: ${response.statusCode}');
        setState(() {
          errorMessage =
          'Failed to fetch data. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      print('Error occurred: $e');
      setState(() {
        errorMessage = 'Error occurred: $e';
      });
    }
  }
}
