// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class CustomDrawer extends StatelessWidget {
//   const CustomDrawer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: Column(
//         children: [
//           // Encabezado con degradado y datos del usuario
//           Container(
//             width: double.infinity,
//             height: 220,
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xFF512DA8), Color(0xFF673AB7)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//             child: const SafeArea(
//               child: Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: Row(
//                   children: [
//                     // Imagen de usuario
//                     CircleAvatar(
//                       radius: 40,
//                       backgroundImage: NetworkImage(
//                         'https://www.example.com/avatar.jpg',
//                       ),
//                     ),
//                     SizedBox(width: 16),
//                     // Información del usuario
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             'Nombre del Usuario',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           SizedBox(height: 4),
//                           Text(
//                             'user@example.com',
//                             style: TextStyle(
//                               color: Colors.white70,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           // Menú de opciones
//           Expanded(
//             child: ListView(
//               padding: EdgeInsets.zero,
//               children: [
//                 _createDrawerItem(
//                   icon: Icons.home,
//                   text: 'Inicio',
//                   onTap: () {
//                     Navigator.pop(context);
//                     Navigator.pushNamed(context,'/');
//                     // Navega a la pantalla de inicio
//                   },
//                 ),
//                 _createDrawerItem(
//                   icon: Icons.person,
//                   text: 'Perfil',
//                   onTap: () {
//                     Navigator.pop(context);
//                     // Navega a la pantalla de perfil
//                   },
//                 ),
//                 _createDrawerItem(
//                   icon: Icons.settings,
//                   text: 'Configuración',
//                   onTap: () {
//                     Navigator.pop(context);
//                     Navigator.pushNamed(context,'/inicioPendiente');
//                     // Navega a la pantalla de configuración
//                   },
//                 ),
//                 _createDrawerItem(
//                   icon: Icons.help_outline,
//                   text: 'Respuesta caractirización',
//                   onTap: () {
//                     Navigator.pop(context);
//                     Navigator.pushNamed(context,'/respuestaCaracterizacion');
//                     // Navega a la pantalla de ayuda
//                   },
//                 ),
//                 _createDrawerItem(
//                   icon: Icons.question_answer,
//                   text: 'Cuestionario',
//                   onTap: () {
//                     Navigator.pop(context); // Cierra el Drawer
//                     Navigator.pushNamed(context, '/parqScreen');
//                   },
//                 ),
//               ],
//             ),
//           ),
//           const Divider(),
//           // Opción de cerrar sesión
//           // _createDrawerItem(
//           //   icon: Icons.logout,
//           //   text: 'Cerrar sesión',
//           //   onTap: () {
//           //     Navigator.pushNamed(context, '/login');
//           //     // Navigator.pop(context);
//           //     // Implementa la lógica de logout
//           //   },
//           // ),
//           _createDrawerItem(
//             icon: Icons.logout,
//             text: 'Cerrar sesión',
//             onTap: () async {
//               // 1. Eliminar token y otros datos de SharedPreferences
//               final prefs = await SharedPreferences.getInstance();
//               await prefs.remove('token');
//               await prefs.remove('role');
//               // Remueve otros campos si los tienes (email, etc.)

//               // 2. Navegar a la pantalla de login y remover historial
//               Navigator.pushNamedAndRemoveUntil(
//                 // ignore: use_build_context_synchronously
//                 context,
//                 '/login',
//                 (Route<dynamic> route) => false,
//               );
//             },
//           ),
//           const SizedBox(height: 16),
//         ],
//       ),
//     );
//   }

//   Widget _createDrawerItem({
//     required IconData icon,
//     required String text,
//     GestureTapCallback? onTap,
//   }) {
//     return ListTile(
//       leading: Icon(icon, color: const Color(0xFF512DA8)),
//       title: Text(
//         text,
//         style: const TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//       onTap: onTap,
//     );
//   }
// }

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  List<String> _roles = [];

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    final String? roleString = prefs.getString('role');

    if (roleString != null) {
      setState(() {
        _roles = List<String>.from(json.decode(roleString));
      });
    }
  }

  bool _isMonitor() {
    return _roles.contains('monitor'); // Verifica si el usuario es "monitor"
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // **Encabezado con degradado y datos del usuario**
          Container(
            width: double.infinity,
            height: 220,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF512DA8), Color(0xFF673AB7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                        'https://www.example.com/avatar.jpg',
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Nombre del Usuario',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'user@example.com',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // **Menú de opciones**
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _createDrawerItem(
                  icon: Icons.home,
                  text: 'Inicio',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/');
                  },
                ),
                _createDrawerItem(
                  icon: Icons.person,
                  text: 'Perfil',
                  onTap: () {
                    Navigator.pop(context);
                    // Navega a la pantalla de perfil
                  },
                ),
                _createDrawerItem(
                  icon: Icons.settings,
                  text: 'Configuración',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/inicioPendiente');
                  },
                ),

                // 🔴 **Ocultar si el usuario NO es monitor**
                if (_isMonitor())
                  _createDrawerItem(
                    icon: Icons.help_outline,
                    text: 'Usuarios Aprobados',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/userListAprobados');
                    },
                  ),

                if (_isMonitor())
                  _createDrawerItem(
                    icon: Icons.question_answer,
                    text: 'Cuestionario',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/parqScreen');
                    },
                  ),
              ],
            ),
          ),
          
          const Divider(),

          // **Cerrar sesión**
          _createDrawerItem(
            icon: Icons.logout,
            text: 'Cerrar sesión',
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('token');
              await prefs.remove('role');
              await prefs.remove('id');
              await prefs.remove('parq');
              await prefs.remove('parqAprovado');

              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (Route<dynamic> route) => false,
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _createDrawerItem({
    required IconData icon,
    required String text,
    GestureTapCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF512DA8)),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}

