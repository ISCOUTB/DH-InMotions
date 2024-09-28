import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'api_service.dart';

class EmotionCalendarPage extends StatefulWidget {
  @override
  _EmotionCalendarPageState createState() => _EmotionCalendarPageState();
}

class _EmotionCalendarPageState extends State<EmotionCalendarPage> {
  final ApiService apiService = ApiService();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, String> _emotions = {};

  @override
  void initState() {
    super.initState();
    _loadEmotions();
  }

  void _loadEmotions() async {
    try {
      final result = await apiService.getEmotions(_focusedDay);
      setState(() {
        _emotions = Map.fromEntries(
          (result['emotions'] as List).map((e) => MapEntry(
                DateTime.parse(e['date']),
                e['emotion'],
              )),
        );
      });
    } catch (e) {
      print('Error loading emotions: $e');
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
    _showEmotionDialog(selectedDay);
  }

  void _showEmotionDialog(DateTime date) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('¿Cómo te sientes hoy?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => _saveEmotion(date, 'Feliz'),
              child: Text('Feliz 😊'),
            ),
            ElevatedButton(
              onPressed: () => _saveEmotion(date, 'Triste'),
              child: Text('Triste 😢'),
            ),
            ElevatedButton(
              onPressed: () => _saveEmotion(date, 'Enojado'),
              child: Text('Enojado 😠'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveEmotion(DateTime date, String emotion) async {
    try {
      await apiService.saveEmotion(date, emotion);
      setState(() {
        _emotions[date] = emotion;
      });
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar la emoción: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calendario de Emociones')),
      body: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: _onDaySelected,
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
          _loadEmotions();
        },
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            final emotion = _emotions[date];
            if (emotion != null) {
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getEmotionColor(emotion),
                ),
                width: 5,
                height: 5,
              );
            }
            return null;
          },
        ),
      ),
    );
  }

  Color _getEmotionColor(String emotion) {
    switch (emotion) {
      case 'Feliz':
        return Colors.green;
      case 'Triste':
        return Colors.blue;
      case 'Enojado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
