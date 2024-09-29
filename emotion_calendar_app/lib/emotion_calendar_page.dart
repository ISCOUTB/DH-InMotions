import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class EmotionCalendarPage extends StatefulWidget {
  @override
  _EmotionCalendarPageState createState() => _EmotionCalendarPageState();
}

class _EmotionCalendarPageState extends State<EmotionCalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  String _selectedEmotion = '';
  final TextEditingController _noteController = TextEditingController();

  Future<void> _saveEmotion(String emotion, String note) async {
    final prefs = await SharedPreferences.getInstance();
    String dateTime = DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());
    String emotionEntry = '[$dateTime] $emotion: $note';
    List<String> emotions = prefs.getStringList('emotions') ?? [];
    emotions.add(emotionEntry);
    await prefs.setStringList('emotions', emotions);
  }

  Future<List<String>> _readEmotions() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('emotions') ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendario de Emociones'),
        actions: [
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
            onPressed: () {
              _saveEmotion(_selectedEmotion, _noteController.text);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Emoción guardada')),
              );
              _noteController.clear();
            },
            child: Text('Guardar'),
          ),
          Expanded(
            child: FutureBuilder<List<String>>(
              future: _readEmotions(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error al cargar las emociones'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No hay emociones guardadas'));
                } else {
                  return ListView(
                    children: snapshot.data!
                        .map((line) => ListTile(title: Text(line)))
                        .toList(),
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
