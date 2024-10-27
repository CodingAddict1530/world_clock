import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../util/timer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  /// Holds data for a given location.
  Map data = {};

  @override
  Widget build(BuildContext context) {

    data = data.isNotEmpty ? data : ModalRoute.of(context)?.settings.arguments as Map;
    String bgImage = data['isDayTime'] ? 'day.png' : 'night.png';
    if (data['snackBar'] != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(data['snackBar']);
        data.remove('snackBar');
      });
    }

    // For holding the BuildContext of the Consumer.
    BuildContext? c;

    return ChangeNotifierProvider(
      create: (context) => TimeProvider(
        data['time']
      ),
      child: Scaffold(
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/$bgImage'),
                fit: BoxFit.fill,
              )
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 120.0, 0.0, 0.0),
              child: Column(
                children: [
                  TextButton.icon(
                      onPressed: () async {
                        dynamic result = await Navigator.pushNamed(context, '/location');
                        setState(() {
                          if (result == null) {
                            return;
                          }
                          data = {
                            'location': result['location'],
                            'flag': result['flag'],
                            'time': result['time'],
                            'isDayTime': result['isDayTime'],
                          };
                          bgImage = data['isDayTime'] ? 'day.png' : 'night.png';
                          Provider.of<TimeProvider>(c!, listen: false).changeStartTime(data['time']);
                        });
                      },
                      icon: Icon(
                        Icons.edit_location,
                        color: Colors.grey[300],
                      ),
                      label: Text(
                        'Edit location',
                        style: TextStyle(
                          color: Colors.grey[300]
                        ),
                      ),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        data['location'],
                        style: const TextStyle(
                          fontSize: 28.0,
                          letterSpacing: 2.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0,),
                  Consumer<TimeProvider>(
                    builder: (context, timeProvider, child) {

                      c = context;
                      // 'timeProvider' is declared here and provides access to TimeProvider instance
                      return Container(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          timeProvider.formattedTime,
                          style: const TextStyle(
                            fontSize: 40.0,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
