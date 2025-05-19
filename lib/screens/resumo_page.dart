import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/transaction_model.dart'; // Importando seu modelo TransactionModel

class ResumoPage extends StatefulWidget {
  @override
  _ResumoPageState createState() => _ResumoPageState();
}

class _ResumoPageState extends State<ResumoPage> {
  late Box<TransactionModel> transactionBox;
  List<PieChartSectionData> pieChartSections = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Função para carregar os dados da box
  Future<void> _loadData() async {
    transactionBox = await Hive.openBox<TransactionModel>('transactions');
    final transactions = transactionBox.values.toList();

    double totalExpense = 0.0;
    double totalIncome = 0.0;

    for (var transaction in transactions) {
      if (transaction.isExpense) {
        totalExpense += transaction.amount;
      } else {
        totalIncome += transaction.amount;
      }
    }

    setState(() {
      pieChartSections = [
        PieChartSectionData(
          value: totalExpense,
          title: 'Despesas: \$${totalExpense.toStringAsFixed(2)}',
          color: Colors.red,
          radius: 60,
        ),
        PieChartSectionData(
          value: totalIncome,
          title: 'Ganhos: \$${totalIncome.toStringAsFixed(2)}',
          color: Colors.green,
          radius: 60,
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Resumo Financeiro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: pieChartSections,
                  borderData: FlBorderData(show: false),
                  centerSpaceRadius: 50,
                  sectionsSpace: 5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
