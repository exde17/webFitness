
import 'package:fitness/auth/login.dart';
import 'package:fitness/auth/register_screen.dart';
import 'package:fitness/screens/caracterizacion.dart';
import 'package:fitness/screens/inicio.dart';
import 'package:fitness/screens/inicioPendiente.dart';
import 'package:fitness/screens/par-q.dart';
import 'package:fitness/screens/respuesta_caracterizacion.dart';
import 'package:fitness/screens/userListAprobados.dart';
import 'package:flutter/material.dart';

class Rutes {
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String caracterizacion = '/caracterizacion';
  static const String parqScreen = '/parqScreen';
  static const String respuestaCaracterizacion = '/respuestaCaracterizacion';
  static const String inicioPendiente = '/inicioPendiente';
  static const String userListAprobados = '/userListAprobados';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const Inicio());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case caracterizacion:
        return MaterialPageRoute(builder: (_) => const CaracterizacionScreen());  
      case parqScreen:
        return MaterialPageRoute(builder: (_) => const ParqScreen());  
      case respuestaCaracterizacion:
        return MaterialPageRoute(builder: (_) => const RespuestaCaracterizacionScreen());  
      case inicioPendiente:
        return MaterialPageRoute(builder: (_) => const SolicitudEnProceso());  
      case userListAprobados:
        return MaterialPageRoute(builder: (_) => const UserListAprobadosScreen());  
        default:
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(child: Text('No route defined for ${settings.name}')),
            ),
          );
      }
    }
}