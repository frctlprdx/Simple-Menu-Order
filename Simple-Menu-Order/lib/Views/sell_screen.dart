import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class History {
  final String transactionId;
  final String userId;
  final double total;
  final String tanggal;

  History({
    required this.transactionId,
    required this.userId,
    required this.total,
    required this.tanggal,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      transactionId: json['transaction_id'],
      userId: json['user_id'],
      total: double.tryParse(json['total'].toString()) ?? 0.0,
      tanggal: json['tanggal'],
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
    final url = Uri.parse('https://radiant-commitment-production.up.railway.app/api/midtrans');
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

  Future<void> _generatePDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Sell Histories Report',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: {
                0: const pw.FlexColumnWidth(2),
                1: const pw.FlexColumnWidth(2),
                2: const pw.FlexColumnWidth(1),
                3: const pw.FlexColumnWidth(2),
              },
              children: [
                // Table Header
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('Transaction ID',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('User ID',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('Total',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('Tanggal',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                  ],
                ),
                // Table Rows
                ..._histories.map(
                      (history) => pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(history.transactionId),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(history.userId),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(history.total.toStringAsFixed(2)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(history.tanggal),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    // Save or Preview PDF
    await Printing.sharePdf(bytes: await pdf.save(), filename: 'SellHistoriesReport.pdf');
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
          : Column(
        children: [
          Expanded(
            child: _histories.isEmpty
                ? const Center(child: Text('No sell histories found.'))
                : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateProperty.resolveWith(
                        (states) => Colors.teal.shade100,
                  ),
                  dataRowColor: MaterialStateProperty.resolveWith(
                        (states) => states.contains(MaterialState.selected)
                        ? Colors.teal.shade50
                        : Colors.grey.shade50,
                  ),
                  columns: const [
                    DataColumn(
                      label: Text(
                        'Transaction ID',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'User ID',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Total',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Tanggal',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  rows: _histories
                      .map(
                        (history) => DataRow(
                      cells: [
                        DataCell(Text(history.transactionId)),
                        DataCell(Text(history.userId)),
                        DataCell(Text(history.total.toStringAsFixed(2))),
                        DataCell(Text(history.tanggal)),
                      ],
                    ),
                  )
                      .toList(),
                ),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: _generatePDF,
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text('Export to PDF'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
          ),
        ],
      ),
    );
  }
}
