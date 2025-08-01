import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../models/app_theme.dart';
import '../services/theme_provider.dart';
import '../widgets/custom_dropdown.dart';
import '../services/api_service.dart';
import 'home2_screen.dart';
import 'package:lottie/lottie.dart';
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

  bool isLoadingEmpresas = false;
  bool isVerificandoPropiedades = false;

  bool hasCasas = false;
  bool hasTerrenos = false;
  bool hasDepartamentos = false;
  bool hasAlquileres = false;

  String? usuarioName;

  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();

    _loadUsuarioName();

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

  Future<void> _loadUsuarioName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('usuarioNameKey');
    setState(() {
      usuarioName = name;
    });
  }

  Future<void> loadCities() async {
    try {
      final loadedCities = await apiService.fetchCities();
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
    setState(() {
      isLoadingEmpresas = true;
    });

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
    } finally {
      setState(() {
        isLoadingEmpresas = false;
      });
    }
  }

  Future<void> verificarDisponibilidadPropiedades(int ciudadId, int empresaId) async {
    setState(() {
      isVerificandoPropiedades = true;
    });

    bool casas = await apiService.existePropiedad('casas', empresaId, ciudadId);
    bool terrenos = await apiService.existePropiedad('terrenos', empresaId, ciudadId);
    bool departamentos = await apiService.existePropiedad('departamentos', empresaId, ciudadId);
    bool alquileres = await apiService.existePropiedad('alquileres', empresaId, ciudadId);

    setState(() {
      hasCasas = casas;
      hasTerrenos = terrenos;
      hasDepartamentos = departamentos;
      hasAlquileres = alquileres;
      isVerificandoPropiedades = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.light;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('', style: TextStyle(fontSize: 14, color: Colors.white)),
            Text('Click House',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color:  Color(0xFFc49c2e))),
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
              style: TextStyle(color:  Color(0xFFc49c2e)),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 120,
                    decoration: const BoxDecoration(
                      color: Color(0xFF022021),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 35, right: 35, top: 40),
                    child: Column(
                      children: [
                        CustomDropdown(
                          items: cities,
                          selectedItem: selectedCity,
                          hint: 'Ciudad',
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
                        isLoadingEmpresas
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                child: Center(child: CircularProgressIndicator()),
                              )
                            : empresas.isNotEmpty
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
                                : const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    child: Text(
                                      'Sin empresas',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: AppColors.cardText),
                                    ),
                                  ),
                        const SizedBox(height: 40),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Opacity(
                              opacity: isVerificandoPropiedades ? 0.5 : 1.0,
                              child: GridView.count(
                                crossAxisCount: 2,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  _buildMenuItem('Casas', Icons.house_rounded, hasCasas),
                                  _buildMenuItem('Terrenos', Icons.park_rounded, hasTerrenos),
                                  _buildMenuItem('Departamentos', Icons.apartment_rounded, hasDepartamentos),
                                  _buildMenuItem('Alquileres', Icons.real_estate_agent_rounded, hasAlquileres),
                                ],
                              ),
                            ),
                            if (isVerificandoPropiedades)
                              SizedBox(
                                height: 200,
                                width: 200,
                                child: Lottie.asset('assets/animations/cargaAnimation.json'),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, bool enabled) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.4,
      child: Card(
        color: Color(0xFF022021),
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
                          isLoggedIn: usuarioName != null && usuarioName!.isNotEmpty,
                          usuarioName: usuarioName,
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
              ShaderMask(
                shaderCallback: (bounds) {
                  return const LinearGradient(
                    colors: [
                      Color(0xFFbc972b),
                      Color(0xFF957021),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ).createShader(bounds);
                },
                child: Icon(
                  icon,
                  size: 65,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 10),
        ShaderMask(
          shaderCallback: (bounds) {
            return const LinearGradient(
              colors: [
                Color(0xFFFFD700),
                Color(0xFFC99700),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ).createShader(bounds);
          },
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        )
            ],
          ),
        ),
      ),
    );
  }
}