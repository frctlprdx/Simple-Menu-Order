import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_search/dropdown_search.dart';
import 'detail_screen.dart'; // Pastikan Anda memiliki file ini

class ModelKota {
  String? cityId;
  String? type;
  String? cityName;

  ModelKota({this.cityId, this.type, this.cityName});

  ModelKota.fromJson(Map<String, dynamic> json) {
    cityId = json['city_id'];
    type = json['type'];
    cityName = json['city_name'];
  }

  @override
  String toString() => cityName as String;

  static List<ModelKota> fromJsonList(List list) {
    if (list.isEmpty) return [];
    return list.map((item) => ModelKota.fromJson(item)).toList();
  }
}

class OngkirScreen extends StatefulWidget {
  final int totalPrice;

  const OngkirScreen({Key? key, required this.totalPrice}) : super(key: key);

  @override
  State<OngkirScreen> createState() => _OngkirScreenState();
}

class _OngkirScreenState extends State<OngkirScreen> {
  // API Key untuk RajaOngkir (Ganti dengan API Key Anda)
  final String _apiKey = "1b44549632a971b00279fbd1cf7f1ea5";

  String? _selectedKotaAsal;
  String? _selectedKotaTujuan;
  String? _selectedKurir;
  String? _beratPaket;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cek Ongkos Kirim"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown Kota Asal
            DropdownSearch<ModelKota>(
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Kota Asal",
                  hintText: "Pilih Kota Asal",
                ),
              ),
              popupProps: const PopupProps.menu(
                showSearchBox: true,
              ),
              onChanged: (value) => _selectedKotaAsal = value?.cityId,
              asyncItems: (text) async {
                return await _fetchKota();
              },
              itemAsString: (item) => "${item.type} ${item.cityName}",
            ),
            const SizedBox(height: 20),
            // Dropdown Kota Tujuan
            DropdownSearch<ModelKota>(
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Kota Tujuan",
                  hintText: "Pilih Kota Tujuan",
                ),
              ),
              popupProps: const PopupProps.menu(
                showSearchBox: true,
              ),
              onChanged: (value) => _selectedKotaTujuan = value?.cityId,
              asyncItems: (text) async {
                return await _fetchKota();
              },
              itemAsString: (item) => "${item.type} ${item.cityName}",
            ),
            const SizedBox(height: 20),
            // Input Berat Paket
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Berat Paket (gram)",
                hintText: "Input Berat Paket",
              ),
              onChanged: (value) => _beratPaket = value,
            ),
            const SizedBox(height: 20),
            // Dropdown Ekspedisi
            DropdownSearch<String>(
              items: const ["JNE", "TIKI", "POS"],
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Kurir",
                  hintText: "Pilih Kurir",
                ),
              ),
              popupProps: const PopupProps.menu(),
              onChanged: (value) => _selectedKurir = value?.toLowerCase(),
            ),
            const SizedBox(height: 20),
            // Tombol Cek Ongkir
            ElevatedButton(
              onPressed: _cekOngkir,
              child: const Text("Cek Ongkir"),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<ModelKota>> _fetchKota() async {
    try {
      final response = await http.get(Uri.parse(
          "https://api.rajaongkir.com/starter/city?key=$_apiKey"));

      if (response.statusCode == 200) {
        List allKota = jsonDecode(response.body)['rajaongkir']['results'];
        return ModelKota.fromJsonList(allKota);
      } else {
        throw Exception("Gagal memuat data kota.");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
      return [];
    }
  }

  Future<void> _cekOngkir() async {
    if (_selectedKotaAsal == null ||
        _selectedKotaTujuan == null ||
        _beratPaket == null ||
        _selectedKurir == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua field harus diisi!")),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("https://api.rajaongkir.com/starter/cost"),
        headers: {"key": _apiKey, "content-type": "application/json"},
        body: jsonEncode({
          "origin": _selectedKotaAsal,
          "destination": _selectedKotaTujuan,
          "weight": int.parse(_beratPaket!),
          "courier": _selectedKurir,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['rajaongkir']['results'][0];
        final costDetails = data['costs'][0]['cost'][0];
        final int ongkirPrice = costDetails['value'];

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(
              kota_asal: _selectedKotaAsal,
              kota_tujuan: _selectedKotaTujuan,
              berat: _beratPaket,
              kurir: _selectedKurir,
              totalHarga: widget.totalPrice,
              hargaongkir: ongkirPrice,
            ),
          ),
        );
      } else {
        throw Exception("Gagal mendapatkan data ongkir.");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }
}
