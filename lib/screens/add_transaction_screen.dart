import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:controle_financeiro/models/transaction_model.dart';
import 'package:intl/intl.dart';

class AddTransactionScreen extends StatefulWidget {
  final TransactionModel? transaction;
  final int? index;

  const AddTransactionScreen({Key? key, this.transaction, this.index}) : super(key: key);

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isExpense = false;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _saveTransaction() {
    final title = _titleController.text;
    final amount = double.tryParse(_amountController.text);
    if (title.isEmpty || amount == null || amount <= 0) {
      return; // Validação simples
    }

    final transaction = TransactionModel(
      title: title,
      amount: amount,
      date: _selectedDate,
      isExpense: _isExpense,
    );

    // Salva no Hive
    final box = Hive.box<TransactionModel>('transactions');
    box.add(transaction);

    Navigator.of(context).pop(); // Volta para a tela anterior
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Transação'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Nome da Transação'),
            ),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Valor'),
            ),
            Row(
              children: [
                Text('Data: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}'),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ],
            ),
            Row(
              children: [
                Text('Despesa'),
                Checkbox(
                  value: _isExpense,
                  onChanged: (value) {
                    setState(() {
                      _isExpense = value!;
                    });
                  },
                ),
                Text('Receita'),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: _saveTransaction,
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
