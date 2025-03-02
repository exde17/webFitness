import 'package:fitness/utils/customDrawer.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SolicitudEnProceso extends StatefulWidget {
  const SolicitudEnProceso({super.key});

  @override
  State<SolicitudEnProceso> createState() => _SolicitudEnProcesoState();
}

class _SolicitudEnProcesoState extends State<SolicitudEnProceso> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //     appBar: AppBar(
      //   title: const Text('Solicitud en proceso'), // Título de la pantalla
      //   backgroundColor: Colors.blue, // Ajusta color a tu gusto
      // ),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(37.0), // Adjust height as needed
        child: AppBar(
          elevation: 0, // Quitar sombra
          backgroundColor: const Color(0xFF010066), // FF es la opacidad al 100%
          iconTheme: const IconThemeData(
              color: Colors.white), // Aquí se cambia a blanco
          //icon
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Image.asset(
                'assets/img/modelo.jpg', // Ruta de la imagen en assets
                height: 100, // Ajusta el tamaño de la imagen
                width: 180,
              ),
            ),
          ],
        ),
      ),
      // drawer: const CustomDrawer(),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/img/fondo8.jpg', // Asegúrate de tener esta imagen en assets
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Animación atractiva
                  Lottie.asset(
                    'assets/lottie/processing.json', // Asegúrate de agregar el archivo a assets
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),

                  const SizedBox(height: 20),

                  // Título principal
                  const Text(
                    "¡Estamos procesando tu solicitud!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Descripción de la evaluación médica
                  const Text(
                    "Tu inscripción será evaluada por un médico para garantizar tu salud y seguridad antes de ser confirmada.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Tarjeta informativa con iconos
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    child: const Padding(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        children: [
                          Icon(Icons.health_and_safety,
                              color: Colors.blue, size: 40),
                          SizedBox(width: 15),
                          Expanded(
                            child: Text(
                              "Este proceso es importante para asegurarnos de que puedes realizar actividades físicas de manera segura.",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Botón para ver más detalles
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.info_outline),
                    label: const Text("Más información"),
                    onPressed: () {
                      // Acción para más información
                    },
                  ),
                ]),
          ),
        ],
      ),
    );
  }
}
