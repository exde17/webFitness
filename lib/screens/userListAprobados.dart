// ignore_for_file: use_build_context_synchronously

import 'package:fitness/auth/auth_service.dart';
import 'package:fitness/screens/caracterizacion.dart';
import 'package:fitness/screens/respuesta_caracterizacion.dart';
import 'package:fitness/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

var logger = Logger();

class UserListAprobadosScreen extends StatefulWidget {
  const UserListAprobadosScreen({super.key});

  @override
  State<UserListAprobadosScreen> createState() => _UserListAprobadosScreen();
}

class _UserListAprobadosScreen extends State<UserListAprobadosScreen> {
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    try {
      final response = await http.get(
        Uri.parse('${GlobalConfig.apiHost}/parq/aprobados'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _users = List<Map<String, dynamic>>.from(data);
          _isLoading = false;
        });
        logger.i('Usuarios cargados: ${response.body}');
      } else {
        logger.e('Error al obtener usuarios: ${response.body}');
        throw Exception('Error al obtener usuarios: ${response.body}');
        
      }
    } catch (e) {
      logger.e('Error al cargar usuarios: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        
        SnackBar(content: Text('Error al cargar usuarios: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showUserOptions(BuildContext context, Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.info, color: Colors.blue),
            title: const Text('Resultados de Evaluación'),
            onTap: () {
              Navigator.pop(context);
              final userId = user['id'];
              if (user['id'] != null && user['id'].toString().isNotEmpty) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RespuestaCaracterizacionScreen(userId: userId.toString()),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Error: El usuario no tiene un ID válido'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
          // Cambia esta sección en UserListAprobadosScreen.dart
          ListTile(
            leading: const Icon(Icons.add_chart, color: Colors.green),
            title: const Text('Crear Caracterización'),
            onTap: () {
              Navigator.pop(context);
              final userId = user['id'];

              if (user['id'] != null && user['id'].toString().isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CaracterizacionScreen(userId: userId.toString()),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Error: El usuario no tiene un ID válido'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
          
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Lista de Usuarios"),
      //   backgroundColor: const Color(0xFF010066),
      // ),
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
      body: _isLoading
          // poner un titulo

          ? const Center(child: CircularProgressIndicator())
          : _users.isEmpty
              ? const Center(child: Text("No hay usuarios disponibles"))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    final user = _users[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade200,
                          child: const Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text(
                          user['nombre'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "📄 ${user['documentType']} - ${user['documentNumber']}"),
                            Text("📞 ${user['phoneNumber']}"),
                            Text("🧑 ${user['genero']}"),
                          ],
                        ),
                        trailing:
                            const Icon(Icons.more_vert, color: Colors.blue),
                        onTap: () => _showUserOptions(context, user),
                      ),
                    );
                  },
                ),
    );
  }
}
