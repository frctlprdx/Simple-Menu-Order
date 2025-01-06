import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Views/Update_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_1/Views/order_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../AuthenticationViews/login_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<Map<String, dynamic>> _cart = [];

  Future<List<Map<String, dynamic>>> _fetchMenuItems() async {
    final url = Uri.parse('https://lively-forgiveness-production.up.railway.app/api/products');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => {
        'productId': item['product_id'],
        'productName': item['product_name'],
        'descr': item['descr'],
        'img': item['img'],
        'sellPrice': item['sellprice'],
      }).toList();
    } else {
      throw Exception('Failed to load menu');
    }
  }

  void _addToCart(Map<String, dynamic> item) {
    setState(() {
      final existingIndex =
      _cart.indexWhere((cartItem) => cartItem['productId'] == item['productId']);
      if (existingIndex != -1) {
        _cart[existingIndex]['quantity'] += 1;
      } else {
        _cart.add({...item, 'quantity': 1});
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item['productName']} added to cart')),
    );
  }

  int get _totalPrice {
    return _cart.fold(0,
            (sum, item) => sum + (item['sellPrice'] as int) * (item['quantity'] as int));
  }

  void _checkout() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderScreen(cartItems: _cart, totalPrice: _totalPrice),
      ),
    );
  }

  Future<void> _openMap() async {
    const url =
        'https://www.google.com/maps/place/Universitas+Dian+Nuswantoro/@-6.9826794,110.4090606,17z/data=!3m1!4b1!4m6!3m5!1s0x2e708b4ec52229d7:0xc791d6abc9236c7!8m2!3d-6.9826794!4d110.4090606!16s%2Fg%2F121kq4bb?entry=ttu&g_ep=EgoyMDI0MTIxMS4wIKXMDSoASAFQAw%3D%3D';
    if (await canLaunchUrl(url as Uri)) {
      await launchUrl(url as Uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      throw 'Could not launch $telUri';
    }
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
    final Uri whatsappUri = Uri.parse("https://wa.me/$phoneNumber");
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $whatsappUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        backgroundColor: const Color(0xFF008080),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF008080),
              ),
              child: Text(
                'Menu Options',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Call Center'),
              onTap: () {
                Navigator.pop(context);
                _makePhoneCall('+6281326926776'); // Memulai panggilan ke nomor
              },
            ),
            ListTile(
              leading: const Icon(Icons.sms),
              title: const Text('SMS Center'),
              onTap: () {
                Navigator.pop(context);
                _openWhatsApp('+6281326926776'); // Buka WhatsApp dengan nomor ini
              },
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Lokasi/Maps'),
              onTap: () {
                Navigator.pop(context);
                _openMap(); // Membuka URL Maps
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Update User & Password'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const UpdateScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                try {
                  await FirebaseAuth.instance.signOut(); // Logout dari Firebase
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(), // Arahkan ke LoginScreen
                    ),
                  );
                } catch (e) {
                  print('Error during logout: $e'); // Menangani error jika logout gagal
                }
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchMenuItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No menu items available.'));
          }

          final menuItems = snapshot.data!;
          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: menuItems.length,
                  itemBuilder: (context, index) {
                    final item = menuItems[index];
                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(item['productName']),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Price: ${item['sellPrice']} IDR'),
                                Text(item['descr']),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Close'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _addToCart(item);
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF008080),
                                ),
                                child: const Text('Add'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            item['img'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (_cart.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: _checkout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF008080),
                    ),
                    child: Text('Checkout (Total: ${_totalPrice} IDR)'),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
