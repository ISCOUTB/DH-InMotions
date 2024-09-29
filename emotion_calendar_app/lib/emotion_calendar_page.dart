import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              Navigator.pushNamed(context, '/instructions');
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          TableCalendar(
            focusedDay: DateTime.now(),
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Emociones',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _emotionButton('Feliz'),
              _emotionButton('Neutral'),
              _emotionButton('Decaído'),
              _emotionButton('Triste'),
              _emotionButton('Enojado'),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _noteController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Escribe una nota',
              ),
              maxLines: 3,
            ),
          ),
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
            child: Text('Guardar'),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: UserManager.getEmotions(widget.userEmail),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error al cargar las emociones'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No hay emociones guardadas'));
                } else {
                  return ListView(
                    children: snapshot.data!.map((emotion) {
                      String dateTime = DateFormat('yyyy-MM-dd – kk:mm')
                          .format(DateTime.parse(emotion['date']));
                      return ListTile(
                        title: Text('[$dateTime] ${emotion['emotion']}'),
                        subtitle: Text(emotion['note']),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _emotionButton(String emotion) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedEmotion = emotion;
        });
      },
      child: Text(emotion),
    );
  }
}
