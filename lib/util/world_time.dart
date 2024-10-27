import 'dart:io';
import 'package:http/http.dart';
import 'dart:convert';

class WorldTime {

  /// The location.
  String location;

  /// The current time of the location.
  DateTime time = DateTime.now();

  /// The flag of the country in which the location is.
  String flag;

  /// The url of the location referring to worldtimeapi.org.
  String url;

  /// Whether it is daytime or not.
  bool isDayTime = false;

  /// Instantiates a new WorldTime instance.
  WorldTime({ required this.location, required this.flag, required this.url});

  /// Retrieves the current time for the location from worldtimeapi.org.
  Future<void> getTime() async {
    try {
      Response response = await get(Uri.parse('https://worldtimeapi.org/api/timezone/$url'));
      Map data = jsonDecode(response.body);
      String datetime = data['datetime'];
      String offset = data['utc_offset'].substring(0,3);
      DateTime now = DateTime.parse(datetime);
      time = now.add(Duration(hours: int.parse(offset)));
      isDayTime = time.hour >= 6 && time.hour < 18 ? true : false;
    } on SocketException {
      rethrow;
    } catch (e) {
      time = DateTime.now();
      isDayTime = time.hour >= 6 && time.hour < 18 ? true : false;
      location = 'Local';
    }
  }

}