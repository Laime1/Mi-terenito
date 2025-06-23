import 'package:flutter/material.dart';

import '../models/city.dart';
import '../models/company.dart';

class RentalSpecificationsTable extends StatefulWidget {
  final int? bedrooms;
  final int? bathrooms;
  final bool? garage;
  final int? floors;
  final double? size;
  final bool? services;
  final bool? furnished;
  final City? city;
  final Company? company;
  final String? username;
  final DateTime? publishedAt;
  final String? phone;
  final String? email;
  final String? mapLocation; // Nuevo campo para ubicación

  const RentalSpecificationsTable({
    super.key,
    this.bedrooms,
    this.bathrooms,
    this.garage,
    this.floors,
    this.size,
    this.services,
    this.furnished,
    this.city,
    this.company,
    this.username,
    this.publishedAt,
    this.phone,
    this.email,
    this.mapLocation,
  });

  @override
  State<RentalSpecificationsTable> createState() => _RentalSpecificationsTableState();
}

class _RentalSpecificationsTableState extends State<RentalSpecificationsTable> {
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
          'Características',
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
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(1.5),
                1: FlexColumnWidth(1.5),
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
                    padding: const EdgeInsets.only(left: 10, top: 12, bottom: 12),
                    child: Text(
                      spec.value,
                      style: TextStyle(
                        color: spec.isHighlighted
                            ? Theme.of(context).primaryColor
                            : Colors.grey[800],
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
      if (widget.bedrooms != null)
        _SpecificationItem(
          icon: Icons.bed,
          title: 'Habitaciones',
          value: widget.bedrooms.toString(),
        ),
      if (widget.bathrooms != null)
        _SpecificationItem(
          icon: Icons.bathtub,
          title: 'Baños',
          value: widget.bathrooms.toString(),
        ),
      if (widget.furnished != null)
        _SpecificationItem(
          icon: Icons.checkroom,
          title: 'Amoblado',
          value: widget.furnished! ? 'Sí' : 'No',
          isHighlighted: widget.furnished!,
        ),
      if (widget.services != null)
        _SpecificationItem(
          icon: Icons.construction,
          title: 'Servicios incluidos',
          value: widget.services! ? 'Sí' : 'No',
          isHighlighted: widget.services!,
        ),
      if (widget.city?.name.isNotEmpty ?? false)
        _SpecificationItem(
          icon: Icons.location_city,
          title: 'Ciudad',
          value: widget.city!.name,
        ),
      if (widget.company?.name?.isNotEmpty ?? false)
        _SpecificationItem(
          icon: Icons.business,
          title: 'Empresa',
          value: widget.company!.name!,
        ),
      if (widget.username?.isNotEmpty ?? false)
        _SpecificationItem(
          icon: Icons.person,
          title: 'Publicado por',
          value: widget.username!,
        ),
      if (widget.publishedAt != null)
        _SpecificationItem(
          icon: Icons.calendar_today,
          title: 'Fecha de publicación',
          value: _formatDate(widget.publishedAt!),
        ),
      if (widget.phone?.isNotEmpty ?? false)
        _SpecificationItem(
          icon: Icons.phone,
          title: 'Teléfono',
          value: widget.phone!,
        ),
      if (widget.email?.isNotEmpty ?? false)
        _SpecificationItem(
          icon: Icons.email,
          title: 'Email',
          value: widget.email!,
        ),
      if (widget.mapLocation?.isNotEmpty ?? false)
        _SpecificationItem(
          icon: Icons.map,
          title: 'Ubicación',
          value: widget.mapLocation!,
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