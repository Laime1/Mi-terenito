import 'package:flutter/material.dart';
import '../../models/house.dart';

class HouseSpecificationsTable extends StatefulWidget {
  final House house;

  const HouseSpecificationsTable({super.key, required this.house});

  @override
  State<HouseSpecificationsTable> createState() => _HouseSpecificationsTableState();
}

class _HouseSpecificationsTableState extends State<HouseSpecificationsTable> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final specs = _buildSpecificationsList();

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ExpansionTile(
        title: const Text(
          'Características de la Casa',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        initiallyExpanded: false,
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        trailing: Icon(
          _isExpanded ? Icons.expand_less : Icons.expand_more,
          color: Colors.grey,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(1.5),
                1: FlexColumnWidth(2),
              },
              border: TableBorder(
                horizontalInside: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
              children: specs.map((spec) => TableRow(
                decoration: BoxDecoration(
                  color: spec.isHighlighted ? Colors.blue[50] : null,
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    child: Row(
                      children: [
                        Icon(spec.icon, size: 20, color: Colors.blue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            spec.title,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    child: Center(
                      child: Text(
                        spec.value,
                        style: TextStyle(
                          color: spec.isHighlighted
                              ? Theme.of(context).primaryColor
                              : Colors.grey[800],
                        ),
                      ),
                    ),
                  ),
                ],
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }

  List<_SpecificationItem> _buildSpecificationsList() {
    return [
      _SpecificationItem(
        icon: Icons.king_bed,
        title: 'Habitaciones',
        value: widget.house.bedrooms.toString(),
      ),
      _SpecificationItem(
        icon: Icons.bathtub,
        title: 'Baños',
        value: widget.house.bathrooms.toString(),
      ),
      _SpecificationItem(
        icon: Icons.garage,
        title: 'Garage',
        value: widget.house.garage.toString(),
      ),
      _SpecificationItem(
        icon: Icons.apartment,
        title: 'Pisos',
        value: widget.house.floors.toString(),
      ),
      _SpecificationItem(
        icon: Icons.location_city,
        title: 'Ciudad',
        value: widget.house.city?.name ?? 'No disponible',
      ),
      _SpecificationItem(
        icon: Icons.calendar_today,
        title: 'Fecha de publicación',
        value: _formatDate(widget.house.publishedAt),
      ),
      if (widget.house.company != null)
        _SpecificationItem(
          icon: Icons.business,
          title: 'Empresa',
          value: widget.house.company!.name,
        ),
      if (widget.house.user != null)
        _SpecificationItem(
          icon: Icons.person,
          title: 'Publicado por',
          value: widget.house.user!.name,
        ),
      if (widget.house.company != null && widget.house.company!.phone.isNotEmpty)
        _SpecificationItem(
          icon: Icons.phone,
          title: 'Teléfono',
          value: widget.house.company!.phone,
        ),
      if (widget.house.company != null && widget.house.company!.email.isNotEmpty)
        _SpecificationItem(
          icon: Icons.email,
          title: 'Email',
          value: widget.house.company!.email,
        ),
    ];
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _SpecificationItem {
  final IconData icon;
  final String title;
  final String value;
  final bool isHighlighted;

  _SpecificationItem({
    required this.icon,
    required this.title,
    required this.value,
    this.isHighlighted = false,
  });
}
