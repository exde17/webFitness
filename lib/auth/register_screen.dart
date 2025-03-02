// // ignore_for_file: use_build_context_synchronously

// import 'package:flutter/material.dart';
// import 'auth_service.dart';
// import 'dart:async';
// import 'package:intl/intl.dart'; // Para formatear fechas y usar DatePicker

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   // Llave para el formulario
//   final _formKey = GlobalKey<FormState>();

//   // Controladores de texto para cada campo
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _fullNameController = TextEditingController();
//   final _documentTypeController = TextEditingController();
//   final _documentNumberController = TextEditingController();
//   final _phoneNumberController = TextEditingController();
//   final _birthDateController = TextEditingController(); // Para mostrar fecha en texto
//   final _genderController = TextEditingController();
//   final _addressController = TextEditingController();
//   final _neighborhoodController = TextEditingController();
//   final _communeController = TextEditingController();
//   final _ethnicityController = TextEditingController();
//   final _conditionController = TextEditingController();
//   final _educationLevelController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   final _healthRegimeController = TextEditingController();
//   final _epsController = TextEditingController();
//   final _bloodTypeController = TextEditingController();
//   final _emergencyContactNameController = TextEditingController();
//   final _emergencyContactPhoneController = TextEditingController();
//   final _poblacionVulnerableController = TextEditingController();

//   // Servicio de autenticación
//   final _authService = AuthService();

//   // Para controlar si se está registrando
//   bool _isLoading = false;

//   // Para almacenar la fecha de nacimiento como DateTime
//   DateTime? _selectedBirthDate;

//   // Validaciones básicas (puedes ajustar a tu gusto)
//   String? _validateRequired(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Campo requerido';
//     }
//     return null;
//   }

//   String? _validateEmail(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Ingresa tu correo';
//     }
//     if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//       return 'Correo inválido';
//     }
//     return null;
//   }

//   String? _validatePassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Ingresa tu contraseña';
//     }
//     if (value.length < 6) {
//       return 'Debe tener al menos 6 caracteres';
//     }
//     return null;
//   }

//   // Lógica para mostrar DatePicker y guardar la fecha
//   Future<void> _pickBirthDate() async {
//     final now = DateTime.now();
//     final initialDate = DateTime(now.year - 18, now.month, now.day); // 18 años atrás como ejemplo
//     final newDate = await showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: DateTime(1900),
//       lastDate: now,
//       helpText: 'Selecciona tu fecha de nacimiento',
//       cancelText: 'Cancelar',
//       confirmText: 'OK',
//     );
//     if (newDate == null) return;
//     setState(() {
//       _selectedBirthDate = newDate;
//       _birthDateController.text = DateFormat('yyyy-MM-dd').format(newDate);
//     });
//   }

//   // Función de registro
//   Future<void> _register() async {
//     if (!_formKey.currentState!.validate()) return;

