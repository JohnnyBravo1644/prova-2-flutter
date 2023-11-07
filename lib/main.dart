import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TelaAcoes extends StatefulWidget {
  @override
  _TelaAcoesState createState() => _TelaAcoesState();
}

class _TelaAcoesState extends State<TelaAcoes> {
  Map<String, dynamic> data = {};

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://api.hgbrasil.com/finance?key=ec9c864c&format=json-cors'));
    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
      });
    } else {
      throw Exception('Falha ao carregar dados da API');
    }
  }

  Widget buildStockInfo(String label, String stockCode, String property) {
    return Column(
      children: <Widget>[
        Text(
          '$label:',
          style: TextStyle(fontSize: 12),
        ),
        Text(
          '${data['results']['stocks'][stockCode][property]}',
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget buildVariation(String stockCode) {
    double variation = data['results']['stocks'][stockCode]['variation'];

    Color boxColor = variation < 0 ? Colors.red : Colors.blue;
    Color textColor = Colors.white;

    return Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: Border.all(color: boxColor, width: 1.0),
        color: boxColor,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        '${variation.toStringAsFixed(4)}',
        style: TextStyle(fontSize: 12, color: textColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('Ações'),
            backgroundColor: Colors.green,
          ),
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Ações'),
          backgroundColor: Colors.green,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              Text(
                'AÇÕES',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 200,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: GridView.count(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 6,
                  children: [
                    buildStockInfo('IBOVESPA', 'IBOVESPA', 'points'),
                    buildVariation('IBOVESPA'),
                    buildStockInfo('IFIX', 'IFIX', 'points'),
                    buildVariation('IFIX'),
                    buildStockInfo('NASDAQ', 'NASDAQ', 'points'),
                    buildVariation('NASDAQ'),
                    buildStockInfo('DOWJONES', 'DOWJONES', 'points'),
                    buildVariation('DOWJONES'),
                    buildStockInfo('CAC', 'CAC', 'points'),
                    buildVariation('CAC'),
                    buildStockInfo('NIKKEI', 'NIKKEI', 'points'),
                    buildVariation('NIKKEI'),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "moedas");
                },
                style: ElevatedButton.styleFrom(primary: Colors.green),
                child: Text('Ir para Moedas'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "bitcoin");
                },
                style: ElevatedButton.styleFrom(primary: Colors.green),
                child: Text('Ir para Bitcoin'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
