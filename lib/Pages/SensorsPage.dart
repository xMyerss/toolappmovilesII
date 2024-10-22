import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SensorsPage extends StatefulWidget {
  const SensorsPage({Key? key}) : super(key: key);

  @override
  _SensorsPageState createState() => _SensorsPageState();
}

class _SensorsPageState extends State<SensorsPage> {
  double x = 0.0, y = 0.0, z = 0.0;
  
  @override
  void initState() {
    super.initState();
    // Suscribirse a los eventos del acelerómetro
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        // Redondear los valores a 2 decimales para mejor visualización
        x = double.parse(event.x.toStringAsFixed(2));
        y = double.parse(event.y.toStringAsFixed(2));
        z = double.parse(event.z.toStringAsFixed(2));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensores'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Datos del Acelerómetro',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildSensorValue('Eje X', x),
                    const SizedBox(height: 10),
                    _buildSensorValue('Eje Y', y),
                    const SizedBox(height: 10),
                    _buildSensorValue('Eje Z', z),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Visualización 3D',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomPaint(
                        painter: BubblePainter(x: x, y: y),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorValue(String axis, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$axis:',
          style: const TextStyle(fontSize: 16),
        ),
        Container(
          width: 200,
          height: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[200],
          ),
          child: Stack(
            children: [
              FractionallySizedBox(
                widthFactor: (value.abs() / 10).clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: _getColorForValue(value),
                  ),
                ),
              ),
              Center(
                child: Text(
                  value.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getColorForValue(double value) {
    if (value > 0) {
      return Colors.blue;
    } else if (value < 0) {
      return Colors.red;
    }
    return Colors.grey;
  }
}

// CustomPainter para visualizar la inclinación
class BubblePainter extends CustomPainter {
  final double x;
  final double y;

  BubblePainter({required this.x, required this.y});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    // Calcular la posición de la burbuja basada en los valores del acelerómetro
    final bubbleX = center.dx + (x * size.width / 20);
    final bubbleY = center.dy + (y * size.height / 20);

    // Dibujar la burbuja
    canvas.drawCircle(
      Offset(bubbleX.clamp(20.0, size.width - 20), 
             bubbleY.clamp(20.0, size.height - 20)),
      20,
      paint,
    );
  }

  @override
  bool shouldRepaint(BubblePainter oldDelegate) {
    return x != oldDelegate.x || y != oldDelegate.y;
  }
}