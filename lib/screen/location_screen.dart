
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../services/report_submission_service.dart';

class LocationScreen extends StatefulWidget {
  final Uint8List imageBytes;

  const LocationScreen({
    super.key,
    required this.imageBytes,
  });

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String locationMessage = 'Location not captured yet';

  bool isLoading = false;
  bool reportReady = false;
  bool isSubmitting = false;

  Position? currentPosition;

  String? selectedDamageType;
  String? selectedSeverity;

  final ReportSubmissionService submissionService =
      ReportSubmissionService();

  final List<String> damageTypes = [
    'Garbage Pile',
    'Overflowing Dustbin',
    'Plastic Waste',
    'Illegal Dumping',
    'Other',
  ];

  final List<String> severityLevels = [
    'Low',
    'Medium',
    'High',
  ];

  Future<void> getCurrentLocation() async {
    setState(() {
      isLoading = true;
      reportReady = false;
      locationMessage = 'Getting your location...';
    });

    try {
      final serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        throw Exception('Please enable location services.');
      }

      LocationPermission permission =
          await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception('Location permission not granted.');
      }

      final position =
          await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      submissionService.createReport(
        image: widget.imageBytes,
        lat: position.latitude,
        lng: position.longitude,
      );

      if (!mounted) return;

      setState(() {
        currentPosition = position;
        reportReady = submissionService.isReportReady;

        locationMessage =
            'Latitude: ${position.latitude}\n'
            'Longitude: ${position.longitude}';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        locationMessage =
            e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> submitComplaint() async {
    if (!reportReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please capture your location first.'),
        ),
      );
      return;
    }

    if (selectedDamageType == null ||
        selectedSeverity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select damage type and severity.',
          ),
        ),
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      final reportId = await submissionService.submitReport(
        damageType: selectedDamageType!,
        severity: selectedSeverity!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Report submitted successfully! ID: $reportId',
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F3),
      appBar: AppBar(
        title: const Text('Garbage Location'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),

            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.memory(
                widget.imageBytes,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 25),

            const Icon(
              Icons.location_on,
              size: 80,
              color: Colors.green,
            ),

            const SizedBox(height: 15),

            const Text(
              'Capture Garbage Location',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              'Capture the GPS location where the garbage was found.',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 25),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                locationMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: isLoading ? null : getCurrentLocation,
              icon: const Icon(Icons.my_location),
              label: Text(
                isLoading
                    ? 'Please wait...'
                    : 'Get My Location',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(15),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Complaint Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              initialValue: selectedDamageType,
              decoration: const InputDecoration(
                labelText: 'Damage Type',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.delete_outline),
              ),
              items: damageTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDamageType = value;
                });
              },
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              initialValue: selectedSeverity,
              decoration: const InputDecoration(
                labelText: 'Severity',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.warning_amber),
              ),
              items: severityLevels.map((level) {
                return DropdownMenuItem(
                  value: level,
                  child: Text(level),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSeverity = value;
                });
              },
            ),

            const SizedBox(height: 25),

            if (reportReady)
              const Text(
                'Photo and GPS location captured successfully!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),

            const SizedBox(height: 15),

            SizedBox(
              height: 55,
              child: ElevatedButton.icon(
                onPressed: reportReady && !isSubmitting
                    ? submitComplaint
                    : null,
                icon: isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send),
                label: Text(
                  isSubmitting
                      ? 'Submitting...'
                      : 'Submit Report',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
