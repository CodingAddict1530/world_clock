import 'dart:io';
import 'package:flutter/material.dart';
import 'package:world_clock/util/data_repository.dart';
import 'package:world_clock/util/world_time.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  /// Retrieves the time for the given location
  void setupWorldTime(WorldTime worldTime) async {
    WorldTime instance = worldTime;
    SnackBar? snackBar;
    try {
      await instance.getTime();
      Navigator.pushReplacementNamed(context, '/home', arguments: {
        'location': instance.location,
        'flag': instance.flag,
        'time': instance.time,
        'isDayTime': instance.isDayTime,
        'snackBar': snackBar,
      });
    } on SocketException catch (e) {
      snackBar = SnackBar(
          content: const Text('No Internet Connection, default time displayed!'),
          action: SnackBarAction( label:'Hide', onPressed: () {  } )
      );
      Navigator.pushReplacementNamed(context, '/home', arguments: {
        'location': 'Local',
        'flag': 'canada.png',
        'time': DateTime.now(),
        'isDayTime': DateTime.now().hour >= 6 && DateTime.now().hour < 18 ? true : false,
        'snackBar': snackBar,
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setupWorldTime(DataRepository.worldTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: const Center(
        child: SpinKitCircle(
          color: Colors.white,
          size: 50.0,
        ),
      ),
    );
  }
}
