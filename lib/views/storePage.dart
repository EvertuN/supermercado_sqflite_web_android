import 'package:flutter/material.dart';
import '../db/database_helper.dart';

class StorePage extends StatefulWidget {
  final List<Map<String, dynamic>> cart;

  const StorePage({Key? key, required this.cart}) : super(key: key);

  @override
  State<StorePage> createState() => _StorePageState();
}



class _StorePageState extends State<StorePage> {
  List<Map<String, dynamic>> _items = [];
  final List<Map<String, dynamic>> _cart = [];
  final Map<int, int> _itemQuantities = {};

  Future<void> _loadItems() async {
    final items = await DatabaseHelper().getItems();
    setState(() {
      _items = items;
      _items.forEach((item) {
        _itemQuantities[item['id']] = 1;
      });
    });
  }

  void _addToCart(Map<String, dynamic> item, int quantity) {
    setState(() {
      widget.cart.add({'id': item['id'], 'name': item['name'], 'quantity': quantity});
    });
  }



  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          title: const Text('Super Mercado Penvmbra', style: TextStyle(color: Colors.white),),
        ),
        body: ListView.builder(
          itemCount: _items.length,
          itemBuilder: (context, index) {
            final item = _items[index];
            return ListTile(
              title: Text(item['name']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<int>(
                    value: _itemQuantities[item['id']],
                    items: List.generate(10, (i) => i + 1)
                        .map((quantity) => DropdownMenuItem(
                      value: quantity,
                      child: Text('$quantity'),
                    ))
                        .toList(),
                    onChanged: (newQuantity) {
                      setState(() {
                        _itemQuantities[item['id']] = newQuantity!;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      _addToCart(item, _itemQuantities[item['id']]!);
                    },
                  ),
                ],
              ),
            );
          },
        ),
    );
  }
}
