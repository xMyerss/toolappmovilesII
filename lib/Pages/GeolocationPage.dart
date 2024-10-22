import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

class GeolocationPage extends StatefulWidget {
  const GeolocationPage({Key? key}) : super(key: key);

  @override
  _SensorsPageState createState() => _SensorsPageState();
}

class _SensorsPageState extends State<GeolocationPage> {
  double x = 0.0, y = 0.0, z = 0.0;
  Position? currentPosition;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Verificar permisos de ubicación
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Permisos de ubicación denegados';
        }
      }

      // Obtener la posición actual
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (mounted) {
        setState(() {
          currentPosition = position;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al obtener la ubicación: $e')),
        );
      }
    }
  }

  Future<void> _openInGoogleMaps() async {
    if (currentPosition != null) {
      final url = 'https://www.google.com/maps/search/?api=1&query=${currentPosition!.latitude},${currentPosition!.longitude}';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudo abrir Google Maps')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubicación Actual'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Coordenadas',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (isLoading)
                      const CircularProgressIndicator()
                    else if (currentPosition != null)
                      Column(
                        children: [
                          _buildCoordinateRow('Latitud', currentPosition!.latitude),
                          const SizedBox(height: 10),
                          _buildCoordinateRow('Longitud', currentPosition!.longitude),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: _openInGoogleMaps,
                            icon: const Icon(Icons.map),
                            label: const Text('Abrir en Google Maps'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      const Text('No se pudo obtener la ubicación'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.refresh),
              label: const Text('Actualizar Ubicación'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoordinateRow(String label, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value.toStringAsFixed(6),
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}