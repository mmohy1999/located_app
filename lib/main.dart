import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_app/dialog_coordinates.dart';
import 'package:location_app/dialog_link.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});




  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Position? _position;
  String address='';
  bool isLocationServiceEnabled=false;
  late LocationPermission locationPermission;

  Future<Position>_getCurrentLocation()async{
    isLocationServiceEnabled= await Geolocator.isLocationServiceEnabled();
    if(isLocationServiceEnabled){
      locationPermission=await Geolocator.checkPermission();
      if(locationPermission==LocationPermission.denied){
        locationPermission=await Geolocator.requestPermission();
      }
    }else{
      print('servies not enpeld');
    }
    return await Geolocator.getCurrentPosition();
  }
  Future<String> _getAddressByPosition(Position position)async{
    List<Placemark> placeMarks =await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placeMark=placeMarks.first;
    print(placeMarks.length);
    return"${placeMark.country},${placeMark.subAdministrativeArea},${placeMark.locality}";
  }

  Future<Position?> _getPositionFromLink(String link) async {
    try {
      final RegExp regExp = RegExp(
        r'@(-?\d+(\.\d+)?),([-]?\d+(\.\d+)?)',
      );
      final match = regExp.firstMatch(link);

      if (match != null) {
        final latitude = double.parse(match.group(1)!);
        final longitude = double.parse(match.group(3)!);
        return Position(
          latitude: latitude,
          longitude: longitude,
          timestamp: DateTime.now(),
          altitude: 0.0,
          accuracy: 0.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
          altitudeAccuracy: 0.0,
          headingAccuracy: 0.0,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid Google Maps link")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
    return null;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location App'),
      ),
      body:  Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_pin,color: Colors.blueAccent,size: 32,),
            const SizedBox(height: 10,),
            const Text('Location Coordinates:',style: TextStyle(fontSize: 24,fontWeight:FontWeight.bold ),),
            const SizedBox(height: 4,),
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Latitude: ${_position?.latitude??''}'),
                const SizedBox(width: 10,),
                 Text('Longitude: ${_position?.longitude??''}'),
              ],
            ),
            const SizedBox(height: 10,),
            const Text('Address:',style: TextStyle(fontSize: 24,fontWeight:FontWeight.bold ),),
             Text(address),


            ElevatedButton(onPressed: () async {
              _position=await _getCurrentLocation();
              address=await _getAddressByPosition(_position!);
              setState(() {
              });
            }, child: const Text('Current Location')),
            ElevatedButton(onPressed: () async {
           var link=  await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return  DialogLink();
                },
              );
           print(link);
             _position=await _getPositionFromLink(link);
               address=await _getAddressByPosition(_position!);
              setState(() {
              });
            }, child: const Text('From Google Link')),
            ElevatedButton(onPressed: () async {
              _position=  await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return  DialogCoordinates();
                },
              );
               address=await _getAddressByPosition(_position!);
              setState(() {
              });
            }, child: const Text('From Coordinates')),

          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
