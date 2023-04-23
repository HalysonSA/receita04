import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<ProductFuture> fetchProduct() async {
  final response =
      await http.get(Uri.parse('https://fakestoreapi.com/products/'));
  if (response.statusCode != 200) {
    throw Exception('Failed to load products');
  }

  return ProductFuture.fromJson(jsonDecode(response.body));
}

class ProductFuture {
  List<Product> products;

  ProductFuture({required this.products});

  factory ProductFuture.fromJson(List<dynamic> json) {
    return ProductFuture(
      products: json.map((e) => Product.fromJson(e)).toList(),
    );
  }
}

class ProductWidget extends HookWidget {
  final Future<ProductFuture> futureProduct;

  ProductWidget({required this.futureProduct});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProductFuture>(
      future: futureProduct,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ProductList(products: snapshot.data!.products);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }
}

void main() {
  MyApp app = MyApp();
  runApp(app);
}

class MyApp extends HookWidget {
  late Future<ProductFuture> futureProduct;

  MyApp() {
    futureProduct = fetchProduct();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Produtos"),
          ),
          body: Center(
            child: ProductWidget(futureProduct: futureProduct),
          ),
          bottomNavigationBar: NewNavBar(),
        ));
  }
}

class NewNavBar extends HookWidget {
  void botaoFoiTocado(int index) {
    print("Tocaram no botão $index");
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(onTap: botaoFoiTocado, items: const [
      BottomNavigationBarItem(
        label: "Produtos",
        icon: Icon(Icons.list_alt),
      ),
      BottomNavigationBarItem(
          label: "Cervejas", icon: Icon(Icons.local_drink_outlined)),
      BottomNavigationBarItem(label: "Nações", icon: Icon(Icons.flag_outlined))
    ]);
  }
}

class Product {
  int id;
  String title;
  String description;
  String image;
  double price;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.image,
      required this.price});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      price: json['price'],
    );
  }
}

class ProductList extends HookWidget {
  final List<Product> products;

  ProductList({required this.products});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            minVerticalPadding: 10,
            title: Text(products[index].title, style: TextStyle(fontSize: 20)),
            subtitle: Text(products[index].description,
                style: TextStyle(fontSize: 12)),
            leading: Image.network(
              products[index].image,
              width: 90,
            ),
            trailing: Text("\$${products[index].price.toString()}",
                style: TextStyle(fontSize: 20)),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}
