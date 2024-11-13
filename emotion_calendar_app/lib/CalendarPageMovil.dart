import 'package:flutter/material.dart';
import 'UserManagerMovil.dart';
import 'package:intl/intl.dart';

class EmotionCalendarMovil extends StatefulWidget {
  final String userEmail;

  EmotionCalendarMovil({required this.userEmail});

  @override
  _EmotionCalendarMovilState createState() => _EmotionCalendarMovilState();
}

class _EmotionCalendarMovilState extends State<EmotionCalendarMovil> {
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _emotionController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  Future<void> _addEmotion() async {
    String emotion = _emotionController.text;
    String note = _noteController.text;

    if (emotion.isNotEmpty) {
      // Agregar emoción usando UserManagerMovil
      await UserManagerMovil.addEmotion(
        widget.userEmail,
        _selectedDate,
        emotion,
        note,
      );
      _emotionController.clear();
      _noteController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Emoción añadida con éxito")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, introduce una emoción")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendario de Emociones"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text(
                  "Fecha seleccionada: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}"),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    _selectedDate = pickedDate;
                  });
                }
              },
            ),
            TextField(
              controller: _emotionController,
              decoration: InputDecoration(labelText: "Emoción"),
            ),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(labelText: "Nota (opcional)"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addEmotion,
              child: Text("Agregar Emoción"),
            ),
          ],
        ),
      ),
    );
  }
}
