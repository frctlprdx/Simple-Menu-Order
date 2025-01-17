import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatefulWidget {
  final String? kota_asal;
  final String? kota_tujuan;
  final String? berat;
  final String? kurir;
  final int totalHarga;
  final int hargaongkir;

  const DetailPage({
    super.key,
    this.kota_asal,
    this.kota_tujuan,
    this.berat,
    this.kurir,
    required this.totalHarga,
    required this.hargaongkir,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List listData = [];
  var strKey = "1b44549632a971b00279fbd1cf7f1ea5";
  late int totalHargaDenganOngkir;
  late int ongkirTerpilih;

  @override
  void initState() {
    super.initState();
    ongkirTerpilih = widget.hargaongkir;
    totalHargaDenganOngkir = widget.totalHarga + ongkirTerpilih;
    getData();
  }

  Future<void> getData() async {
    try {
      final response = await http.post(
        Uri.parse("https://api.rajaongkir.com/starter/cost"),
        body: {
          "key": strKey,
          "origin": widget.kota_asal,
          "destination": widget.kota_tujuan,
          "weight": widget.berat,
          "courier": widget.kurir,
        },
      );

      var data = jsonDecode(response.body);
      setState(() {
        listData = data['rajaongkir']['results'][0]['costs'];
      });
    } catch (e) {
      print(e);
    }
  }

  void pilihOngkir(int ongkir) {
    setState(() {
      ongkirTerpilih = ongkir;
      totalHargaDenganOngkir = widget.totalHarga + ongkirTerpilih;
    });
  }

  Future<void> _submitOrder(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("User is not logged in.");
      }

      final userId = user.uid;

      final body = {
        'amount': totalHargaDenganOngkir,
        'user_id': userId,
      };

      final response = await http.post(
        Uri.parse('https://radiant-commitment-production.up.railway.app/api/midtrans'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        var redirectUrl = data['redirectUrl'];

        if (redirectUrl != null && redirectUrl.isNotEmpty) {
          // Memastikan URL tidak duplikat protokol (https://https://)
          if (redirectUrl.startsWith('https://https://')) {
            redirectUrl = redirectUrl.replaceFirst('https://', '');
          } else if (redirectUrl.startsWith('http://http://')) {
            redirectUrl = redirectUrl.replaceFirst('http://', '');
          }

          try {
            final Uri uri = Uri.parse(redirectUrl);

            // Memeriksa apakah URL dapat diluncurkan
              if (await canLaunchUrl(uri)) {
              await launchUrl(
                uri,
                mode: LaunchMode.inAppWebView, // Membuka di dalam WebView aplikasi
              );
            } else {
              throw Exception('Could not launch URL: $redirectUrl');
            }
          } catch (e) {
            // Menangani kesalahan parsing atau URL yang invalid
            throw Exception('Invalid URL or error launching URL: $redirectUrl. Error: $e');
          }
        } else {
          throw Exception('Invalid redirect URL: $redirectUrl');
        }
      } else {
        final error = json.decode(response.body)['message'];
        throw Exception(error ?? 'Failed to process order.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Ongkos Kirim ${widget.kurir?.toUpperCase()}"),
      ),
      body: Column(
        children: [
          Expanded(
            child: listData.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: listData.length,
              itemBuilder: (_, index) {
                return Card(
                  margin: const EdgeInsets.all(10),
                  clipBehavior: Clip.antiAlias,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.white,
                  child: ListTile(
                    title: Text("${listData[index]['service']}"),
                    subtitle: Text("${listData[index]['description']}"),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Rp ${listData[index]['cost'][0]['value']}",
                          style: const TextStyle(
                              fontSize: 20, color: Colors.red),
                        ),
                        const SizedBox(height: 3),
                        Text("${listData[index]['cost'][0]['etd']} Days"),
                      ],
                    ),
                    onTap: () {
                      pilihOngkir(listData[index]['cost'][0]['value']);
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  "Total Harga: Rp ${widget.totalHarga}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  "Ongkir Terpilih: Rp $ongkirTerpilih",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  "Total Harga dengan Ongkir: Rp $totalHargaDenganOngkir",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _submitOrder(context),
                  child: const Text("Bayar"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
