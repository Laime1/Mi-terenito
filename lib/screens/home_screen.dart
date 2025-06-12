import 'package:flutter/material.dart';
import '../widgets/empresa_card.dart';
import '../services/api_service.dart';
import 'casas_screen.dart';
import 'terrenos_screen.dart';
import 'home2_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedCity;
  int? selectedEmpresaId;
  List<String> cities = [];
  List<dynamic> empresas = [];
  bool isLoading = true;

  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    loadCities();
  }

  Future<void> loadCities() async {
    try {
      final loadedCities = await apiService.fetchCities();
      setState(() {
        cities = loadedCities;
        selectedCity = cities.isNotEmpty ? cities.first : null;
        isLoading = false;
      });
      if (selectedCity != null) {
        final cityId = await apiService.getCityIdByName(selectedCity!);
        loadEmpresas(cityId);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> loadEmpresas(int cityId) async {
    try {
      final loadedEmpresas = await apiService.fetchEmpresasByCiudad(cityId);
      setState(() {
        empresas = loadedEmpresas;
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('9:30', style: TextStyle(fontSize: 14)),
            Text('Mi Terrenito', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {},
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: DropdownButton<String>(
                      value: selectedCity,
                      isExpanded: true,
                      hint: const Text('Selecciona una ciudad'),
                      underline: Container(
                        height: 1,
                        color: Colors.grey,
                      ),
                      items: cities.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) async {
                        setState(() {
                          selectedCity = newValue;
                          empresas = [];
                          selectedEmpresaId = null;
                        });
                        if (newValue != null) {
                          final cityId = await apiService.getCityIdByName(newValue);
                          loadEmpresas(cityId);
                        }
                      },
                    ),
                  ),
                  if (empresas.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Empresas:', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: empresas.length,
                            itemBuilder: (context, index) {
                              final empresa = empresas[index];
                              final isSelected = selectedEmpresaId == empresa['id_empresa'];
                              return EmpresaCard(
                                empresa: empresa,
                                isSelected: isSelected,
                                onSelect: () {
                                  setState(() {
                                    selectedEmpresaId = empresa['id_empresa'];
                                  });
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  else
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No existen empresas en esta ciudad'),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildMenuItem('Casas', Icons.home),
                        _buildMenuItem('Terrenos', Icons.landscape),
                        _buildMenuItem('Departamentos', Icons.apartment),
                        _buildMenuItem('Alquileres', Icons.home_work),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon) {
    return Card(
      child: InkWell(
        onTap: () async {
          if (selectedEmpresaId != null && selectedCity != null) {
            final cityId = await apiService.getCityIdByName(selectedCity!);
            String tipo = title.toLowerCase();

            Widget destino;

            switch (tipo) {
              case 'casas':
                destino = CasasScreen(
                  empresaId: selectedEmpresaId!,
                  cityId: cityId,
                );
                break;
              case 'terrenos':
                destino = TerrenosScreen(
                  empresaId: selectedEmpresaId!,
                  cityId: cityId,
                );
                break;
              case 'departamentos':
              case 'alquileres':
                destino = Home2Screen(
                  tipo: tipo,
                  empresaId: selectedEmpresaId!,
                  cityId: cityId,
                );
                break;
              default:
                destino = CasasScreen(
                  empresaId: selectedEmpresaId!,
                  cityId: cityId,
                );
            }

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => destino),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Selecciona ciudad y empresa")),
            );
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 10),
            Text(title),
          ],
        ),
      ),
    );
  }
}