//     if (_selectedBirthDate == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Por favor, selecciona tu fecha de nacimiento')),
//       );
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       final response = await _authService.register(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//         fullName: _fullNameController.text.trim(),
//         documentType: _documentTypeController.text.trim(),
//         documentNumber: int.parse(_documentNumberController.text.trim()),
//         phoneNumber: _phoneNumberController.text.trim(),
//         birthDate: _selectedBirthDate!,
//         gender: _genderController.text.trim(),
//         address: _addressController.text.trim(),
//         neighborhood: _neighborhoodController.text.trim(),
//         commune: _communeController.text.trim(),
//         ethnicity: _ethnicityController.text.trim(),
//         condition: _conditionController.text.trim(),
//         educationLevel: _educationLevelController.text.trim(),
//         description: _descriptionController.text.trim(),
//         healthRegime: _healthRegimeController.text.trim(),
//         eps: _epsController.text.trim(),
//         bloodType: _bloodTypeController.text.trim(),
//         emergencyContactName: _emergencyContactNameController.text.trim(),
//         emergencyContactPhone: _emergencyContactPhoneController.text.trim(),
//         poblacionVulnerable: _poblacionVulnerableController.text.trim(),
//       );

//       // Si llega aquí, asume registro exitoso
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('¡Registro exitoso!'),
//           backgroundColor: Colors.green,
//         ),
//       );
//       Navigator.of(context).pop(); // Regresar a la pantalla anterior o ir al login
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(e.toString()),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   void dispose() {
//     // Liberar recursos
//     _emailController.dispose();
//     _passwordController.dispose();
//     _fullNameController.dispose();
//     _documentTypeController.dispose();
//     _documentNumberController.dispose();
//     _phoneNumberController.dispose();
//     _birthDateController.dispose();
//     _genderController.dispose();
//     _addressController.dispose();
//     _neighborhoodController.dispose();
//     _communeController.dispose();
//     _ethnicityController.dispose();
//     _conditionController.dispose();
//     _educationLevelController.dispose();
//     _descriptionController.dispose();
//     _healthRegimeController.dispose();
//     _epsController.dispose();
//     _bloodTypeController.dispose();
//     _emergencyContactNameController.dispose();
//     _emergencyContactPhoneController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // Encabezado con degradado e ilustración
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Sección superior con degradado y título
//             Container(
//               height: 250,
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Color(0xFFF44336), Color(0xFFFFC107)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//               child: const Stack(
//                 children: [
//                   // Puedes agregar una ilustración de fondo si gustas
//                   Positioned(
//                     top: 60,
//                     left: 20,
//                     child: Text(
//                       'Crea tu Cuenta',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 32,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     top: 110,
//                     left: 20,
//                     child: Text(
//                       'Completa tus datos para registrarte',
//                       style: TextStyle(
//                         color: Colors.white70,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Formulario
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     // Nombre completo
//                     TextFormField(
//                       controller: _fullNameController,
//                       decoration: const InputDecoration(
//                         labelText: 'Nombre Completo',
//                         border: OutlineInputBorder(),
//                       ),
//                       validator: _validateRequired,
//                     ),
//                     const SizedBox(height: 16),

//                     // Email
//                     TextFormField(
//                       controller: _emailController,
//                       decoration: const InputDecoration(
//                         labelText: 'Email',
//                         border: OutlineInputBorder(),
//                       ),
//                       keyboardType: TextInputType.emailAddress,
//                       validator: _validateEmail,
//                     ),
//                     const SizedBox(height: 16),

//                     // Password
//                     TextFormField(
//                       controller: _passwordController,
//                       decoration: const InputDecoration(
//                         labelText: 'Contraseña',
//                         border: OutlineInputBorder(),
//                       ),
//                       obscureText: true,
//                       validator: _validatePassword,
//                     ),
//                     const SizedBox(height: 16),

//                     // Tipo de documento
//                     TextFormField(
//                       controller: _documentTypeController,
//                       decoration: const InputDecoration(
//                         labelText: 'Tipo de Documento (ej: CC, TI, etc.)',
//                         border: OutlineInputBorder(),
//                       ),
//                       validator: _validateRequired,
//                     ),
//                     const SizedBox(height: 16),

//                     // Número de documento
//                     TextFormField(
//                       controller: _documentNumberController,
//                       decoration: const InputDecoration(
//                         labelText: 'Número de Documento',
//                         border: OutlineInputBorder(),
//                       ),
//                       keyboardType: TextInputType.number,
//                       validator: _validateRequired,
//                     ),
//                     const SizedBox(height: 16),

//                     // Teléfono
//                     TextFormField(
//                       controller: _phoneNumberController,
//                       decoration: const InputDecoration(
//                         labelText: 'Teléfono',
//                         border: OutlineInputBorder(),
//                       ),
//                       keyboardType: TextInputType.phone,
//                       validator: _validateRequired,
//                     ),
//                     const SizedBox(height: 16),

//                     // Fecha de nacimiento (con DatePicker)
//                     TextFormField(
//                       controller: _birthDateController,
//                       readOnly: true,
//                       decoration: const InputDecoration(
//                         labelText: 'Fecha de Nacimiento',
//                         border: OutlineInputBorder(),
//                       ),
//                       onTap: _pickBirthDate,
//                       validator: _validateRequired,
//                     ),
//                     const SizedBox(height: 16),

//                     // Género
//                     TextFormField(
//                       controller: _genderController,
//                       decoration: const InputDecoration(
//                         labelText: 'Género',
//                         border: OutlineInputBorder(),
//                       ),
//                       validator: _validateRequired,
//                     ),
//                     const SizedBox(height: 16),

//                     // Dirección
//                     TextFormField(
//                       controller: _addressController,
//                       decoration: const InputDecoration(
//                         labelText: 'Dirección',
//                         border: OutlineInputBorder(),
//                       ),
//                       validator: _validateRequired,
//                     ),
//                     const SizedBox(height: 16),

//                     // Barrio
//                     TextFormField(
//                       controller: _neighborhoodController,
//                       decoration: const InputDecoration(
//                         labelText: 'Barrio',
//                         border: OutlineInputBorder(),
//                       ),
//                       validator: _validateRequired,
//                     ),
//                     const SizedBox(height: 16),

//                     // Comuna
//                     TextFormField(
//                       controller: _communeController,
//                       decoration: const InputDecoration(
//                         labelText: 'Comuna',
//                         border: OutlineInputBorder(),
//                       ),
//                       validator: _validateRequired,
//                     ),
//                     const SizedBox(height: 16),

//                     // Etnia
//                     TextFormField(
//                       controller: _ethnicityController,
//                       decoration: const InputDecoration(
//                         labelText: 'Etnia',
//                         border: OutlineInputBorder(),
//                       ),
//                       validator: _validateRequired,
//                     ),
//                     const SizedBox(height: 16),

//                     // Condición
//                     TextFormField(
//                       controller: _conditionController,
//                       decoration: const InputDecoration(
//                         labelText: 'Condición (ej: discapacidad)',
//                         border: OutlineInputBorder(),
//                       ),
//                       validator: _validateRequired,
//                     ),
//                     const SizedBox(height: 16),

//                     // Nivel de educación
//                     TextFormField(
//                       controller: _educationLevelController,
//                       decoration: const InputDecoration(
//                         labelText: 'Nivel de educación',
//                         border: OutlineInputBorder(),
//                       ),
//                       validator: _validateRequired,
//                     ),
//                     const SizedBox(height: 16),

//                     // Descripción
//                     TextFormField(
//                       controller: _descriptionController,
//                       maxLines: 3,
//                       decoration: const InputDecoration(
//                         labelText: 'Descripción',
//                         border: OutlineInputBorder(),
//                       ),
//                       validator: _validateRequired,
//                     ),
//                     const SizedBox(height: 16),

//                     // Régimen de salud
//                     TextFormField(
//                       controller: _healthRegimeController,
//                       decoration: const InputDecoration(
//                         labelText: 'Régimen de salud',
//                         border: OutlineInputBorder(),
//                       ),
//                       validator: _validateRequired,
//                     ),
//                     const SizedBox(height: 16),

//                     // EPS
//                     TextFormField(
//                       controller: _epsController,
//                       decoration: const InputDecoration(
//                         labelText: 'EPS',
//                         border: OutlineInputBorder(),
//                       ),
//                       validator: _validateRequired,
//                     ),
//                     const SizedBox(height: 16),

//                     // Grupo sanguíneo
//                     TextFormField(
//                       controller: _bloodTypeController,
//                       decoration: const InputDecoration(
//                         labelText: 'Grupo sanguíneo (ej: O+)',
//                         border: OutlineInputBorder(),
//                       ),
//                       validator: _validateRequired,
//                     ),
//                     const SizedBox(height: 16),

//                     // Contacto de emergencia (nombre)
//                     TextFormField(
//                       controller: _emergencyContactNameController,
//                       decoration: const InputDecoration(
//                         labelText: 'Contacto de emergencia (Nombre)',
//                         border: OutlineInputBorder(),
//                       ),
//                       validator: _validateRequired,
//                     ),
//                     const SizedBox(height: 16),

//                     // Población vulnerable
//                     TextFormField(
//                       controller: _poblacionVulnerableController,
//                       decoration: const InputDecoration(
//                         labelText: 'Población vulnerable',
//                         border: OutlineInputBorder(),
//                       ),
//                       validator: _validateRequired,
//                     ),

//                     // Contacto de emergencia (teléfono)
//                     TextFormField(
//                       controller: _emergencyContactPhoneController,
//                       decoration: const InputDecoration(
//                         labelText: 'Contacto de emergencia (Teléfono)',
//                         border: OutlineInputBorder(),
//                       ),
//                       keyboardType: TextInputType.phone,
//                       validator: _validateRequired,
//                     ),
//                     const SizedBox(height: 24),

//                     // Botón de Registro
//                     SizedBox(
//                       width: double.infinity,
//                       height: 50,
//                       child: ElevatedButton(
//                         onPressed: _isLoading ? null : _register,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFFF44336),
//                         ),
//                         child: _isLoading
//                             ? const CircularProgressIndicator(color: Colors.white)
//                             : const Text(
//                                 'Registrarme',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                       ),
//                     ),
//                     const SizedBox(height: 32),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: use_build_context_synchronously

// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Para formatear fechas y usar DatePicker
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/config.dart';
import 'auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Llave para el formulario
  final _formKey = GlobalKey<FormState>();

  // Controladores de texto para cada campo
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _documentTypeController = TextEditingController();
  final _documentNumberController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _birthDateController =
      TextEditingController(); // Para mostrar la fecha en texto
  final _genderController = TextEditingController();
  final _addressController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _communeController = TextEditingController();
  final _ethnicityController = TextEditingController();
  final _conditionController = TextEditingController();
  final _educationLevelController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _healthRegimeController = TextEditingController();
  final _epsController = TextEditingController();
  final _bloodTypeController = TextEditingController();
  final _emergencyContactNameController = TextEditingController();
  final _emergencyContactPhoneController = TextEditingController();
  final _poblacionVulnerableController = TextEditingController();

  // Servicio de autenticación
  final _authService = AuthService();

  // Para controlar el estado de carga
  bool _isLoading = false;

  // Para almacenar la fecha de nacimiento como DateTime
  DateTime? _selectedBirthDate;

  // Validaciones básicas
  String? _validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo requerido';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa tu correo';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Correo inválido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa tu contraseña';
    }
    if (value.length < 6) {
      return 'Debe tener al menos 6 caracteres';
    }
    return null;
  }

  // Lógica para mostrar DatePicker y guardar la fecha
  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final initialDate = DateTime(now.year - 18, now.month, now.day);
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: 'Selecciona tu fecha de nacimiento',
      cancelText: 'Cancelar',
      confirmText: 'OK',
    );
    if (newDate == null) return;
    setState(() {
      _selectedBirthDate = newDate;
      _birthDateController.text = DateFormat('yyyy-MM-dd').format(newDate);
    });
  }

  // Función de registro
  Future<void> _register() async {
    if (!_formKey.currentState!.validate() || _selectedBirthDate == null)
      return;

    setState(() => _isLoading = true);

    try {
      final response = await _authService.register(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        fullName: _fullNameController.text.trim(),
        documentType: _documentTypeController.text.trim(),
        documentNumber: int.parse(_documentNumberController.text.trim()),
        phoneNumber: _phoneNumberController.text.trim(),
        birthDate: _selectedBirthDate!,
        gender: _genderController.text.trim(),
        address: _addressController.text.trim(),
        neighborhood: _neighborhoodController.text.trim(),
        commune: _communeController.text.trim(),
        ethnicity: _ethnicityController.text.trim(),
        condition: _conditionController.text.trim(),
        educationLevel: _educationLevelController.text.trim(),
        description: _descriptionController.text.trim(),
        healthRegime: _healthRegimeController.text.trim(),
        eps: _epsController.text.trim(),
        bloodType: _bloodTypeController.text.trim(),
        emergencyContactName: _emergencyContactNameController.text.trim(),
        emergencyContactPhone: _emergencyContactPhoneController.text.trim(),
        poblacionVulnerable: _poblacionVulnerableController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Registro exitoso!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _documentTypeController.dispose();
    _documentNumberController.dispose();
    _phoneNumberController.dispose();
    _birthDateController.dispose();
    _genderController.dispose();
    _addressController.dispose();
    _neighborhoodController.dispose();
    _communeController.dispose();
    _ethnicityController.dispose();
    _conditionController.dispose();
    _educationLevelController.dispose();
    _descriptionController.dispose();
    _healthRegimeController.dispose();
    _epsController.dispose();
    _bloodTypeController.dispose();
    _emergencyContactNameController.dispose();
    _emergencyContactPhoneController.dispose();
    _poblacionVulnerableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fondo con imagen y capa semitransparente para un efecto moderno
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/img/fondo7.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Reducimos la opacidad para mayor transparencia (0.25 en vez de 0.35)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.25),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
            child: Column(
              children: [
                // Título
                const Text(
                  'Crea tu Cuenta',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Completa tus datos para registrarte',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 30),
                // Tarjeta del formulario con mayor transparencia (0.85)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildRoundedTextField(
                            controller: _fullNameController,
                            label: "Nombre Completo",
                            icon: Icons.person),
                        const SizedBox(height: 10),
                        _buildRoundedTextField(
                            controller: _emailController,
                            label: "Email",
                            icon: Icons.email,
                            validator: _validateEmail),
                        const SizedBox(height: 10),
                        _buildRoundedTextField(
                            controller: _passwordController,
                            label: "Contraseña",
                            isPassword: true,
                            icon: Icons.lock,
                            validator: _validatePassword),
                        const SizedBox(height: 10),
                        _buildDocumentTypeDropdown(),
                        const SizedBox(height: 10),
                        _buildRoundedTextField(
                            controller: _documentNumberController, 
                            label: "Número de Documento",
                            icon: Icons.credit_card,
                            inputType: TextInputType.number),
                            const SizedBox(height: 10),
                        _buildRoundedTextField(
                            controller: _phoneNumberController,
                            label: "Teléfono",
                            icon: Icons.phone,
                            inputType: TextInputType.phone),
                            const SizedBox(height: 10),
                        // _buildDateField(
                        //     controller: _birthDateController,
                        //     label: "Fecha de Nacimiento",
                        //     icon: Icons.calendar_today,
                        //     validator: _validateRequired),
                        // // _buildDateField("Fecha de Nacimiento"),
                        // const SizedBox(height: 10
                        //     // _buildTextField(_birthDateController, "Fecha de Nacimiento"),
                        // ),
                        // _buildTextField(_genderController, "Género"),
                        _buildDateField(),
                        const SizedBox(height: 10),
                        _buildGenderDropdown(),
                        const SizedBox(height: 10),
                        _buildRoundedTextField(
                          controller:_addressController, 
                          label: "Dirección",
                          icon: Icons.location_on),
                        const SizedBox(height: 10),
                        _buildRoundedTextField(
                            controller: _neighborhoodController, 
                            label: "Barrio",
                            icon: Icons.location_city),
                        const SizedBox(height: 10),
                        _buildRoundedTextField(
                          controller: _communeController, 
                          label: "Comuna",
                          icon: Icons.location_city
                          ),
                        const SizedBox(height: 10),
                        _buildRoundedTextField(
                            controller: _ethnicityController, 
                            label: "Etnia",
                            icon: Icons.people),
                        const SizedBox(height: 10),
                        _buildRoundedTextField(
                          controller: _conditionController,
                           label: "Condición (ej: discapacidad)",
                           icon: Icons.accessibility,
                           ),
                        const SizedBox(height: 10),
                        _buildRoundedTextField(
                           controller: _educationLevelController, 
                           label: "Nivel de educación",
                           icon: Icons.school,
                           ),
                        const SizedBox(height: 10),
                        _buildRoundedTextField(
                            controller: _descriptionController, 
                            label: "Descripción",
                            icon: Icons.description,
                            maxLines: 3),
                        const SizedBox(height: 10),
                        _buildRoundedTextField(
                           controller: _healthRegimeController, 
                           label: "Régimen de salud",
                           icon: Icons.medical_services,
                           ),
                        const SizedBox(height: 10),
                        _buildRoundedTextField(
                            controller: _epsController, 
                            label: "EPS",
                            icon: Icons.local_hospital),
                        const SizedBox(height: 10),
                        // _buildTextField(
                        //     _bloodTypeController, "Grupo sanguíneo (ej: O+)"),
                        _buildBloodTypeDropdown(),
                        const SizedBox(height: 10),
                        _buildRoundedTextField(
                            controller: _emergencyContactNameController,
                            label: "Contacto de emergencia (Nombre)",
                            icon: Icons.person),
                        const SizedBox(height: 10),
                        _buildRoundedTextField(
                            controller: _poblacionVulnerableController,
                            label: "Población vulnerable",
                            icon: Icons.warning),
                        const SizedBox(height: 10),
                        _buildRoundedTextField(
                            controller: _emergencyContactPhoneController,
                            label: "Contacto de emergencia (Teléfono)",
                            icon: Icons.phone,
                            inputType: TextInputType.phone),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF44336),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text(
                                    'Registrarme',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildTextField(
  //   TextEditingController controller,
  //   String label, {
  //   bool obscureText = false,
  //   TextInputType inputType = TextInputType.text,
  //   int maxLines = 1,
  //   String? Function(String?)? validator,
  // }) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8),
  //     child: TextFormField(
  //       controller: controller,
  //       obscureText: obscureText,
  //       keyboardType: inputType,
  //       maxLines: maxLines,
  //       decoration: InputDecoration(
  //         labelText: label,
  //         border: const OutlineInputBorder(),
  //       ),
  //       validator: validator ?? _validateRequired,
  //     ),
  //   );
  // }

  Widget _buildDateField() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: TextFormField(
      controller: _birthDateController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Fecha de Nacimiento',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // Bordes redondeados
        ),
        filled: true,
        fillColor: Colors.grey[200], // Fondo suave
        prefixIcon: const Icon(Icons.calendar_today, color: Colors.blue), // Icono de calendario
      ),
      onTap: _pickBirthDate,
      validator: _validateRequired,
    ),
  );
}


  // tipo de sangre

  Widget _buildBloodTypeDropdown() {
  return DropdownButtonFormField<String>(
    value: _bloodTypeController.text.isNotEmpty ? _bloodTypeController.text : null,
    decoration: InputDecoration(
      labelText: "Grupo sanguíneo",
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), // Bordes redondeados
      ),
      filled: true,
      fillColor: Colors.grey[200], // Color de fondo suave
      prefixIcon: const Icon(Icons.bloodtype, color: Colors.red), // Icono de sangre
    ),
    items: const [
      DropdownMenuItem(value: "O+", child: Text("O+")),
      DropdownMenuItem(value: "O-", child: Text("O-")),
      DropdownMenuItem(value: "A+", child: Text("A+")),
      DropdownMenuItem(value: "A-", child: Text("A-")),
      DropdownMenuItem(value: "B+", child: Text("B+")),
      DropdownMenuItem(value: "B-", child: Text("B-")),
      DropdownMenuItem(value: "AB+", child: Text("AB+")),
      DropdownMenuItem(value: "AB-", child: Text("AB-")),
    ],
    onChanged: (String? newValue) {
      if (newValue != null) {
        setState(() {
          _bloodTypeController.text = newValue;
        });
      }
    },
  );
}


