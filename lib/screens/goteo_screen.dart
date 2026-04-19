import 'package:flutter/material.dart';

class CalculadoraGoteo extends StatefulWidget {
  const CalculadoraGoteo({super.key});

  @override
  State<CalculadoraGoteo> createState() => _CalculadoraGoteoState();
}

class _CalculadoraGoteoState extends State<CalculadoraGoteo> {
  final TextEditingController mlController = TextEditingController();
  final TextEditingController tiempoController = TextEditingController();

  int factor = 20;
  double resultado = 0;

  void calcular() {
    double ml = double.tryParse(mlController.text) ?? 0;
    double tiempo = double.tryParse(tiempoController.text) ?? 1;

    setState(() {
      resultado = (ml * factor) / tiempo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Goteo IV")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
               controller: mlController,
               keyboardType: TextInputType.number,
               decoration: const InputDecoration(labelText: "Volumen (ml)"),
            ),
            TextField(
               controller: tiempoController,
               keyboardType: TextInputType.number,
               decoration: const InputDecoration(labelText: "Tiempo (min)"),
            ),
            const SizedBox(height: 10),
            DropdownButton<int>(
               value: factor,
               items: const [
                 DropdownMenuItem(value: 20, child: Text("Macrogotero (20)")),
                 DropdownMenuItem(value: 60, child: Text("Microgotero (60)")),
               ],
               onChanged: (value) {
                 setState(() {
                   factor = value!;
                 });
               },
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: calcular, child: const Text("Calcular")),
            const SizedBox(height: 20),
            Text(
               "Resultado: ${resultado.toStringAsFixed(2)} gotas/min",
               style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
