import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

var data = [
  {"name": "La Fin Du Monde", "style": "Bock", "ibu": "65"},
  {"name": "Sapporo Premiume", "style": "Sour Ale", "ibu": "54"},
  {"name": "Duvel", "style": "Pilsner", "ibu": "82"},
  {"name": "La Fin Du Monde", "style": "Bock", "ibu": "65"},
  {"name": "Sapporo Premiume", "style": "Sour Ale", "ibu": "54"},
  {"name": "Duvel", "style": "Pilsner", "ibu": "82"},
  {"name": "La Fin Du Monde", "style": "Bock", "ibu": "65"},
  {"name": "Sapporo Premiume", "style": "Sour Ale", "ibu": "54"},
  {"name": "Duvel", "style": "Pilsner", "ibu": "82"},
  {"name": "La Fin Du Monde", "style": "Bock", "ibu": "65"},
  {"name": "Sapporo Premiume", "style": "Sour Ale", "ibu": "54"},
  {"name": "Duvel", "style": "Pilsner", "ibu": "82"}
];
void main() {
  MyApp app = MyApp();
  runApp(app);
}

class MyApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Produtos"),
          ),
          body: GenericItem(
            objects: data,
          ),
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

        return ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: titles
                .map((e) => Text(
                      "$e: ${values[titles.indexOf(e)]}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 18),
                    ))
                .toList(),
          ),
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
