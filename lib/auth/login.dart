// // ignore_for_file: use_build_context_synchronously

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../utils/config.dart';
// import 'package:logger/logger.dart';

// var logger = Logger();

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _isLoading = false;

//   Future<void> _login() async {
//     setState(() => _isLoading = true);

//     final email = _emailController.text.trim();
//     final password = _passwordController.text.trim();

//     // Petición HTTP a tu endpoint de login: /login
//     try {
//       final uri = Uri.parse('${GlobalConfig.apiHost}/auth/login');
//       final response = await http.post(
//         uri, 
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           'email': email,
//           'password': password,
//         }),
//       );

//       if (response.statusCode == 200  || response.statusCode == 201) {
//         logger.i('Login successful: ${response.body}');
//         final responseBody = json.decode(response.body);
//         final String token = responseBody['token'];
//         // final String role = responseBody['role'];
//         final String id = responseBody['id'];
//         final bool caracterizacion = responseBody['caracterizacion'];
//         final bool parq = responseBody['parq'];
//         final bool parqAprovado = responseBody['parqAprovado'];
//         // final List<dynamic> role = responseBody['role'];
//         logger.i("Token received: $token"); // Log del token

//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('token', token);
//         // await prefs.setString('role', json.encode(role));  // Guardarlo como una cadena
//         await prefs.setString('id', id);
//         await prefs.setBool('caracterizacion', caracterizacion);
//         await prefs.setBool('parq', parq);
//         await prefs.setBool('parqAprovado', parqAprovado);
//         // await prefs.setString('role', json.encode(role));

//         if (caracterizacion == false) {
//           Navigator.pushNamed(context, '/caracterizacion');
//         } else if (parq == false) {
//           Navigator.pushNamed(context, '/parqScreen');}
//         else if (parqAprovado == false) {
//           Navigator.pushNamed(context, '/inicioPendiente');
//         } else {
//           Navigator.pushNamed(context, '/');
//         }
        
//         // Navigator.pushNamed(context, '/parqScreen');
//         // ignore: use_build_context_synchronously
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Login exitoso')),
//         );
//       } else {
//         // Manejar error

//         logger.e('Error: ${response.body}');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: ${response.body}')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error de conexión: $e')),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Puedes ajustar los colores o imágenes de fondo según tu diseño
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Header con imagen/fondo degradado
//             Container(
//               height: 300,
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Colors.redAccent, Colors.deepOrange],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 ),
//               ),
//               child: const Stack(
//                 children: [
//                   Positioned(
//                     top: 60,
//                     left: 20,
//                     child: Text(
//                       'Burning up',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 34,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     top: 110,
//                     left: 20,
//                     child: Text(
//                       "Let's burn some calories",
//                       style: TextStyle(
//                         color: Colors.white70,
//                         fontSize: 18,
//                       ),
//                     ),
//                   ),
//                   // Puedes agregar imágenes o ilustraciones en este header
//                 ],
//               ),
//             ),

//             // Sección de formulario
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24.0),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 20),
//                   TextField(
//                     controller: _emailController,
//                     decoration: const InputDecoration(
//                       labelText: 'Email',
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   TextField(
//                     controller: _passwordController,
//                     decoration: const InputDecoration(
//                       labelText: 'Password',
//                     ),
//                     obscureText: true,
//                   ),
//                   const SizedBox(height: 10),
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: TextButton(
//                       onPressed: () {
//                         // Lógica para recuperar contraseña
//                       },
//                       child: const Text(
//                         'Forgot password?',
//                         style: TextStyle(color: Colors.redAccent),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   _isLoading
//                       ? const CircularProgressIndicator()
//                       : ElevatedButton(
//                           onPressed: _login,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.redAccent,
//                             minimumSize: const Size(double.infinity, 50),
//                           ),
//                           child: const Text('Log in'),
//                         ),
//                   const SizedBox(height: 20),
//                   // Botones de acceso rápido con redes (opcional)
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text('OR ACCESS WITH '),
//                       IconButton(
//                         icon: const Icon(Icons.facebook),
//                         onPressed: () {
//                           // Lógica de Facebook
//                         },
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.g_mobiledata),
//                         onPressed: () {
//                           // Lógica de Google
//                         },
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   // Botón para ir a la pantalla de registro
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text("Don't have an account? "),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.pushNamed(context, '/register');
//                         },
//                         child: const Text(
//                           'Sign up now',
//                           style: TextStyle(
//                             color: Colors.redAccent,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 40),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import '../utils/config.dart';

var logger = Logger();

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final uri = Uri.parse('${GlobalConfig.apiHost}/auth/login');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i('Login successful: ${response.body}');
        final responseBody = json.decode(response.body);
        final String token = responseBody['token'];
        final String id = responseBody['id'];
        // final bool caracterizacion = responseBody['caracterizacion'];
        final bool parq = responseBody['parq'];
        final bool parqAprovado = responseBody['parqAprovado'];
        final List<dynamic> role = responseBody['role'];
        logger.i("Token received: $token --- role:  $role"); // Log del token

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('id', id);
        // await prefs.setBool('caracterizacion', caracterizacion);
        await prefs.setBool('parq', parq);
        await prefs.setBool('parqAprovado', parqAprovado);
        await prefs.setString('role', json.encode(role));

        // if (!caracterizacion) {
        //   Navigator.pushNamed(context, '/caracterizacion');
        // } else 
        if (!parq) {
          Navigator.pushNamed(context, '/parqScreen');
        } else if (!parqAprovado) {
          Navigator.pushNamed(context, '/inicioPendiente');
        } else {
          Navigator.pushNamed(context, '/');
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login exitoso')),
        );
      } else {
        logger.e('Error: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              'assets/img/fondo7.jpg', // Asegúrate de tener esta imagen en assets
              fit: BoxFit.cover,
            ),
          ),

          // Capa semitransparente para mejorar la legibilidad
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),

          // Contenido del Login
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo o título
                    const Text(
                      'Monteria Vive Fit 🔥',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "¡Vamos a quemar calorías juntos!",
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                    const SizedBox(height: 40),

                    // Formulario
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Campo Email
                          TextField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Campo Password
                          TextField(
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                          ),
                          const SizedBox(height: 10),

                          // Botón Olvidar contraseña
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // Lógica para recuperar contraseña
                              },
                              child: const Text(
                                '¿Olvidaste tu contraseña?',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Botón de inicio de sesión
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : const Text(
                                      'Iniciar Sesión',
                                      style: TextStyle(fontSize: 18),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Opciones de redes sociales
                          const Text("O inicia sesión con"),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.facebook, color: Colors.blue),
                                onPressed: () {
                                  // Lógica de Facebook
                                },
                              ),
                              const SizedBox(width: 20),
                              IconButton(
                                icon: const Icon(Icons.g_mobiledata, color: Colors.red),
                                onPressed: () {
                                  // Lógica de Google
                                },
                              ),
                            ],
                          ),

                          // Botón para ir a registro
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("¿No tienes cuenta? "),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/register');
                                },
                                child: const Text(
                                  'Regístrate ahora',
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

