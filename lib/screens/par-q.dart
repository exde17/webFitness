// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:fitness/auth/auth_service.dart';
import 'package:fitness/utils/config.dart';
import 'package:fitness/utils/customDrawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ParqScreen extends StatefulWidget {
  const ParqScreen({super.key});

  @override
  State<ParqScreen> createState() => _ParqScreenState();
}

class _ParqScreenState extends State<ParqScreen> {
  // Lista de preguntas que se cargan desde el servidor
  List<Map<String, dynamic>> _questions = [];

  // Almacenará las respuestas del usuario: idPregunta -> bool (true/false)
  final Map<String, bool> _answers = {};

  bool _isLoading = false;
  bool _fetchError = false;

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  /// Método para obtener el token (ajusta según tu lógica).
  Future<String> _getToken() async {
    // Ejemplo: lo obtienes de SharedPreferences o de otra fuente.
    // final prefs = await SharedPreferences.getInstance();
    // return prefs.getString('token') ?? '';
    return 'TU_TOKEN_AQUI';
  }

  /// Carga las preguntas desde el endpoint.
  Future<void> _fetchQuestions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    setState(() {
      _isLoading = true;
      _fetchError = false;
    });

    try {
      final response = await http.get(
        Uri.parse('${GlobalConfig.apiHost}/pregunta-parq'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = json.decode(response.body);
        // Convertimos cada pregunta a Map<String, dynamic>
        // y ordenamos por item (por si acaso).
        _questions = data
            .map((q) => {
                  'id': q['id'],
                  'item': q['item'],
                  'enunciado': q['enunciado'],
                })
            .toList();
        _questions.sort((a, b) => int.parse(a['item']).compareTo(int.parse(b['item'])));

        // Inicializamos las respuestas con null o false
        for (var q in _questions) {
          // Por defecto, la respuesta es false
          _answers[q['id']] = false;
        }
      } else {
        logger.e('Error al cargar las preguntas: ${response.body}');
        _fetchError = true;
      }
    } catch (e) {
      logger.e('Error al cargar las preguntas: $e');
      _fetchError = true;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveAnswers() async {
  final lastQuestion = _questions.firstWhere(
    (q) => q['item'] == '8',
    orElse: () => {},
  );
  if (lastQuestion.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No se encontró la pregunta de aceptación.')),
    );
    return;
  }
  final lastAnswer = _answers[lastQuestion['id']];
  if (lastAnswer != true) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Debe aceptar los términos para continuar.'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  setState(() => _isLoading = true);
  try {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    for (var q in _questions) {
      final preguntaId = q['id'];
      final bool respuesta = _answers[preguntaId] ?? false;

      final response = await http.post(
        Uri.parse('${GlobalConfig.apiHost}/respuesta-parq'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'respuestaParq': respuesta,
          'preguntaParq': preguntaId,
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Error guardando la pregunta $preguntaId: ${response.body}');
      }
    }

    // Llamar al endpoint para obtener el estado de la inscripción
    final statusResponse = await http.get(
      Uri.parse('${GlobalConfig.apiHost}/respuesta-parq'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (statusResponse.statusCode == 200 || statusResponse.statusCode == 201) {
      final data = json.decode(statusResponse.body);
      final String message = data['message'];
      final bool status = data['status'];

      // Mostrar mensaje en un AlertDialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Estado de la inscripción'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Redirigir según el estado
                  if (status) {
                    logger.i('Inscripción aprobada');
                    Navigator.pushReplacementNamed(context, '/');
                  } else {
                    Navigator.pushReplacementNamed(context, '/inicioPendiente');
                    logger.i('Inscripción pendiente');
                  }
                },
                child: const Text('Aceptar'),
              ),
            ],
          ),
        );
      }
    } else {
      throw Exception('Error al obtener el estado: ${statusResponse.body}');
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al procesar: $e')),
    );
  } finally {
    setState(() => _isLoading = false);
  }
}


//   Future<void> _saveAnswers() async {
//   // Primero, verifica que la última pregunta (item "8") esté aceptada (true)
//   final lastQuestion = _questions.firstWhere(
//     (q) => q['item'] == '8',
//     orElse: () => {},
//   );
//   if (lastQuestion == null) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('No se encontró la pregunta de aceptación.')),
//     );
//     return;
//   }
//   final lastAnswer = _answers[lastQuestion['id']];
//   if (lastAnswer != true) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Debe aceptar los términos para continuar.'),
//         backgroundColor: Colors.red,
//       ),
//     );
//     return;
//   }
  
//   // Opcionalmente, si deseas verificar que todas las preguntas tengan respuesta,
//   // aunque en este ejemplo todas se inicializan con false, podrías recorrer la lista:
//   for (var q in _questions) {
//     if (_answers[q['id']] == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Debe responder todas las preguntas.')),
//       );
//       return;
//     }
//   }

//   // Si pasa todas las validaciones, continúa guardando las respuestas.
//   setState(() => _isLoading = true);
//   try {
//     final prefs = await SharedPreferences.getInstance();
//     final String? token = prefs.getString('token');

//     for (var q in _questions) {
//       final preguntaId = q['id'];
//       final bool respuesta = _answers[preguntaId] ?? false;

//       final response = await http.post(
//         Uri.parse('${GlobalConfig.apiHost}/respuesta-parq'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: json.encode({
//           'respuestaParq': respuesta,
//           'preguntaParq': preguntaId,
//         }),
//       );

//       if (response.statusCode != 200 && response.statusCode != 201) {
//         throw Exception('Error guardando la pregunta $preguntaId: ${response.body}');
//       }
//     }

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('¡Respuestas guardadas con éxito!')),
//     );
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Error al guardar respuestas: $e')),
//     );
//   } finally {
//     setState(() => _isLoading = false);
//   }
// }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Encabezado con degradado
  //     appBar: AppBar(
  //   title: const Text('PAR-Q'),
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
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          
          Expanded(
            child: _isLoading && _questions.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _fetchError
                    ? const Center(
                        child: Text(
                          'Error al cargar las preguntas',
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _questions.length,
                        itemBuilder: (context, index) {
                          final question = _questions[index];
                          final questionId = question['id'];
                          final questionItem = question['item'];
                          final questionText = question['enunciado'];
                          final bool currentAnswer = _answers[questionId] ?? false;

                          // Verificamos si es la última pregunta (item == 8)
                          // para mostrar CheckBox en vez de Sí/No
                          final isLast = (questionItem == '8');

                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.only(bottom: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pregunta $questionItem',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    questionText,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  const SizedBox(height: 12),
                                  if (isLast)
                                    // La última pregunta es un CheckBox
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: currentAnswer,
                                          onChanged: (val) {
                                            setState(() {
                                              _answers[questionId] = val ?? false;
                                            });
                                          },
                                        ),
                                        const Expanded(
                                          child: Text('Acepto y confirmo que la información es correcta.'),
                                        ),
                                      ],
                                    )
                                  else
                                    // Para las demás preguntas, Sí/No con RadioButtons
                                    Row(
                                      children: [
                                        Expanded(
                                          child: RadioListTile<bool>(
                                            title: const Text('Sí'),
                                            value: true,
                                            groupValue: currentAnswer,
                                            onChanged: (val) {
                                              setState(() {
                                                _answers[questionId] = val ?? false;
                                              });
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: RadioListTile<bool>(
                                            title: const Text('No'),
                                            value: false,
                                            groupValue: currentAnswer,
                                            onChanged: (val) {
                                              setState(() {
                                                _answers[questionId] = val ?? false;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
          // Botón para guardar
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveAnswers,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: const Color(0xFF0D47A1),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Guardar Respuestas',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
