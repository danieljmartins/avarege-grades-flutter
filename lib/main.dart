import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notas do Aluno',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculadoraMedia(),
    );
  }
}

class CalculadoraMedia extends StatefulWidget {
  @override
  _CalculadoraMediaState createState() => _CalculadoraMediaState();
}

class _CalculadoraMediaState extends State {
  final TextEditingController _controllerDisciplina = TextEditingController();
  final TextEditingController _controllerNota = TextEditingController();
  List<Map<String, dynamic>> _disciplinas = [];

  void _adicionarDisciplina() {
    setState(() {
      if (_controllerDisciplina.text.isNotEmpty &&
          _controllerNota.text.isNotEmpty) {
        _disciplinas.add({
          'disciplina': _controllerDisciplina.text,
          'nota': double.parse(_controllerNota.text),
        });
        _controllerDisciplina.clear();
        _controllerNota.clear();
      }
    });
  }

  double _calcularMedia() {
    if (_disciplinas.isEmpty) return 0;

    double somaNotas = 0;
    _disciplinas.forEach((disciplina) {
      somaNotas += disciplina['nota'];
    });

    return somaNotas / _disciplinas.length;
  }

  String _verificarSituacao(double media) {
    return media >= 6.0 ? 'Aprovado' : 'Reprovado';
  }

  Color _getColorBasedOnStatus(String status) {
    return status == 'Aprovado' ? Colors.blue : Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notas do Aluno'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controllerDisciplina,
              decoration: InputDecoration(labelText: 'Disciplina'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _controllerNota,
              decoration: InputDecoration(labelText: 'Nota'),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$'))], // Impede que o usuário digite letras
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _adicionarDisciplina,
              child: Text('Adicionar Avaliação'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, 
                backgroundColor: Colors.purple,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Média: ${_calcularMedia().toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Situação: ',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '${_verificarSituacao(_calcularMedia())}',
              style: TextStyle(
                fontSize: 18,
                color: _getColorBasedOnStatus(_verificarSituacao(_calcularMedia())),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _disciplinas.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_disciplinas[index]['disciplina']),
                    subtitle: Text('Nota: ${_disciplinas[index]['nota']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
