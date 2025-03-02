// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:fitness/auth/auth_service.dart';
import 'package:fitness/utils/config.dart';
import 'package:fitness/utils/customDrawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RespuestaCaracterizacionScreen extends StatefulWidget {
  final String? userId;
  const RespuestaCaracterizacionScreen({super.key, this.userId});

  @override
  // ignore: library_private_types_in_public_api
  _RespuestaCaracterizacionScreen createState() =>
      _RespuestaCaracterizacionScreen();
}

class _RespuestaCaracterizacionScreen
    extends State<RespuestaCaracterizacionScreen> {
  Map<String, dynamic>? caracterizacionData;
  bool _isLoading = true;

   String userIdp = '';

  @override
void initState() {
  super.initState();
  if (widget.userId != null && widget.userId!.isNotEmpty) {
    userIdp = widget.userId!;
    logger.i('✅ ID recibido en initState: $userIdp');
  } else {
    logger.w('⚠️ ID no recibido en initState');
  }
  _fetchCaracterizacionData(); // Llamar después de definir userIdp
}


   @override
void didChangeDependencies() {
  super.didChangeDependencies();
  
  if (userIdp.isEmpty) {
    final args = ModalRoute.of(context)?.settings.arguments;
    
    if (args is String && args.isNotEmpty) {
      setState(() {
        userIdp = args;
      });
      logger.i('✅ Usuario recibido en Caracterización: $userIdp');
    } else {
      logger.e('⛔ Error: No se recibió un ID válido en Caracterización.');
    }
  }
}


  Future<void> _fetchCaracterizacionData() async {
    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      // final String? iduser = prefs.getString('id');

      if (token == null || userIdp.isEmpty) { // Usa isEmpty en lugar de ==
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('No se encontró la información del usuario'),
    ),
  );
  return;
}

      final Uri url =
          Uri.parse('${GlobalConfig.apiHost}/caracterizacion/$userIdp');
      final response =
          await http.get(url, headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() => caracterizacionData = json.decode(response.body));
      } else {
        logger.e(
            'Error en la respuesta: ${response.statusCode} - ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.body}')),
        );
      }
    } catch (e, stacktrace) {
      logger.e('Exception al cargar datos: $e\nStacktrace: $stacktrace');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cargar los datos')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  double _calculateIMC(double peso, double estatura) {
    return peso / (estatura * estatura);
  }

  Map<String, dynamic> _imcAnalysis(double imc) {
    if (imc < 18.5) return {"text": "Bajo peso", "color": Colors.orange};
    if (imc < 25) return {"text": "Normopeso", "color": Colors.green};
    if (imc < 30) return {"text": "Sobrepeso", "color": Colors.orange};
    if (imc < 35) return {"text": "Obesidad tipo I", "color": Colors.red[300]};
    if (imc < 40) return {"text": "Obesidad tipo II", "color": Colors.red};
    return {"text": "Obesidad tipo III", "color": Colors.red[900]};
  }

  double _calculateICC(double cintura, double cadera) {
    return cintura / cadera;
  }

  Map<String, dynamic> _iccAnalysis(double icc, String gender) {
    if (gender == "Masculino") {
      if (icc < 0.95) return {"text": "Bajo riesgo", "color": Colors.green};
      if (icc <= 1) return {"text": "Moderado", "color": Colors.orange};
      return {"text": "Alto", "color": Colors.red};
    } else {
      if (icc < 0.80) return {"text": "Bajo riesgo", "color": Colors.green};
      if (icc <= 0.85) return {"text": "Moderado", "color": Colors.orange};
      return {"text": "Alto", "color": Colors.red};
    }
  }

  Widget _buildNoDataMessage() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.warning_amber_rounded, size: 80, color: Colors.orange),
        const SizedBox(height: 20),
        const Text(
          "No hay datos disponibles",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          "Aún no se ha registrado ninguna caracterización para este usuario.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => Navigator.pop(context), // Volver a la pantalla anterior
          child: const Text("Regresar"),
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text(
          "Resultados de tu Evaluación",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
           : (caracterizacionData == null || caracterizacionData!.isEmpty)
            ? _buildNoDataMessage() // ✅ Muestra mensaje cuando no hay datos
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //       const Center(
                  //   child: Text(
                  //     'Resultados de tu Evaluación',
                  //     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  //   ),
                  // ),

                  const SizedBox(height: 10),

                  // Aquí va la leyenda de colores
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Guía de interpretación:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                color: Colors.green,
                                margin: const EdgeInsets.only(right: 8),
                              ),
                              const Text("Parámetros normales / Bajo riesgo"),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                color: Colors.orange,
                                margin: const EdgeInsets.only(right: 8),
                              ),
                              const Text("Precaución / Riesgo moderado"),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                color: Colors.red,
                                margin: const EdgeInsets.only(right: 8),
                              ),
                              const Text("Riesgo alto / Requiere atención"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  _buildInfoCard(
                    title: "Datos Generales",
                    content: [
                      _infoTile("Género", caracterizacionData!['gender']),
                      _infoTile("Peso", "${caracterizacionData!['peso']} kg"),
                      _infoTile(
                          "Estatura", "${caracterizacionData!['estatura']} m"),
                    ],
                  ),

                  _buildInfoCard(
                    title: "Análisis de IMC",
                    content: [
                      _infoTile(
                        "IMC",
                        _calculateIMC(
                          double.parse(caracterizacionData!['peso']),
                          double.parse(
                                  caracterizacionData!['estatura'].toString()) *
                              0.01,
                        ).toStringAsFixed(2),
                      ),
                      // Aquí usamos el resultado con color
                      (() {
                        final imc = _calculateIMC(
                          double.parse(caracterizacionData!['peso']),
                          double.parse(
                                  caracterizacionData!['estatura'].toString()) *
                              0.01,
                        );
                        final result = _imcAnalysis(imc);
                        return _infoTile(
                          "Clasificación",
                          result["text"],
                          valueColor: result["color"],
                        );
                      })(),
                    ],
                  ),


                  _buildInfoCard(
                    title: "Análisis de ICC",
                    content: [
                      _infoTile(
                        "ICC",
                        _calculateICC(
                                double.parse(caracterizacionData![
                                    'perimetroAbdominalCintura']),
                                double.parse(
                                    caracterizacionData!['perimetroCadera']))
                            .toStringAsFixed(2),
                      ),
                      // Aquí usamos el resultado con color
                      (() {
                        final icc = _calculateICC(
                          double.parse(caracterizacionData![
                              'perimetroAbdominalCintura']),
                          double.parse(caracterizacionData!['perimetroCadera']),
                        );
                        final result =
                            _iccAnalysis(icc, caracterizacionData!['gender']);
                        return _infoTile(
                          "Clasificación",
                          result["text"],
                          valueColor: result["color"],
                        );
                      })(),
                    ],
                  ),

                  _buildInfoCard(
                    title: "Medidas Corporales",
                    content: [
                      _infoTile("Cintura",
                          "${caracterizacionData!['perimetroAbdominalCintura']} cm"),
                      _infoTile("Cadera",
                          "${caracterizacionData!['perimetroCadera']} cm"),
                      _infoTile("Brazo Relajado",
                          "${caracterizacionData!['perimetroBrazoRellajado']} cm"),
                      _infoTile("Brazo Contraído",
                          "${caracterizacionData!['perimetroBrazoContraido']} cm"),
                      _infoTile("Muslo Máximo",
                          "${caracterizacionData!['perimetroMusloMaximo']} cm"),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoCard(
      {required String title, required List<Widget> content}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ...content,
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: valueColor ?? Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }
}
