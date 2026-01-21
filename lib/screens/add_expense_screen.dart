import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/expense.dart';
import '../providers/expense_provider.dart';
import '../services/notification_service.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();

  DateTime? _selectedDate;
  String? _imagePath;
  String _category = 'Food';

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) setState(() => _imagePath = image.path);
  }

  void _saveExpense() {
    if (!_formKey.currentState!.validate() ||
        _selectedDate == null ||
        _imagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final expense = Expense(
      id: DateTime.now().toString(),
      title: _titleCtrl.text.trim(),
      amount: double.parse(_amountCtrl.text),
      date: _selectedDate!,
      category: _category,
      imagePath: _imagePath!,
    );

    Provider.of<ExpenseProvider>(context, listen: false)
        .addExpense(expense);

    NotificationService.showSavedNotification();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter title' : null,
              ),
              TextFormField(
                controller: _amountCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount'),
                validator: (v) =>
                    v == null || double.tryParse(v) == null
                        ? 'Enter valid amount'
                        : null,
              ),
              DropdownButtonFormField(
                value: _category,
                items: const [
                  DropdownMenuItem(value: 'Food', child: Text('Food')),
                  DropdownMenuItem(value: 'Transport', child: Text('Transport')),
                  DropdownMenuItem(value: 'Bills', child: Text('Bills')),
                ],
                onChanged: (v) => setState(() => _category = v!),
              ),
              TextButton(
                onPressed: _pickDate,
                child: Text(
                  _selectedDate == null
                      ? 'Pick date'
                      : DateFormat.yMMMd().format(_selectedDate!),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Take Photo'),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _saveExpense,
                child: const Text('Save Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