// Widget para el Dropdown de Tipo de Documento
  Widget _buildDocumentTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: _documentTypeController.text.isNotEmpty
          ? _documentTypeController.text
          : null, // Valor seleccionado
      decoration: InputDecoration(
        labelText: "Tipo de Documento",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), // Bordes redondeados
        ),
        filled: true,
        fillColor: Colors.grey[200], // Fondo suave para destacar el campo
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      icon: const Icon(Icons.arrow_drop_down,
          color: Colors.deepPurple, size: 28), // Ícono de flecha
      style: const TextStyle(
          fontSize: 16, color: Colors.black), // Estilo del texto
      dropdownColor: Colors.white, // Color del menú desplegable
      items: const [
        DropdownMenuItem(
          value: "Cedula de Ciudadania",
          child: Row(
            children: [
              Icon(Icons.credit_card, color: Colors.blue), // Icono para CC
              SizedBox(width: 10),
              Text("Cédula de Ciudadanía"),
            ],
          ),
        ),
        DropdownMenuItem(
          value: "Pasaporte",
          child: Row(
            children: [
              Icon(Icons.airplane_ticket,
                  color: Colors.orange), // Icono para Pasaporte
              SizedBox(width: 10),
              Text("Pasaporte"),
            ],
          ),
        ),
        DropdownMenuItem(
          value: "DRIVER_LICENSE",
          child: Row(
            children: [
              Icon(Icons.directions_car,
                  color: Colors.green), // Icono para Licencia
              SizedBox(width: 10),
              Text("Licencia de Conducción"),
            ],
          ),
        ),
        DropdownMenuItem(
          value: "Tarjeta de Identidad",
          child: Row(
            children: [
              Icon(Icons.badge, color: Colors.purple), // Icono para TI
              SizedBox(width: 10),
              Text("Tarjeta de Identidad"),
            ],
          ),
        ),
      ],
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            _documentTypeController.text =
                newValue; // Guardar el valor seleccionado
          });
        }
      },
    );
  }

