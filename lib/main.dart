import 'package:flutter/material.dart';
import 'package:license_plate_scanner/services/license_plate_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'License Plate Scanner',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const LicensePlateHome(),
    );
  }
}

class LicensePlateHome extends StatefulWidget {
  const LicensePlateHome({super.key});

  @override
  State<LicensePlateHome> createState() => _LicensePlateHomeState();
}

class _LicensePlateHomeState extends State<LicensePlateHome> {
  String? _scannedPlate;

  Future<void> _scanPlate() async {
    final result = await LicensePlateScanner.scan();
    setState(() {
      _scannedPlate = result ?? 'No plate found';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('License Plate Scanner'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _scanPlate,
                child: const Text('Scan License Plate'),
              ),
              const SizedBox(height: 20),
              if (_scannedPlate != null)
                Text(
                  'Scanned Plate: $_scannedPlate',
                  style: const TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
