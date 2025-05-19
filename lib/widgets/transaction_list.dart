import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:controle_financeiro/models/transaction_model.dart';
import 'package:intl/intl.dart';
import 'package:controle_financeiro/screens/add_transaction_screen.dart';

class TransactionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<TransactionModel>('transactions').listenable(),
      builder: (context, Box<TransactionModel> box, _) {
        if (box.values.isEmpty) {
          return Center(child: Text("Nenhuma transação cadastrada"));
        }
        return ListView.builder(
          itemCount: box.values.length,
          itemBuilder: (context, index) {
            var transaction = box.getAt(index) as TransactionModel;
            return Dismissible(
              key: Key(transaction.key.toString()),
              background: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 20),
                color: Colors.blueAccent,
                child: Icon(Icons.edit, color: Colors.white),
              ),
              secondaryBackground: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 20),
                color: Colors.redAccent,
                child: Icon(Icons.delete, color: Colors.white),
              ),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  // Excluir
                  return await showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text('Confirmar Exclusão'),
                      content: Text('Deseja realmente excluir esta transação?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text('Excluir'),
                        ),
                      ],
                    ),
                  );
                } else if (direction == DismissDirection.startToEnd) {
                  // Editar
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AddTransactionScreen(transaction: transaction, index: index),
                    ),
                  );
                  return false; // não remove ao editar
                }
                return false;
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: transaction.isExpense ? Colors.red.shade50 : Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 6,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: transaction.isExpense ? Colors.red : Colors.green,
                      child: Icon(
                        transaction.isExpense ? Icons.arrow_downward : Icons.arrow_upward,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(transaction.title, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(DateFormat('dd MMM yyyy').format(transaction.date)),
                    trailing: Text(
                      '${transaction.isExpense ? '-' : '+'} \$${transaction.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: transaction.isExpense ? Colors.red : Colors.green,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
