import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Views/ongkir_screen.dart';

class OrderScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final int totalPrice;

  const OrderScreen({Key? key, required this.cartItems, required this.totalPrice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Summary'),
        backgroundColor: Color(0xFF008080),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Items in Cart:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...cartItems.map((item) {
              return Text('${item['productName']} x ${item['quantity']} = ${item['sellPrice'] * item['quantity']} IDR');
            }).toList(),
            const SizedBox(height: 20),
            Text('Total: $totalPrice IDR', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OngkirScreen(totalPrice: totalPrice),
                  ),
                );
              },
              child: const Text('Place Order'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF008080),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
