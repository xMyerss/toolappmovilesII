import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple, Colors.purpleAccent], // Cambié a morado degradado
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 30),
                _buildLogoSection(),
                const SizedBox(height: 40),
                _buildInfoSection(context),
                const SizedBox(height: 40),
                _buildActionButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.asset(
            'assets/logo_universidad.png', // Logo de la universidad
            height: 120,
            width: 120,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Universidad Politécnica de Chiapas',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Cambié el texto a blanco para resaltar sobre el morado
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(Icons.school, 'Carrera', 'Ingeniería en Software'),
            const SizedBox(height: 15),
            _buildInfoRow(Icons.book, 'Materia', 'PROGRAMACIÓN PARA MÓVILES II'),
            const SizedBox(height: 15),
            _buildInfoRow(Icons.group, 'Grupo', 'B'),
            const SizedBox(height: 15),
            _buildInfoRow(Icons.person, 'Alumno', 'Pedro Josafat Ruiz Robles'),
            const SizedBox(height: 15),
            _buildInfoRow(Icons.confirmation_number, 'Matrícula', '213537'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurple, size: 24),
        const SizedBox(width: 10),
        Text(
          '$label:',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 18, color: Colors.black54),
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        _buildCustomButton(
          context,
          label: 'Ver Repositorio en GitHub',
          icon: Icons.code,
          color: Colors.blueAccent,
          onPressed: () async {
            const url = 'https://github.com/tu-repositorio';
            if (await canLaunchUrl(Uri.parse(url))) {
              await launchUrl(Uri.parse(url));
            } else {
              throw 'No se pudo abrir $url';
            }
          },
        ),
        const SizedBox(height: 20),
        _buildCustomButton(
          context,
          label: 'Geolocalización',
          icon: Icons.map,
          color: Colors.green,
          onPressed: () {
            Navigator.pushNamed(context, '/geolocation');
          },
        ),
        const SizedBox(height: 20),
        _buildCustomButton(
          context,
          label: 'Escanear QR',
          icon: Icons.qr_code_scanner,
          color: Colors.deepPurple,
          onPressed: () {
            Navigator.pushNamed(context, '/qrscan');
          },
        ),
        const SizedBox(height: 20),
        _buildCustomButton(
          context,
          label: 'Sensores',
          icon: Icons.sensors,
          color: Colors.redAccent,
          onPressed: () {
            Navigator.pushNamed(context, '/sensors');
          },
        ),
        const SizedBox(height: 20),
        _buildCustomButton(
          context,
          label: 'Speech to Text',
          icon: Icons.mic,
          color: Colors.orange,
          onPressed: () {
            Navigator.pushNamed(context, '/speech_text');
          },
        ),
      ],
    );
  }

  Widget _buildCustomButton(BuildContext context, {required String label, required IconData icon, required Color color, required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 28, color: Colors.white),
      label: Text(
        label,
        style: const TextStyle(fontSize: 18),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color, // Cambié "primary" por "backgroundColor"
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
