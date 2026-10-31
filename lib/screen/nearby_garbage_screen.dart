
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NearbyGarbageScreen extends StatelessWidget {
  const NearbyGarbageScreen({super.key});

  static const LatLng defaultLocation = LatLng(20.5937, 78.9629);

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF0B1F3A);
    const cyan = Color(0xFF00D4FF);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text(
          'Nearby Garbage',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Unable to load garbage locations.\nPlease check your internet connection and Firestore permissions.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: cyan),
            );
          }

          final docs = snapshot.data?.docs ?? [];

          final markers = <Marker>{};

          for (final doc in docs) {
            final data = doc.data();

            if (data['latitude'] is! num ||
                data['longitude'] is! num) {
              continue;
            }

            final latitude =
                (data['latitude'] as num).toDouble();
            final longitude =
                (data['longitude'] as num).toDouble();

            if (latitude < -90 ||
                latitude > 90 ||
                longitude < -180 ||
                longitude > 180) {
              continue;
            }

            final damageType =
                data['damageType'] ?? 'Garbage Report';
            final severity =
                data['severity'] ?? 'Not specified';
            final status =
                data['status'] ?? 'pending';

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
                    builder: (dialogContext) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        title: Text(damageType.toString()),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            _infoRow('Severity', severity.toString()),
                            _infoRow(
                              'Status',
                              status.toString().toUpperCase(),
                            ),
                            _infoRow(
                              'Latitude',
                              latitude.toStringAsFixed(6),
                            ),
                            _infoRow(
                              'Longitude',
                              longitude.toStringAsFixed(6),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(dialogContext),
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    },
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
                compassEnabled: true,
              ),

              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '${markers.length} garbage location(s) found',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              if (markers.isEmpty)
                Positioned(
                  bottom: 25,
                  left: 20,
                  right: 20,
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.location_searching,
                            size: 35,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'No garbage reports with valid GPS locations yet.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
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

  static Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 85,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
