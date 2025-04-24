import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;
  int toggleSelectedIndex = 0;
  String searchQuery = '';

  final List<Widget> pages = <Widget>[
    Text('Lista de Terrenos'),
    Text('Agregar Terreno'),
    Text('Detalles de Terreno'),
  ];

  final List<String> toggleOptions = ['Terrenos', 'Alquileres', 'Casas'];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void onTogglePressed(int index) {
    setState(() {
      toggleSelectedIndex = index;
    });
  }

  void onSearchChanged(String value) {
    setState(() {
      searchQuery = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<bool> isSelected = List.generate(
      toggleOptions.length,
      (index) => index == toggleSelectedIndex,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Icon(Icons.person),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 12.0),
            child: ToggleButtons(
              isSelected: isSelected,
              onPressed: onTogglePressed,
              borderRadius: BorderRadius.circular(10),
              selectedColor: Colors.white,
              fillColor: const Color.fromARGB(221, 18, 18, 19),
              color: Colors.black54,
              children: List.generate(toggleOptions.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (toggleSelectedIndex == index)
                        Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Icon(Icons.check, size: 16, color: Colors.white),
                        ),
                      Text(toggleOptions[index]),
                    ],
                  ),
                );
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: TextField(
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                hintText: 'Buscar...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: pages[selectedIndex],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Lista',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: 'Agregar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.density_small_rounded),
            label: 'Detalles de Terreno',
          ),
        ],
      ),
    );
  }
}
