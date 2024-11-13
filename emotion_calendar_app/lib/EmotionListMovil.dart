import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'UserManagerMovil.dart';

class EmotionListMovil extends StatefulWidget {
  final String userEmail;

  EmotionListMovil({required this.userEmail});

  @override
  _EmotionListMovilState createState() => _EmotionListMovilState();
}

class _EmotionListMovilState extends State<EmotionListMovil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Emociones'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future:
            UserManagerMovil.getEmotions(widget.userEmail), // Lee las emociones
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error al cargar las emociones"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No hay emociones guardadas."));
          } else {
            // Si las emociones están disponibles
            final emotions = snapshot.data!;
            return ListView.builder(
              itemCount: emotions.length,
              itemBuilder: (context, index) {
                final emotion = emotions[index];
                return ListTile(
                  title: Text(emotion['emotion']),
                  subtitle: Text(emotion['note'] ?? 'Sin notas'),
                  trailing: Text(
                    DateFormat('yyyy-MM-dd')
                        .format(DateTime.parse(emotion['date'])),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
