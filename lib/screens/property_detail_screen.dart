import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/property/property.dart';
import 'form_screen.dart';

import '../services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class PropertyDetailScreen extends StatefulWidget {
  final Property property;
  final int? idUsuario;

  const PropertyDetailScreen({
    super.key,
    required this.property,
    this.idUsuario,
  });

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  late String selectedImage;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    selectedImage =
        widget.property.images.isNotEmpty ? widget.property.images[0].url : '';
    currentIndex = 0;
  }

  void _launchWhatsApp(String phone) async {
    final whatsappUri = Uri.parse('whatsapp://send?phone=$phone');
    final fallbackUri = Uri.parse('https://wa.me/$phone');

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else if (await canLaunchUrl(fallbackUri)) {
      await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir WhatsApp')),
      );
    }
  }


  void _launchMap(double lat, double lng) async {
    final mapUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );
    if (await canLaunchUrl(mapUrl)) {
      await launchUrl(mapUrl, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir el mapa')),
      );
    }
  }

  void _mostrarGaleria(int startIndex) {
    currentIndex = startIndex;
    bool showArrows = true;
    Timer? hideTimer;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Galería',
      barrierColor: Colors.black.withOpacity(0.9),
      pageBuilder: (_, __, ___) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            void toggleArrows() {
              setStateDialog(() => showArrows = true);
              hideTimer?.cancel();
              hideTimer = Timer(const Duration(seconds: 3), () {
                setStateDialog(() => showArrows = false);
              });
            }

            toggleArrows();

            return GestureDetector(
              onTap: toggleArrows,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Stack(
                  alignment: Alignment.center,
                  children: [
                    InteractiveViewer(
                      child: Center(
                        child: Image.network(
                          widget.property.images[currentIndex].url,
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),
                    if (showArrows && currentIndex > 0)
                      Positioned(
                        left: 16,
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 32,
                          ),
                          onPressed: () {
                            setStateDialog(() {
                              currentIndex--;
                            });
                            toggleArrows();
                          },
                        ),
                      ),
                    if (showArrows &&
                        currentIndex < widget.property.images.length - 1)
                      Positioned(
                        right: 16,
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 32,
                          ),
                          onPressed: () {
                            setStateDialog(() {
                              currentIndex++;
                            });
                            toggleArrows();
                          },
                        ),
                      ),
                    if (showArrows)
                      Positioned(
                        top: 40,
                        right: 20,
                        child: IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 32,
                          ),
                          onPressed: () {
                            hideTimer?.cancel();
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((_) => hideTimer?.cancel());
  }

  Widget _buildDetailRow(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 14, color: Colors.black),
            children: [
              TextSpan(
                text: '$title: ',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: content),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Divider(thickness: 1, color: Colors.grey),
        const SizedBox(height: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final property = widget.property;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          property.name,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: () => _mostrarGaleria(currentIndex),
                          child: Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                selectedImage,
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 60,
                        child: Center(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: property.images.length,
                            itemBuilder: (context, index) {
                              final img = property.images[index].url;
                              final isSelected = img == selectedImage;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedImage = img;
                                    currentIndex = index;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  child: Opacity(
                                    opacity: isSelected ? 1.0 : 0.4,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color:
                                              isSelected
                                                  ? Colors.blue
                                                  : Colors.transparent,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: Image.network(
                                          img,
                                          height: 40,
                                          width: 40,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '\$ ${property.minPrice} - \$ ${property.maxPrice}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 9, 8, 8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ), // <<--- Línea agregada
                      const SizedBox(height: 8),
                      _buildDetailRow('Descripción', property.description),

                      _buildDetailRow('Tamaño', '${property.size} m²'),
                      _buildDetailRow('Zona', property.zone),
                      _buildDetailRow(
                        'Vendedor',
                        '${property.user.name} - ${property.user.numberPhone}',
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              final rawPhone = property.user.numberPhone
                                  .replaceAll(RegExp(r'\D'), '');
                              final phone =
                                  rawPhone.length < 10
                                      ? '591$rawPhone'
                                      : rawPhone;
                              if (phone.isNotEmpty) {
                                _launchWhatsApp(phone);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Número de contacto no disponible',
                                    ),
                                  ),
                                );
                              }
                            },
                            icon: const FaIcon(
                              FontAwesomeIcons.whatsapp,
                              size: 18,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'WhatsApp',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2D2D2D),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () async {
                              final Uri url = Uri.parse(property.mapLocation);
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              } else {
                                // Manejo de error si no se puede abrir la URL
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('No se pudo abrir Google Maps')),
                                );
                              }
                            },
                            icon: const FaIcon(
                              FontAwesomeIcons.mapLocationDot,
                              size: 18,
                              color: Colors.white,
                            ),
                            label:  Text(
                              'Ubicación',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 104, 131, 196,),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar:
          widget.idUsuario != null
              ? BottomNavigationBar(
                selectedItemColor: const Color.fromARGB(255, 176, 34, 34),
                unselectedItemColor: const Color.fromARGB(221, 4, 43, 239),
                backgroundColor: Colors.white,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.edit),
                    label: 'Editar',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.delete),
                    label: 'Eliminar',
                  ),
                ],
                onTap: (index) async {
                  if (index == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => FormScreen(
                              property: widget.property,
                              idUser: widget.idUsuario!,
                              type: widget.property.idTipe,
                            ),
                      ),
                    ).then((updated) {
                      if (updated == true) {
                        
                        Navigator.pop(
                          context,
                          true,
                        ); 
                      }
                    });
                  } else if (index == 1) {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text('Confirmar eliminación'),
                            content: const Text(
                              '¿Estás seguro de que deseas eliminar esta propiedad?',
                            ),
                            actions: [
                              TextButton(
                                onPressed:
                                    () => Navigator.of(context).pop(false),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed:
                                    () => Navigator.of(context).pop(true),
                                child: const Text('Confirmar'),
                              ),
                            ],
                          ),
                    );
                    if (confirm == true) {
                      try {
                        final api = ApiService();
                        await api.deleteProperty(widget.property.id);
                        if (mounted) {
                          Navigator.of(context).pop(true);
                          showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text('Eliminación exitosa'),
                                  content: const Text(
                                    'La propiedad ha sido eliminada correctamente.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.of(context).pop(),
                                      child: const Text('Aceptar'),
                                    ),
                                  ],
                                ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error al eliminar: $e')),
                        );
                      }
                    }
                  }
                },
              )
              : null,
    );
  }
}
