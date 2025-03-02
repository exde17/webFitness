import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/config.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class AuthService {
  // final String baseUrl = 'http://10.0.2.2:3000/api'; // Asumiendo que tu backend corre en el puerto 3000

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String fullName,
    required String documentType,
    required int documentNumber, // Numer documentNumber,
    required String phoneNumber,
    required DateTime birthDate,
    required String gender,
    required String address,
    required String neighborhood,
    required String commune,
    required String ethnicity,
    required String condition,
    required String educationLevel,
    required String description,
    required String healthRegime,
    required String eps,
    required String bloodType,
    required String emergencyContactName,
    required String emergencyContactPhone,
    required String poblacionVulnerable,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${GlobalConfig.apiHost}/auth/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
          'name': fullName,
          'documentType': documentType,
          'documentNumber': documentNumber,
          'phoneNumber': phoneNumber,
          'birthDate': birthDate.toIso8601String(),
          'gender': gender,
          'address': address,
          'barrio': neighborhood,
          'comunaCorregimiento': commune,
          'etnia': ethnicity,
          'discapacidad': condition,
          'nivelEducativo': educationLevel,
          'ocupacion': description,
          'regimenSalud': healthRegime,
          'eps': eps,
          'grupoSanquineo': bloodType,
          'contactoEmergencia': emergencyContactName,
          'telefonoContacto': emergencyContactPhone,
          'poblacionVulnerable': poblacionVulnerable,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(json.decode(response.body)['message'] ?? 'Registration failed');
      }
    } catch (e) {
      logger.e('Registration failed: $e');
      throw Exception('Registration failed: $e');
    }
  }
}
