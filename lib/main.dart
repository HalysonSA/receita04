import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

var data = [
  {"name": "La Fin Du Monde", "style": "Bock", "ibu": "65"},
  {"name": "Sapporo Premiume", "style": "Sour Ale", "ibu": "54"},
  {"name": "Duvel", "style": "Pilsner", "ibu": "82"},
  {"name": "American Pale Ale", "style": "Pale Ale", "ibu": "30-50"},
  {"name": "India Pale Ale", "style": "India Pale Ale", "ibu": "40-60"},
  {"name": "Stout", "style": "Stout", "ibu": "30-60"},
  {"name": "Belgian Witbier", "style": "Witbier", "ibu": "10-20"},
  {"name": "Pilsner", "style": "Pilsner", "ibu": "25-45"},
  {"name": "Brown Ale", "style": "Brown Ale", "ibu": "20"},
  {"name": "Hefeweizen", "style": "Weissbier ", "ibu": "10-15"},
  {"name": "Double IPA", "style": " Double India Pale Ale", "ibu": "60-120"},
  {"name": "Saison", "style": "Farmhouse Ale", "ibu": "20-35"}
];

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
          body: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: data[0]
                  .keys
                  .map((e) => Container(
                      width: 100,
                      padding: EdgeInsets.all(10),
                      child: Center(
                          child: Text(e,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)))))
                  .toList(),
            ),
            Expanded(child: GenericItem(objects: data)),
          ]),

          // body: Center(
          //   child: ProductWidget(futureProduct: futureProduct),
          // ),
          bottomNavigationBar: NewNavBar(),
        ));
  }
}

class GenericItem extends StatelessWidget {
  List<Map<String, dynamic>> objects;

  GenericItem({this.objects = const []});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(30),
      itemCount: objects.length,
      itemBuilder: (context, index) {
        final titles = objects[index].keys.toList();
        final values = objects[index].values.toList();

        return Row(
          children: titles
              .map((e) => Expanded(
                  child: Column(
                      children: [Text(values[titles.indexOf(e)].toString())])))
              .toList(),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
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
