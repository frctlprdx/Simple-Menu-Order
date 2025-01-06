import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class History {
  final String userId;
  final double total;
  final String tanggal;
  final String statusPembayaran;

  History({
    required this.userId,
    required this.total,
    required this.tanggal,
    required this.statusPembayaran,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      userId: json['user_id'],
      total: double.tryParse(json['total'].toString()) ?? 0.0,
      tanggal: json['tanggal'],
      statusPembayaran: json['status_pembayaran'],
    );
  }
}

class SellScreen extends StatefulWidget {
  const SellScreen({super.key});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  List<History> _histories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHistories();
  }

  Future<void> _fetchHistories() async {
    final url = Uri.parse('https://lively-forgiveness-production.up.railway.app/api/histories');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _histories = data.map((json) => History.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load histories');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching histories: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sell History'),
        backgroundColor: Colors.teal,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _histories.isEmpty
          ? const Center(child: Text('No sell histories found.'))
          : SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('User ID')),
            DataColumn(label: Text('Total')),
            DataColumn(label: Text('Tanggal')),
            DataColumn(label: Text('Status Pembayaran')),
          ],
          rows: _histories
              .map(
                (history) => DataRow(
              cells: [
                DataCell(Text(history.userId)),
                DataCell(Text(history.total.toStringAsFixed(2))),
                DataCell(Text(history.tanggal)),
                DataCell(Text(history.statusPembayaran)),
              ],
            ),
          )
              .toList(),
        ),
      ),
    );
  }
}
