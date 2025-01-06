import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
    required this.totalHarga, required this.hargaongkir
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List listData = [];
  var strKey = "1b44549632a971b00279fbd1cf7f1ea5";
  late int totalHargaDenganOngkir; // Awalnya hanya totalHarga
  late int ongkirTerpilih; // Ongkir yang dipilih

  @override
  void initState() {
    super.initState();
    ongkirTerpilih = widget.hargaongkir;
    totalHargaDenganOngkir = widget.totalHarga + ongkirTerpilih; // Set awal ke totalHarga
    getData();
  }

  Future getData() async {
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
      ongkirTerpilih = ongkir; // Simpan ongkir yang dipilih
      totalHargaDenganOngkir = widget.totalHarga + ongkirTerpilih;
    });
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
                  onPressed: () {
                    // Logika pembayaran atau navigasi ke halaman pembayaran
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Membayar Rp $totalHargaDenganOngkir"),
                    ));
                  },
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
