import 'package:flutter/material.dart';

class InstructionsPage extends StatelessWidget {
  final List<Instruction> instructions = [
    Instruction(
      title: '1. Respiración diafragmática',
      steps: [
        '1.1. Siéntate o acuéstate cómodamente',
        '1.2. Coloca una mano en el pecho y otra en el abdomen',
        '1.3. Inhala lentamente por la nariz, expandiendo el abdomen',
        '1.4. Exhala lentamente por la boca, contrayendo el abdomen',
        '1.5. Repite 5-10 veces',
      ],
    ),
    Instruction(
      title: '2. Escaneo corporal',
      steps: [
        '2.1. Acuéstate en una posición cómoda',
        '2.2. Cierra los ojos y respira profundamente',
        '2.3. Enfócate en cada parte de tu cuerpo, empezando por los pies',
        '2.4. Nota cualquier tensión y libérala conscientemente',
        '2.5. Avanza gradualmente hacia la cabeza',
      ],
    ),
    Instruction(
      title: '3. Técnica 5-4-3-2-1',
      steps: [
        '3.1. Nombra 5 cosas que puedes ver',
        '3.2. Nombra 4 cosas que puedes tocar',
        '3.3. Nombra 3 cosas que puedes oír',
        '3.4. Nombra 2 cosas que puedes oler',
        '3.5. Nombra 1 cosa que puedes saborear',
      ],
    ),
    Instruction(
      title: '4. Meditación de atención plena',
      steps: [
        '4.1. Siéntate en una posición cómoda',
        '4.2. Enfócate en tu respiración',
        '4.3. Observa tus pensamientos sin juzgarlos',
        '4.4. Si te distraes, vuelve gentilmente a tu respiración',
        '4.5. Practica por 5-10 minutos diariamente',
      ],
    ),
    Instruction(
      title: '5. Diario emocional',
      steps: [
        '5.1. Escribe diariamente sobre tus emociones',
        '5.2. Identifica qué las provocó',
        '5.3. Reflexiona sobre cómo reaccionaste',
        '5.4. Piensa en formas alternativas de responder',
        '5.5. Establece metas para manejar mejor tus emociones',
      ],
    ),
    Instruction(
      title: '6. Visualización positiva',
      steps: [
        '6.1. Cierra los ojos y respira profundamente',
        '6.2. Imagina un lugar tranquilo y seguro',
        '6.3. Usa todos tus sentidos para hacerlo más real',
        '6.4. Quédate en ese lugar por 5-10 minutos',
        '6.5. Abre los ojos lentamente',
      ],
    ),
    Instruction(
      title: '7. Ejercicio físico regular',
      steps: [
        '7.1. Elige una actividad que disfrutes (caminar, nadar, bailar)',
        '7.2. Establece un horario regular',
        '7.3. Comienza con sesiones cortas y aumenta gradualmente',
        '7.4. Presta atención a cómo te sientes durante y después',
        '7.5. Usa este tiempo para despejar tu mente',
      ],
    ),
    Instruction(
      title: '8. Técnica de relajación muscular progresiva',
      steps: [
        '8.1. Acuéstate o siéntate cómodamente',
        '8.2. Comienza por los pies, tensando los músculos por 5 segundos',
        '8.3. Relaja los músculos completamente por 10 segundos',
        '8.4. Avanza hacia arriba por todo el cuerpo, grupo muscular por grupo muscular',
        '8.5. Nota la diferencia entre tensión y relajación',
      ],
    ),
    Instruction(
      title: '9. Práctica de gratitud',
      steps: [
        '9.1. Cada noche, escribe 3 cosas por las que estés agradecido',
        '9.2. Reflexiona sobre por qué estás agradecido por cada una',
        '9.3. Incluye cosas pequeñas y grandes',
        '9.4. Trata de no repetir elementos durante al menos una semana',
        '9.5. Observa cómo esto afecta tu estado de ánimo general',
      ],
    ),
    Instruction(
      title: '10. Técnica de reencuadre cognitivo',
      steps: [
        '10.1. Identifica un pensamiento negativo recurrente',
        '10.2. Cuestiona la validez de este pensamiento',
        '10.3. Busca evidencia que lo contradiga',
        '10.4. Crea una interpretación alternativa más positiva o realista',
        '10.5. Practica reemplazar el pensamiento negativo con el nuevo cuando surja',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Técnicas de Bienestar Mental'),
      ),
      body: ListView.builder(
        itemCount: instructions.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(instructions[index].title),
            children: instructions[index]
                .steps
                .map((step) => ListTile(
                      title: Text(step),
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}

class Instruction {
  final String title;
  final List<String> steps;

  Instruction({required this.title, required this.steps});
}
