import 'package:flutter/material.dart';
import 'package:flutter_application_1/checkout_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_application_1/Update_screen.dart';

class Item {
  final int id;
  final String name;
  final String desc;
  final String link;
  final int price;

  Item(this.id, this.name, this.desc, this.link, this.price);
}

List<Item> ourMenu = [
  Item(
      1,
      "Cheeseburger",
      "Makanan klasik Amerika, cheeseburger terdiri dari patty daging sapi yang juicy dengan keju leleh, selada, tomat, acar, dan bawang, disajikan dalam roti burger yang dipanggang.",
      "assets/images/cheeseburger.png",
      60000),
  Item(
      2,
      "Spaghetti Carbonara",
      "Hidangan pasta Italia yang terbuat dari telur, keju, pancetta (atau bacon), dan lada. Saus krim melapisi spaghetti, menciptakan rasa yang kaya dan gurih.",
      "assets/images/carbonara.png",
      75000),
  Item(
      3,
      "Chicken Alfredo",
      "Hidangan pasta krim yang menampilkan mie fettuccine yang dicampur dengan saus Alfredo kaya yang terbuat dari mentega, krim, dan keju Parmesan, ditambah dengan ayam panggang.",
      "assets/images/chicken_alfredo.png",
      70000),
  Item(
      4,
      "Fish and Chips",
      "Hidangan tradisional Inggris yang mencakup ikan yang dilapisi tepung dan digoreng, disajikan dengan kentang goreng potong tebal. Sering disertai dengan saus tartar dan seiris lemon.",
      "assets/images/fish_and_chips.png",
      80000),
  Item(
      5,
      "Caesar Salad",
      "Salad renyah yang terbuat dari selada romaine, croutons, keju Parmesan, dan saus Caesar, sering kali ditambah dengan ayam panggang atau udang untuk menambah protein.",
      "assets/images/caesar_salad.png",
      55000),
  Item(
      6,
      "BBQ Ribs",
      "Ribs daging babi atau sapi yang empuk yang dimasak perlahan dan dilapisi dengan saus barbecue yang asap, sering disajikan dengan coleslaw dan roti jagung di sampingnya.",
      "assets/images/bbq_ribs.png",
      90000),
];

class Blankscreen extends StatefulWidget {
  const Blankscreen({super.key});

  @override
  _BlankscreenState createState() => _BlankscreenState();
}

class _BlankscreenState extends State<Blankscreen> {
  final Map<String, int> _selectedItems = {};
  int _totalPrice = 0;

  void _addItem(String itemName, int itemPrice) {
    setState(() {
      if (_selectedItems.containsKey(itemName)) {
        _selectedItems[itemName] = _selectedItems[itemName]! + 1;
      } else {
        _selectedItems[itemName] = 1;
      }
      _totalPrice += itemPrice;
    });
  }

  void _removeItem(String itemName, int itemPrice) {
    setState(() {
      if (_selectedItems.containsKey(itemName)) {
        _selectedItems[itemName] = _selectedItems[itemName]! - 1;
        if (_selectedItems[itemName] == 0) {
          _selectedItems.remove(itemName);
        }
        _totalPrice -= itemPrice;
      }
    });
  }

  void _checkout() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(
          selectedItems: _selectedItems,
          totalPrice: _totalPrice,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/menu.png',
          fit: BoxFit.contain,
          height: 40,
        ),
        backgroundColor: const Color(0xFF008080),
        iconTheme: const IconThemeData(
          color: Color(0xFFFF6F61),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF008080),
              ),
              child: Image.asset(
                "assets/images/logo.png",
                width: 300.0,
                height: 300.0,
                fit: BoxFit.contain,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.call, color: Color(0xFFFF6F61)),
              title: const Text(
                'Call Center',
                style: TextStyle(color: Color(0xFFFF6F61)),
              ),
              onTap: () async {
                final Uri phoneUri = Uri(
                    scheme: 'tel',
                    path: '+6281326926776'); // Replace with your phone number
                if (await canLaunchUrl(phoneUri)) {
                  await launchUrl(phoneUri);
                } else {
                  throw 'Could not launch $phoneUri';
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.sms, color: Color(0xFFFF6F61)),
              title: const Text(
                'SMS Center',
                style: TextStyle(color: Color(0xFFFF6F61)),
              ),
              onTap: () async {
                const phoneNumber =
                    '+6281326926776'; // Replace with your WhatsApp number
                final Uri whatsappUri = Uri.parse("https://wa.me/$phoneNumber");

                if (await canLaunchUrl(whatsappUri)) {
                  await launchUrl(whatsappUri);
                } else {
                  throw 'Could not launch $whatsappUri';
                }
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.location_city, color: Color(0xFFFF6F61)),
              title: const Text(
                'Location',
                style: TextStyle(color: Color(0xFFFF6F61)),
              ),
              onTap: () async {
                const double latitude =
                    -6.982235142986829; // Replace with your latitude
                const double longitude =
                    110.4091366085115; // Replace with your longitude
                final Uri mapsUri = Uri.parse(
                    "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude");

                if (await canLaunchUrl(mapsUri)) {
                  await launchUrl(mapsUri);
                } else {
                  throw 'Could not launch $mapsUri';
                }
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.account_circle, color: Color(0xFFFF6F61)),
              title: const Text(
                'Update User & Password',
                style: TextStyle(color: Color(0xFFFF6F61)),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UpdateScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: const Color(0xFF008080),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: ourMenu.length,
                itemBuilder: (context, index) {
                  final item = ourMenu[index];
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            item.link,
                            fit: BoxFit.cover,
                            height: double.infinity,
                            width: double.infinity,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    item.name,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.white),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'Price: ${item.price} IDR',
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                ),
                                const SizedBox(height: 4),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(item.name),
                                        content: Text(item.desc),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('Close'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFF6F61),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 4.0),
                                    minimumSize: const Size(60, 30),
                                  ),
                                  child: const Text(
                                    'Desc',
                                    style: TextStyle(
                                        color: Color(0xFF008080), fontSize: 12),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _addItem(item.name, item.price);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFF6F61),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 4.0),
                                    minimumSize: const Size(60, 30),
                                  ),
                                  child: const Text(
                                    'Add',
                                    style: TextStyle(
                                        color: Color(0xFF008080), fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _selectedItems.isNotEmpty ? _checkout : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6F61),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Checkout',
                style: TextStyle(color: Color(0xFF008080), fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
