import '../data/global_data.dart';
import '../widgets/single_weather.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weather/weather.dart';

import 'package:flutter/material.dart';

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  Weather _weather;
  String _bgImg;
  WeatherFactory _wf;

  void initState() {
    super.initState();
    _wf = WeatherFactory(GlobalData.owaKey, language: Language.ENGLISH);
    _getWeather();
  }

  Future<void> _getWeather() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    Weather weatherNearUser = await _wf.currentWeatherByLocation(
        position.latitude, position.longitude);
    setState(() {
      _weather = weatherNearUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    String mainWeather;
    Widget spinner;

    if (_weather == null) {
      mainWeather = 'unknown';
      spinner = Center(
        child: SpinKitCircle(
          color: Colors.grey,
          size: 50.0,
        ),
      );
    } else {
      mainWeather = _weather.weatherMain.toLowerCase();
      spinner = SizedBox(
        height: 0,
      );
    }

    //sun
    if (mainWeather.contains('sun') ||
        mainWeather.contains('sunny') ||
        mainWeather.contains('clear') ||
        mainWeather.contains('hot')) {
      _bgImg = 'assets/sunny.jpg';
    }
    //night
    else if (mainWeather.contains('night') ||
        mainWeather.contains('clear night') ||
        mainWeather.contains('moon') ||
        mainWeather.contains('clear night')) {
      _bgImg = 'assets/night.jpg';
    }
    //rain
    else if (mainWeather.contains('rain') ||
        mainWeather.contains('rainy') ||
        mainWeather.contains('thunder') ||
        mainWeather.contains('downfall')) {
      _bgImg = 'assets/rainy.jpg';
    }
    //clouds
    else if (mainWeather.contains('overcast') ||
        mainWeather.contains('fog') ||
        mainWeather.contains('cloudy') ||
        mainWeather.contains('clouds')) {
      _bgImg = 'assets/cloudy.jpg';
    }
    //snow
    else if (mainWeather.contains('snow') ||
        mainWeather.contains('snowy') ||
        mainWeather.contains('blizzard') ||
        mainWeather.contains('snowfall')) {
      _bgImg = 'assets/snowy.jpg';
    }
    //extreme
    else if (mainWeather.contains('severe') ||
        mainWeather.contains('hurricane') ||
        mainWeather.contains('tornado') ||
        mainWeather.contains('extreme')) {
      _bgImg = 'assets/extreme.png';
    }
    //unknown
    else {
      _bgImg = 'assets/unknown.jpg';
    }

    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Image.asset(
              _bgImg,
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
            Container(
              decoration: BoxDecoration(color: Colors.black38),
            ),
            Container(
              margin: EdgeInsets.only(top: 40, left: 20),
              child: _weather == null
                  ? Text('')
                  : Text(
                      DateFormat('MM-dd-yyyy KK:mm a')
                          .format(DateTime.now())
                          .toString(),
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ),
            _weather == null ? Text('') : SingleWeather(_weather),
          ],
        ),
      ),
    );
  }
}
