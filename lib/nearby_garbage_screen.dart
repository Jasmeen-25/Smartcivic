
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NearbyGarbageScreen extends StatelessWidget {
  const NearbyGarbageScreen({super.key});

  static const LatLng defaultLocation = LatLng(20.5937, 78.9629);

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF0B1F3A);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Garbage'),
        backgroundColor: navy,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('reports')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Unable to load garbage locations.'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final docs = snapshot.data?.docs ?? [];

          final validReports = docs.where((doc) {
            final data = doc.data();
            return data['latitude'] is num &&
                data['longitude'] is num;
          }).toList();

          final markers = <Marker>{};

          for (final doc in validReports) {
            final data = doc.data();

            final latitude = (data['latitude'] as num).toDouble();
            final longitude = (data['longitude'] as num).toDouble();

            if (latitude < -90 ||
                latitude > 90 ||
                longitude < -180 ||
                longitude > 180) {
              continue;
            }

            final damageType = data['damageType'] ?? 'Garbage Report';
            final severity = data['severity'] ?? 'Not specified';
            final status = data['status'] ?? 'pending';

            markers.add(
              Marker(
                markerId: MarkerId(doc.id),
                position: LatLng(latitude, longitude),
                infoWindow: InfoWindow(
                  title: damageType.toString(),
                  snippet:
                      'Severity: $severity | Status: $status',
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(damageType.toString()),
                      content: Text(
                        'Severity: $severity\n'
                        'Status: ${status.toString().toUpperCase()}\n'
                        'Latitude: $latitude\n'
                        'Longitude: $longitude',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }

          final firstPosition = markers.isNotEmpty
              ? markers.first.position
              : defaultLocation;

          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: firstPosition,
                  zoom: markers.isNotEmpty ? 13 : 4,
                ),
                markers: markers,
                mapType: MapType.normal,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: true,
              ),
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Text(
                      '${markers.length} garbage location(s) found',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
