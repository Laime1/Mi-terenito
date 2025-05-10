import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/property/property.dart';

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
    selectedImage = widget.property.images[0].url;
    currentIndex = 0;
  }

  void _mostrarGaleria(int startIndex) {
    currentIndex = startIndex;
    bool showArrows = true;
    Timer? hideTimer;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
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
            child: Dialog(
              backgroundColor: Colors.black.withOpacity(0.9),
              insetPadding: EdgeInsets.zero,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  InteractiveViewer(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        widget.property.images[currentIndex].url,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  if (showArrows && currentIndex > 0)
                    Positioned(
                      left: 8,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 28),
                        onPressed: () {
                          setStateDialog(() {
                            currentIndex--;
                          });
                          toggleArrows();
                        },
                      ),
                    ),
                  if (showArrows && currentIndex < widget.property.images.length - 1)
                    Positioned(
                      right: 8,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 28),
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
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 28),
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
      ),
    ).then((_) => hideTimer?.cancel());
  }

  @override
  Widget build(BuildContext context) {
    final property = widget.property;

    print('idUsuario en PropertyDetailScreen: ${widget.idUsuario}'); 

    return Scaffold(
      appBar: AppBar(
        title: Text(property.name, style: const TextStyle(fontSize: 16)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: () => _mostrarGaleria(currentIndex),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    selectedImage,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
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
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected ? Colors.blue : Colors.transparent,
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
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '\$ ${property.minPrice} - \$ ${property.maxPrice}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            const Text('Descripción', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              property.description,
              style: const TextStyle(fontSize: 14),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 14, color: Colors.black),
                children: [
                  const TextSpan(text: 'Tamaño: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '${property.size} m²\n'),
                  const TextSpan(text: 'Zona: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: property.zone),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text('Contacto:', style: TextStyle(fontWeight: FontWeight.bold)),
            const Text('6543216 - 76543211', style: TextStyle(fontSize: 14)),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 18, color: Colors.white),
                  label: const Text('WhatsApp'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const FaIcon(FontAwesomeIcons.mapLocationDot, size: 18, color: Colors.white),
                  label: const Text('Ubicación'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: widget.idUsuario != null
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
              onTap: (index) {
                if (index == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Editar presionado')),
                  );
                } else if (index == 1) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Eliminar presionado')),
                  );
                }
              },
            )
          : null,
    );
  }
}