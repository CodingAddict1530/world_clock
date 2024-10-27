import 'package:world_clock/util/world_time.dart';

/// Stores shared data in the entire application.
class DataRepository {

  /// The WorldTime instance to be used to retrieve data by the loading screen.
  static WorldTime worldTime = WorldTime(url: 'America/Toronto', location: 'Ottawa', flag: 'canada.png');
}