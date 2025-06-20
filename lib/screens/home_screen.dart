import 'package:flutter/material.dart';
import '../widgets/custom_dropdown.dart';
import '../services/api_service.dart';
import 'home2_screen.dart';
import '../models/app_colors.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final String? selectedCity;
  final String? selectedEmpresaName;
  final int? selectedEmpresaId;
  final bool hasCasas;
  final bool hasTerrenos;
  final bool hasDepartamentos;
  final bool hasAlquileres;

  const HomeScreen({
    super.key,
    this.selectedCity,
    this.selectedEmpresaName,
    this.selectedEmpresaId,
    this.hasCasas = false,
    this.hasTerrenos = false,
    this.hasDepartamentos = false,
    this.hasAlquileres = false,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedCity;
  String? selectedEmpresaName;
  int? selectedEmpresaId;
  List<String> cities = [];
  List<dynamic> empresas = [];
  bool isLoading = true;

  bool hasCasas = false;
  bool hasTerrenos = false;
  bool hasDepartamentos = false;
  bool hasAlquileres = false;

  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();

    selectedCity = widget.selectedCity;
    selectedEmpresaName = widget.selectedEmpresaName;
    selectedEmpresaId = widget.selectedEmpresaId;

    hasCasas = widget.hasCasas;
    hasTerrenos = widget.hasTerrenos;
    hasDepartamentos = widget.hasDepartamentos;
    hasAlquileres = widget.hasAlquileres;

    if (selectedCity == null) {
      loadCities();
    } else {
      apiService.fetchCities().then((loadedCities) async {
        final cityId = await apiService.getCityIdByName(selectedCity!);
        final loadedEmpresas = await apiService.fetchEmpresasByCiudad(cityId);

        setState(() {
          cities = loadedCities;
          empresas = loadedEmpresas;
          isLoading = false;
        });
      });
    }
  }

  Future<void> loadCities() async {
    try {
      final loadedCities = await apiService.fetchCities();
      print('ciudades: ${loadedCities}');
      setState(() {
        cities = loadedCities;
        selectedCity = null;
        isLoading = false;
        empresas = [];
        selectedEmpresaName = null;
        selectedEmpresaId = null;

        hasCasas = false;
        hasTerrenos = false;
        hasDepartamentos = false;
        hasAlquileres = false;
      });
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
        selectedEmpresaName = null;
        selectedEmpresaId = null;

        hasCasas = false;
        hasTerrenos = false;
        hasDepartamentos = false;
        hasAlquileres = false;
      });
    } catch (e) {
      setState(() {
        empresas = [];
        selectedEmpresaName = null;
        selectedEmpresaId = null;

        hasCasas = false;
        hasTerrenos = false;
        hasDepartamentos = false;
        hasAlquileres = false;
      });
    }
  }

  Future<void> verificarDisponibilidadPropiedades(int ciudadId, int empresaId) async {
    bool casas = await apiService.existePropiedad('casas', empresaId, ciudadId);
    bool terrenos = await apiService.existePropiedad('terrenos', empresaId, ciudadId);
    bool departamentos = await apiService.existePropiedad('departamentos', empresaId, ciudadId);
    bool alquileres = await apiService.existePropiedad('alquileres', empresaId, ciudadId);

    setState(() {
      hasCasas = casas;
      hasTerrenos = terrenos;
      hasDepartamentos = departamentos;
      hasAlquileres = alquileres;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bodyBackground,
      appBar: AppBar(
        backgroundColor: AppColors.appBarBackground,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('', style: TextStyle(fontSize: 14, color: AppColors.appBarText)),
            Text('Click House',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.appBarText)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text(
              'Iniciar sesión',
              style: TextStyle(color: AppColors.appBarText),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CustomDropdown(
                      items: cities,
                      selectedItem: selectedCity,
                      hint: 'Ciudades',
                      onChanged: (value) async {
                        setState(() {
                          selectedCity = value;
                          empresas = [];
                          selectedEmpresaId = null;
                          selectedEmpresaName = null;

                          hasCasas = false;
                          hasTerrenos = false;
                          hasDepartamentos = false;
                          hasAlquileres = false;
                        });
                        if (value != null) {
                          final cityId = await apiService.getCityIdByName(value);
                          await loadEmpresas(cityId);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    empresas.isNotEmpty
                        ? CustomDropdown(
                            items: empresas.map<String>((e) => e['nombre'] as String).toList(),
                            selectedItem: selectedEmpresaName,
                            hint: 'Empresas',
                            onChanged: (value) async {
                              final empresa = empresas.firstWhere((e) => e['nombre'] == value);
                              setState(() {
                                selectedEmpresaName = value;
                                selectedEmpresaId = empresa['id_empresa'];
                              });
                              if (selectedCity != null && selectedEmpresaId != null) {
                                final cityId = await apiService.getCityIdByName(selectedCity!);
                                await verificarDisponibilidadPropiedades(cityId, selectedEmpresaId!);
                              }
                            },
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: const Text('Sin empresas',
                                textAlign: TextAlign.center, style: TextStyle(color: AppColors.cardText)),
                          ),
                    const SizedBox(height: 100),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildMenuItem('Casas', Icons.house_rounded, hasCasas),
                        _buildMenuItem('Terrenos', Icons.park_rounded, hasTerrenos),
                        _buildMenuItem('Departamentos', Icons.apartment_rounded, hasDepartamentos),
                        _buildMenuItem('Alquileres', Icons.real_estate_agent_rounded, hasAlquileres),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, bool enabled) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.4,
      child: Card(
        color: AppColors.cardBackground,
        child: InkWell(
          onTap: enabled
              ? () async {
                  if (selectedEmpresaId != null && selectedCity != null && selectedEmpresaName != null) {
                    final cityId = await apiService.getCityIdByName(selectedCity!);
                    String tipo = title.toLowerCase();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home2Screen(
                          tipo: tipo,
                          empresaId: selectedEmpresaId!,
                          cityId: cityId,
                          selectedCityName: selectedCity!,
                          selectedEmpresaName: selectedEmpresaName!,
                          hasCasas: hasCasas,
                          hasTerrenos: hasTerrenos,
                          hasDepartamentos: hasDepartamentos,
                          hasAlquileres: hasAlquileres,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Selecciona ciudad y empresa")),
                    );
                  }
                }
              : null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: AppColors.cardText),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(color: AppColors.cardText)),
            ],
          ),
        ),
      ),
    );
  }
}