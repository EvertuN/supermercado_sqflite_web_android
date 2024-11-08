import 'package:flutter/material.dart';
import 'package:supermercado_sqflite_web_android/controller/pdfPrintingFile.dart';

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  const CartPage({Key? key, required this.cartItems}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void _clearCart() {
    setState(() {
      widget.cartItems.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        title: const Text('Carrinho'),
      ),
      body: ListView.builder(
        itemCount: widget.cartItems.length,
        itemBuilder: (context, index) {
          final item = widget.cartItems[index];
          return ListTile(
            title: Text('${item['name']} (x${item['quantity']})'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  widget.cartItems.removeAt(index);
                });
              },
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () async {
              await generateAndPrintPdf(context, widget.cartItems);
              _clearCart();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "COMPRAR",
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
              ),
            ),
          )
      ),
    );
  }
}
