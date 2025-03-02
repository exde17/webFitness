import 'dart:ffi' as ffi;

import 'package:fitness/utils/customDrawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop:
            false, // Esto es crucial - evita que la ruta actual sea eliminada
        onPopInvoked: (didPop) {
          // Este callback se llama cuando se intenta hacer pop
          // Puedes añadir lógica adicional aquí si es necesario
          if (didPop) {
            // No se ejecutará si canPop es false
          } else {
            // Código opcional: puedes mostrar un diálogo, un snackbar, etc.
            // Por ejemplo:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No puedes regresar desde aquí')),
            );
          }
        },
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize:
                const Size.fromHeight(37.0), // Adjust height as needed
            child: AppBar(
              elevation: 0, // Quitar sombra
              backgroundColor:
                  const Color(0xFF010066), // FF es la opacidad al 100%
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
          // appBar: AppBar(
          //   elevation: 0, // Quitar sombra
          // ),
          drawer: const CustomDrawer(),
          body: Stack(
            children: [
              // Fondo con imagen
              Positioned.fill(
                child: Image.asset(
                  'assets/img/fondo8.jpg', // Asegúrate de tener esta imagen en tu proyecto
                  fit: BoxFit.cover,
                ),
              ),

              // Capa con degradado para mejor visibilidad del texto
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.2),
                      ],
                    ),
                  ),
                ),
              ),

              // Contenido principal
              // SizedBox(
              //   height: MediaQuery.of(context).size.height * 2,
              // ),
              // dar un espacio

              SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Mensaje de bienvenida
                      Text(
                        "¡Bienvenido, Alex!", // Aquí puedes obtener el nombre del usuario dinámicamente
                        style: GoogleFonts.lato(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Listo para tu próximo entrenamiento al aire libre?",
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Botón destacado
                      Hero(
                        tag: 'startWorkout',
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/workouts');
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: Colors.orangeAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              "Empezar Entrenamiento",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Sección de categorías rápidas
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildCategoryButton(context, "Planes",
                              Icons.directions_run, Colors.green),
                          _buildCategoryButton(
                              context, "Retos", Icons.flag, Colors.redAccent),
                          _buildCategoryButton(context, "Estadísticas",
                              Icons.bar_chart, Colors.blueAccent),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Carrusel de entrenamientos recomendados
                      Text(
                        "Entrenamientos Recomendados",
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 180,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildWorkoutCard("Cardio al Amanecer", "30 min",
                                "assets/img/car1.jpg"),
                            _buildWorkoutCard("Yoga en el Parque", "40 min",
                                "assets/img/car2.jpg"),
                            _buildWorkoutCard("Entrenamiento HIIT", "25 min",
                                "assets/img/car3.png"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  // Widget para los botones de categorías
  Widget _buildCategoryButton(
      BuildContext context, String title, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/$title'.toLowerCase());
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  // Widget para cada tarjeta de entrenamiento recomendado
  Widget _buildWorkoutCard(String title, String duration, String imagePath) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            Image.asset(imagePath, width: 150, height: 180, fit: BoxFit.cover),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(10),
                color: Colors.black.withOpacity(0.6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      duration,
                      style: const TextStyle(color: Colors.white70),
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
}
