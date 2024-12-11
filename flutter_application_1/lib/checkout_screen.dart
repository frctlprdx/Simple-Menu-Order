import 'package:flutter/material.dart';

class CheckoutScreen extends StatelessWidget {
  final Map<String, int> selectedItems;
  final int totalPrice;

  const CheckoutScreen({
    Key? key,
    required this.selectedItems,
    required this.totalPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: const Color(0xFF008080),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Order',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: selectedItems.length,
                itemBuilder: (context, index) {
                  final itemName = selectedItems.keys.elementAt(index);
                  final quantity = selectedItems[itemName];
                  return ListTile(
                    title: Text(itemName),
                    subtitle: Text('Quantity: $quantity'),
                  );
                },
              ),
            ),
            const Divider(),
            Text(
              'Total Price: $totalPrice IDR',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Add checkout logic here
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6F61),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Confirm Order',
                style: TextStyle(color: Color(0xFF008080), fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
