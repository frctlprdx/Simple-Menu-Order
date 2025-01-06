import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ItemScreen extends StatefulWidget {
  const ItemScreen({super.key});

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  List<dynamic> _products = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
    });

    const url = 'https://lively-forgiveness-production.up.railway.app/api/products';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          _products = json.decode(response.body);
        });
      } else {
        _showError('Failed to fetch products');
      }
    } catch (e) {
      _showError('An error occurred: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteProduct(String productId) async {
    final url = 'https://lively-forgiveness-production.up.railway.app/api/products$productId';
    try {
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        _showSuccess('Product deleted successfully');
        _fetchProducts();
      } else {
        _showError('Failed to delete product');
      }
    } catch (e) {
      _showError('An error occurred: $e');
    }
  }

  Future<void> _editProduct(String productId, Map<String, dynamic> updatedData) async {
    final url = 'https://lively-forgiveness-production.up.railway.app/api/products/$productId';
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedData),
      );
      if (response.statusCode == 200) {
        _showSuccess('Product updated successfully');
        _fetchProducts();
      } else {
        _showError('Failed to update product');
      }
    } catch (e) {
      _showError('An error occurred: $e');
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

  void _showEditDialog(Map<String, dynamic> product) {
    final TextEditingController productIdController =
    TextEditingController(text: product['product_id'].toString());
    final TextEditingController productNameController =
    TextEditingController(text: product['product_name']);
    final TextEditingController imgController =
    TextEditingController(text: product['img']);
    final TextEditingController descrController =
    TextEditingController(text: product['descr']);
    final TextEditingController buyPriceController =
    TextEditingController(text: product['buyprice'].toString());
    final TextEditingController sellPriceController =
    TextEditingController(text: product['sellprice'].toString());
    final TextEditingController stockController =
    TextEditingController(text: product['stock'].toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Product'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(productIdController, 'Product ID', readOnly: true),
                const SizedBox(height: 16),
                _buildTextField(productNameController, 'Product Name'),
                const SizedBox(height: 16),
                _buildTextField(buyPriceController, 'Buy Price',
                    keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                _buildTextField(sellPriceController, 'Sell Price',
                    keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                _buildTextField(stockController, 'Stock',
                    keyboardType: TextInputType.number),
                _buildTextField(imgController, 'Image URL'),
                const SizedBox(height: 16),
                _buildTextField(descrController, 'Description'),
                const SizedBox(height: 16),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFFFF6F61)),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF008080),
              ),
              onPressed: () {
                final updatedData = {
                  'product_name': productNameController.text.trim(),
                  'buyprice': int.tryParse(buyPriceController.text.trim()),
                  'sellprice': int.tryParse(sellPriceController.text.trim()),
                  'stock': int.tryParse(stockController.text.trim()),
                  'img': imgController.text.trim(),
                  'descr': descrController.text.trim(),
                };
                _editProduct(product['product_id'], updatedData);
                Navigator.pop(context);
              },
              child: const Text(
                'Save',
                style: TextStyle(color: Color(0xFFFF6F61)),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String labelText, {
        TextInputType keyboardType = TextInputType.text,
        bool readOnly = false,
      }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.black),
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor:const Color(0xFF008080),
      ),
      backgroundColor: const Color(0xFF008080),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return Card(
              color: Color(0xFFFF6F61),
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                product['product_name'],
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                'Buy: ${product['buyprice']} | Sell: ${product['sellprice']} | Stock: ${product['stock']}',
                style: const TextStyle(color: Colors.white),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color:Colors.white ),
                    onPressed: () => _showEditDialog(product),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.white),
                    onPressed: () => _deleteProduct(product['product_id']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
