import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'user_data_manager.dart';

class EmotionCalendarPage extends StatefulWidget {
  final String userEmail;

  EmotionCalendarPage({required this.userEmail});

  @override
  _EmotionCalendarPageState createState() => _EmotionCalendarPageState();
}

class _EmotionCalendarPageState extends State<EmotionCalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  String _selectedEmotion = '';
  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendario de Emociones'),
        backgroundColor: Colors.blue, // Usando Colors.blue
        actions: [
          IconButton(
            icon: Icon(Icons.library_books),
            onPressed: () {
              // Redirigir a la misma página (biblioteca se refiere al calendario en este caso)
              Navigator.pushNamed(context, '/instructions');
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Lógica de logout
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF001F3F), // Azul oscuro
              Color(0xFF003366), // Azul medio
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                // Contenedor para el calendario a la izquierda
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TableCalendar(
                          focusedDay: DateTime.now(),
                          firstDay: DateTime(2000),
                          lastDay: DateTime(2100),
                          calendarFormat: _calendarFormat,
                          onFormatChanged: (format) {
                            setState(() {
                              _calendarFormat = format;
                            });
                          },
                          headerStyle: HeaderStyle(
                            formatButtonVisible: true,
                            formatButtonShowsNext: false,
                            formatButtonDecoration: BoxDecoration(
                              color: Colors
                                  .blue, // Usando Colors.blue para el botón
                              borderRadius: BorderRadius.circular(8),
                            ),
                            titleCentered: true,
                            titleTextStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors
                                  .black, // Usando Colors.black para el texto
                            ),
                          ),
                          calendarStyle: CalendarStyle(
                            outsideDaysVisible: false,
                            selectedDecoration: BoxDecoration(
                              color: Color.fromARGB(
                                  255, 213, 186, 152), // Beige seleccionado
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      // Mostrar las notas guardadas debajo del calendario
                      Expanded(
                        child: FutureBuilder<List<Map<String, dynamic>>>(
                          future: UserManager.getEmotions(widget.userEmail),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error al cargar las emociones',
                                      style: TextStyle(color: Colors.white)));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Center(
                                  child: Text('No hay emociones guardadas',
                                      style: TextStyle(color: Colors.white)));
                            } else {
                              return ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  final emotion = snapshot.data![index];
                                  return ListTile(
                                    title: Text('${emotion['emotion']}',
                                        style: TextStyle(
                                            color: Colors
                                                .white)), // Color de letra blanco
                                    subtitle: Text(emotion['note'],
                                        style: TextStyle(
                                            color: Colors
                                                .white)), // Color de letra blanco
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                // Contenedor para las notas y las emociones en la derecha
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      // Contenedor de las notas
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Notas',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors
                                    .black, // Color de texto para el título
                              ),
                            ),
                            TextField(
                              controller: _noteController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Escribe una nota',
                                hintStyle: TextStyle(
                                    color:
                                        Colors.black54), // Color para el hint
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      // Contenedor de las emociones
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Emociones',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors
                                    .black, // Color de texto para el título
                              ),
                            ),
                            _emotionButton('😊', 'Feliz'),
                            _emotionButton('😐', 'Neutral'),
                            _emotionButton('😔', 'Decaído'),
                            _emotionButton('😢', 'Triste'),
                            _emotionButton('😠', 'Enojado'),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      // Botón de Guardar emociones
                      ElevatedButton(
                        onPressed: () async {
                          await UserManager.saveEmotion(
                            widget.userEmail,
                            _selectedEmotion,
                            _noteController.text,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Emoción guardada')),
                          );
                          _noteController.clear();
                          setState(() {});
                        },
                        child: Text('Guardar emociones'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // Usar Colors.blue
                          padding: EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
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
    );
  }

  // Botón de emoción con selección activa
  Widget _emotionButton(String emoji, String emotion) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedEmotion = emotion;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _selectedEmotion == emotion
              ? Color.fromARGB(255, 213, 186, 152) // Beige seleccionado
              : Colors.grey[300], // Color predeterminado para no seleccionado
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.symmetric(vertical: 10),
        ),
        child: Row(
          children: [
            Text(emoji, style: TextStyle(fontSize: 24)),
            SizedBox(width: 8),
            Text(emotion,
                style: TextStyle(color: Colors.white)), // Color de letra blanco
          ],
        ),
      ),
    );
  }
}
