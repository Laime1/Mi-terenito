import 'package:flutter/material.dart';
import 'package:mi_terrenito/models/property.dart';
import 'package:mi_terrenito/screens/lands.screen.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;

  final List<Property> properties = [
     Property(
         name: 'Archipielago Alalay(Cochabamba)',
         size: 400,
         images: ['https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTYr-GmtrfZWSAxatZEkftLn6fXLD0QTqyCcQ&s', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR-WWwP-_XelzhkjL7VROxlw9BuGVH6KjrE3Q&s'],
         description: 'Ubicado en pleno centro de la laguna alalay, con vista a la..',
         minPrice: 999,
         maxPrice: 1000,
         zone: 'Zona Sur',
         location: 'Cochabamba',
         mapLocation: 'https://www.google.com/maps/place/Plaza+Sucre/@-17.411946,-66.1632659,13z/data=!4m9!1m2!2m1!1zLA!3m5!1s0x93e373f8d705ee63:0x8b64d1ced4c8c13f!8m2!3d-17.3922658!4d-66.1480371!16s%2Fg%2F1tj3m4zb?hl=es-419&entry=ttu&g_ep=EgoyMDI1MDQyMi4wIKXMDSoASAFQAw%3D%3D'
     ),
    Property(
        name: 'Archipielago Alalay(Cochabamba)',
        size: 400,
        images: ['https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR-WWwP-_XelzhkjL7VROxlw9BuGVH6KjrE3Q&s', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR-WWwP-_XelzhkjL7VROxlw9BuGVH6KjrE3Q&s'],
        description: '''Ubicado en pleno centro de la laguna alalay, con vista a la...''',
        minPrice: 999,
        maxPrice: 1000,
        zone: 'Zona Sur',
        location: 'Cochabamba',
        mapLocation: 'https://www.google.com/maps/place/Plaza+Sucre/@-17.411946,-66.1632659,13z/data=!4m9!1m2!2m1!1zLA!3m5!1s0x93e373f8d705ee63:0x8b64d1ced4c8c13f!8m2!3d-17.3922658!4d-66.1480371!16s%2Fg%2F1tj3m4zb?hl=es-419&entry=ttu&g_ep=EgoyMDI1MDQyMi4wIKXMDSoASAFQAw%3D%3D'
    ),
  ];
  

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      LandScreen(properties: properties),
      Text('Agregar Terreno'),
      Text('Detalles de Terreno'),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Icon(Icons.person)
        ],
      ),
    
      body: Center(
        child: pages.elementAt(selectedIndex),
      ),     
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Lista',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Agregar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.details),
            label: 'Detalles de Terreno',
            )
        ],
        ),
    );
  }

}