// widget para genero
  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: _genderController.text.isNotEmpty
          ? _genderController.text
          : null, // Valor seleccionado
      decoration: InputDecoration(
        labelText: "Género",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), // Bordes redondeados
        ),
        filled: true,
        fillColor: Colors.grey[200], // Fondo suave para destacar el campo
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      icon: const Icon(Icons.arrow_drop_down,
          color: Colors.deepPurple, size: 28), // Ícono personalizado
      style: const TextStyle(
          fontSize: 16, color: Colors.black), // Estilo del texto
      dropdownColor: Colors.white, // Color del menú desplegable
      items: const [
        DropdownMenuItem(
          value: "Masculino",
          child: Row(
            children: [
              Icon(Icons.male, color: Colors.blue), // Icono para masculino
              SizedBox(width: 10),
              Text("Masculino"),
            ],
          ),
        ),
        DropdownMenuItem(
          value: "Femenino",
          child: Row(
            children: [
              Icon(Icons.female, color: Colors.pink), // Icono para femenino
              SizedBox(width: 10),
              Text("Femenino"),
            ],
          ),
        ),
        DropdownMenuItem(
          value: "Otro",
          child: Row(
            children: [
              Icon(Icons.transgender, color: Colors.purple), // Icono para otro
              SizedBox(width: 10),
              Text("Otro"),
            ],
          ),
        ),
      ],
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            _genderController.text = newValue; // Guardar el valor seleccionado
          });
        }
      },
    );
  }

// decoracion de campos de textos
  Widget _buildRoundedTextField({
    required TextEditingController controller,
    required String label,
    TextInputType inputType = TextInputType.text,
    IconData? icon,
    bool isPassword = false,
    String? Function(String?)? validator, // Agregamos el validador
     int maxLines = 1,
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
