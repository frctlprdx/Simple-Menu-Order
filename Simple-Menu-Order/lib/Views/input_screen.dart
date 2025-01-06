import 'package:flutter/material.dart';
import 'package:flutter_application_1/Views/customer_screen.dart';
import 'package:flutter_application_1/Views/sell_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_1/Views/item_screen.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<InputScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _buyPriceController = TextEditingController();
  final TextEditingController _sellPriceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _descrController = TextEditingController();

  bool _isLoading = false; // Loading state

  Future<void> _addItem() async {
    final id = _idController.text.trim();
    final itemName = _itemController.text;
    final buyPrice = int.tryParse(_buyPriceController.text.trim());
    final sellPrice = int.tryParse(_sellPriceController.text.trim());
    final stock = int.tryParse(_stockController.text.trim());
    final descr = _descrController.text;
    final imageUrl = _imageController.text.trim();

    if (id.isEmpty || itemName.isEmpty || buyPrice == null || sellPrice == null || stock == null || imageUrl.isEmpty) {
      _showError("All fields are required.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    const url = 'https://lively-forgiveness-production.up.railway.app/api/products';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'product_id': id,
          'product_name': itemName,
          'buyprice': buyPrice,
          'sellprice': sellPrice,
          'stock': stock,
          'img': imageUrl,
          'descr': descr,
        }),
      );

      if (response.statusCode == 201) {
        _showSuccess('Product added successfully');
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ItemScreen()));
      } else {
        _showError('Failed to add product: ${response.body}');
      }
    } catch (error) {
      _showError('An error occurred: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    _itemController.dispose();
    _buyPriceController.dispose();
    _sellPriceController.dispose();
    _stockController.dispose();
    _descrController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item', style: TextStyle(color: Color(0xFFFAF3DD))),
        backgroundColor: const Color(0xFF008080),
        iconTheme: const IconThemeData(color: Color(0xFFFAF3DD)),
      ),
      drawer: Drawer(
        child: Container(
          color: const Color(0xFF008080),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color(0xFF2F4F4F),
                ),
                child: Center(
                  child: Text(
                    'Menu',
                    style: TextStyle(color: Color(0xFFFAF3DD), fontSize: 24),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.view_list, color: Color(0xFFFAF3DD)),
                title: const Text(
                  'View Items',
                  style: TextStyle(color: Color(0xFFFAF3DD)),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ItemScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.view_list, color: Color(0xFFFAF3DD)),
                title: const Text(
                  'View Sellings',
                  style: TextStyle(color: Color(0xFFFAF3DD)),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SellScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.view_list, color: Color(0xFFFAF3DD)),
                title: const Text(
                  'View Customers',
                  style: TextStyle(color: Color(0xFFFAF3DD)),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CustomerScreen()));
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: const Color(0xFF008080),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(_idController, 'ID'),
            const SizedBox(height: 16),
            _buildTextField(_itemController, 'Item Name'),
            const SizedBox(height: 16),
            _buildTextField(_buyPriceController, 'Buy Price', keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            _buildTextField(_sellPriceController, 'Sell Price', keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            _buildTextField(_stockController, 'Stock', keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            _buildTextField(_descrController, 'Description'),
            const SizedBox(height: 16),
            _buildTextField(_imageController, 'Image URL', keyboardType: TextInputType.url),
            const SizedBox(height: 32),
            Center(
              child: _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _addItem,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6F61),
                  foregroundColor: const Color(0xFFFAF3DD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                ),
                child: const Text('Add Item'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Color(0xFFFAF3DD)),
        filled: true,
        fillColor: const Color(0xFF2F4F4F),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Color(0xFFFF6F61), width: 2.0),
        ),
      ),
      style: const TextStyle(color: Color(0xFFFAF3DD)),
    );
  }
}
