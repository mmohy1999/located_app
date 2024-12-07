import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class DialogCoordinates extends StatelessWidget {
  DialogCoordinates({super.key});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Get Postilion From Google Link',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _latitudeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Latitude'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'URl is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _longitudeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Longitude'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'URl is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                      Position _position=Position(
                          latitude: double.parse(_latitudeController.text),
                          longitude: double.parse(_longitudeController.text),
                          timestamp: DateTime.now(),
                          altitude: 0.0,
                          accuracy: 0.0,
                          heading: 0.0,
                          speed: 0.0,
                          speedAccuracy: 0.0,
                          altitudeAccuracy: 0.0,
                          headingAccuracy: 0.0,
                      );
                        Navigator.of(context).pop(_position);
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
