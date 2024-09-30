import 'package:flutter/material.dart';
import 'gestor_ejercicios.dart';

class EjemploWidget extends StatefulWidget {
  @override
  _EjemploWidgetState createState() => _EjemploWidgetState();
}

class _EjemploWidgetState extends State<EjemploWidget> {
  List<Map<String, dynamic>> ejercicios = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _cargarEjercicios();
  }

  Future<void> _cargarEjercicios() async {
    setState(() {
      isLoading = true;
    });

    String email =
        'usuario@ejemplo.com'; // Obtén esto de tu sistema de autenticación
    try {
      List<Map<String, dynamic>> ejerciciosCargados =
          await GestorEjercicios.obtenerEjercicios(email);
      setState(() {
        ejercicios = ejerciciosCargados;
      });
    } catch (e) {
      print('Error al cargar ejercicios: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar ejercicios: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _guardarEjercicio() async {
    String email = 'usuario@ejemplo.com';
    String nombre = 'Nuevo ejercicio';
    String descripcion = 'Descripción del nuevo ejercicio';
    int duracion = 30;

    try {
      bool guardadoExitoso = await GestorEjercicios.guardarEjercicio(
          email, nombre, descripcion, duracion);
      if (guardadoExitoso) {
        print('Ejercicio guardado exitosamente');
        _cargarEjercicios(); // Recarga la lista de ejercicios
      } else {
        print('Error al guardar el ejercicio');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar el ejercicio')),
        );
      }
    } catch (e) {
      print('Error al guardar ejercicio: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar ejercicio: $e')),
      );
    }
  }

  Future<void> _eliminarEjercicio(String nombre, String fecha) async {
    String email = 'usuario@ejemplo.com';

    try {
      bool eliminadoExitoso =
          await GestorEjercicios.eliminarEjercicio(email, nombre, fecha);
      if (eliminadoExitoso) {
        print('Ejercicio eliminado exitosamente');
        _cargarEjercicios(); // Recarga la lista de ejercicios
      } else {
        print('Error al eliminar el ejercicio');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar el ejercicio')),
        );
      }
    } catch (e) {
      print('Error al eliminar ejercicio: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar ejercicio: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mis Ejercicios')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: ejercicios.length,
              itemBuilder: (context, index) {
                final ejercicio = ejercicios[index];
                return ListTile(
                  title: Text(ejercicio['nombre']),
                  subtitle: Text(ejercicio['descripcion']),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _eliminarEjercicio(
                        ejercicio['nombre'], ejercicio['fecha']),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _guardarEjercicio,
        child: Icon(Icons.add),
      ),
    );
  }
}
