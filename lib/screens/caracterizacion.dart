// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:fitness/utils/config.dart';
import 'package:fitness/utils/customDrawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class CaracterizacionScreen extends StatefulWidget {
  final String? userId;
  const CaracterizacionScreen({super.key, this.userId});

  @override
  State<CaracterizacionScreen> createState() => _BodyMeasurementsScreenState();
}

class _BodyMeasurementsScreenState extends State<CaracterizacionScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para cada campo
  String? _selectedGender;
  final List<String> _genders = ['Masculino', 'Femenino', 'Otro'];

  final _pesoController = TextEditingController();
  final _estaturaController = TextEditingController();
  final _perimetroCuelloController = TextEditingController();
  final _perimetroCaderaController = TextEditingController();
  final _perimetroBrazoRelajadoController = TextEditingController();
  final _perimetroBrazoContraidoController = TextEditingController();
  final _perimetroAbdominalCinturaController = TextEditingController();
  final _perimetroMusloMaximoController = TextEditingController();
  final _perimetroMusloMedialController = TextEditingController();
  final _perimetroPiernaMaximaController = TextEditingController();
  // declaro la variable userId
  String userIdp = '';

  bool _isLoading = false;

  // Actualiza este método en CaracterizacionScreen.dart
  @override
  void initState() {
    super.initState();
    // Inicializa userIdp con el valor del constructor
    if (widget.userId != null && widget.userId!.isNotEmpty) {
      userIdp = widget.userId!;
      logger.i('ID recibido en initState: $userIdp');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Si el ID ya se configuró en initState, no necesitamos hacer nada más
    if (userIdp.isNotEmpty) return;

    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is String && args.isNotEmpty) {
      setState(() {
        userIdp = args;
      });
      logger.i('Usuario recibido en Caracterización: $userIdp');
    } else {
      logger.e(
          '⛔ Error: No se recibió un ID válido en Caracterización. Tipo: ${args?.runtimeType}');
    }
  }

  // Validación básica: que el campo no esté vacío
  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Campo requerido';
    }
    return null;
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate() || _selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Preparar el payload, convirtiendo los campos numéricos a double
    final payload = {
      'gender': _selectedGender,
      'peso': double.parse(_pesoController.text.trim()),
      'estatura': double.parse(_estaturaController.text.trim()),
      'perimetroCuello': double.parse(_perimetroCuelloController.text.trim()),
      'perimetroCadera': double.parse(_perimetroCaderaController.text.trim()),
      'perimetroBrazoRellajado':
          double.parse(_perimetroBrazoRelajadoController.text.trim()),
      'perimetroBrazoContraido':
          double.parse(_perimetroBrazoContraidoController.text.trim()),
      'perimetroAbdominalCintura':
          double.parse(_perimetroAbdominalCinturaController.text.trim()),
      'perimetroMusloMaximo':
          double.parse(_perimetroMusloMaximoController.text.trim()),
      'perimetroMusloMedial':
          double.parse(_perimetroMusloMedialController.text.trim()),
      'perimetroPiernaMaxima':
          double.parse(_perimetroPiernaMaximaController.text.trim()),
      'user': userIdp,
    };

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      final bool parq = prefs.getBool('parq') ?? false;
      final bool parqAprovado = prefs.getBool('parqAprovado') ?? false;

      final response = await http.post(
        Uri.parse('${GlobalConfig.apiHost}/caracterizacion'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Add token in the header
        },
        body: json.encode(payload),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.body);
        // verifico si el parq esta en false para redirigir a la pantalla de inicio pendiente
        Navigator.pushNamed(context, '/');

        // if (parq == false) {
        //   Navigator.pushNamed(context, '/parqScreen');
        // } else if (parqAprovado == false) {
        //   Navigator.pushNamed(context, '/inicioPendiente');
        // } else {
        //   Navigator.pushNamed(context, '/');
        // }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Datos guardados correctamente'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        logger.e('Error: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.body}')),
        );
      }
    } catch (e) {
      logger.e('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    // Limpia controladores
    _pesoController.dispose();
    _estaturaController.dispose();
    _perimetroCuelloController.dispose();
    _perimetroCaderaController.dispose();
    _perimetroBrazoRelajadoController.dispose();
    _perimetroBrazoContraidoController.dispose();
    _perimetroAbdominalCinturaController.dispose();
    _perimetroMusloMaximoController.dispose();
    _perimetroMusloMedialController.dispose();
    _perimetroPiernaMaximaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.i('Usuario seleccionado en Caracterización (en build): $userIdp');

    if (userIdp.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(
          child: Text(
            'Error: No se recibió el ID del usuario.',
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),
        ),
      );
    }
    return Scaffold(
      // Encabezado con degradado
      // appBar: AppBar(
      //   title: const Text('Ingresa tus mediciones'),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Formulario
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Dropdown para seleccionar el género
                    // DropdownButtonFormField<String>(
                    //   decoration: const InputDecoration(
                    //     labelText: 'Género',
                    //     border: OutlineInputBorder(),
                    //   ),
                    //   value: _selectedGender,
                    //   items: _genders
                    //       .map((gender) => DropdownMenuItem(
                    //             value: gender,
                    //             child: Text(gender),
                    //           ))
                    //       .toList(),
                    //   onChanged: (value) {
                    //     setState(() {
                    //       _selectedGender = value;
                    //     });
                    //   },
                    //   validator: (value) => value == null || value.isEmpty
                    //       ? 'Selecciona tu género'
                    //       : null,
                    // ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Género',
                        labelStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          // color: Colors.blueAccent,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              12), // Bordes más redondeados
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          // borderSide: const BorderSide(
                          //     color: Colors.blueAccent, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          // borderSide: const BorderSide(
                          //     color: Colors.deepPurpleAccent, width: 2),
                        ),
                        filled: true,
                        // fillColor: Colors.blue.withOpacity(0.1), // Fondo sutil
                        // prefixIcon: const Icon(Icons.person_outline,
                        //     color: Colors.blueAccent), // Ícono
                      ),
                      value: _selectedGender,
                      items: _genders
                          .map((gender) => DropdownMenuItem(
                                value: gender,
                                child: Text(
                                  gender,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                      validator: (value) => value == null || value.isEmpty
                          ? 'Selecciona tu género'
                          : null,
                      dropdownColor: Colors.white, // Fondo del dropdown
                      icon: const Icon(Icons.arrow_drop_down,
                          // color: Colors.blueAccent,
                          size: 28), // Ícono de dropdown estilizado
                    ),

                    const SizedBox(height: 16),

                    // Campo de peso
                    _buildRoundedTextField(
                      controller: _pesoController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        // label: Text('Peso (kg)'),
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateRequired,
                      label: 'Peso (kg)',
                    ),
                    const SizedBox(height: 16),

                    // Campo de estatura
                    _buildRoundedTextField(
                      controller: _estaturaController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateRequired,
                      label: 'Estatura (cm)',
                    ),
                    const SizedBox(height: 16),

                    // Perímetro de cuello
                    _buildRoundedTextField(
                      controller: _perimetroCuelloController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateRequired,
                      label: 'Perímetro de cuello (cm)',
                    ),
                    const SizedBox(height: 16),

                    // Perímetro de cadera
                    _buildRoundedTextField(
                      controller: _perimetroCaderaController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateRequired,
                      label: 'Perímetro de cadera (cm)',
                    ),
                    const SizedBox(height: 16),

                    // Perímetro de brazo relajado
                    _buildRoundedTextField(
                      controller: _perimetroBrazoRelajadoController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Perímetro de brazo relajado (cm)',
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateRequired,
                      label: 'Perímetro de brazo relajado (cm)',
                    ),
                    const SizedBox(height: 16),

                    // Perímetro de brazo contraído
                    _buildRoundedTextField(
                      controller: _perimetroBrazoContraidoController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateRequired,
                      label: 'Perímetro de brazo contraído (cm)',
                    ),
                    const SizedBox(height: 16),

                    // Perímetro abdominal/cintura
                    _buildRoundedTextField(
                      controller: _perimetroAbdominalCinturaController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateRequired,
                      label: 'Perímetro abdominal/cintura (cm)',
                    ),
                    const SizedBox(height: 16),

                    // Perímetro de muslo máximo
                    _buildRoundedTextField(
                      controller: _perimetroMusloMaximoController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateRequired,
                      label: 'Perímetro de muslo máximo (cm)',
                    ),
                    const SizedBox(height: 16),

                    // Perímetro de muslo medial
                    _buildRoundedTextField(
                      controller: _perimetroMusloMedialController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateRequired,
                      label: 'Perímetro de muslo medial (cm)',
                    ),
                    const SizedBox(height: 16),

                    // Perímetro de pierna máxima
                    _buildRoundedTextField(
                      controller: _perimetroPiernaMaximaController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateRequired,
                      label: 'Perímetro de pierna máxima (cm)',
                    ),
                    const SizedBox(height: 24),

                    // Botón de enviar
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF010066),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text(
                                'Enviar',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundedTextField({
    required TextEditingController controller,
    required String label,
    TextInputType inputType = TextInputType.text,
    IconData? icon,
    bool isPassword = false,
    String? Function(String?)? validator, // Agregamos el validador
    int maxLines = 1,
    required TextInputType keyboardType,
    required InputDecoration decoration,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      obscureText: isPassword,
      validator: validator, // Usamos el validador si se pasa
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // Bordes redondeados
        ),
      ),
    );
  }
}
