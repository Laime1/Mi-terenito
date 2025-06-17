import 'package:flutter/material.dart';
import '../models/rental.dart';

class RentalSpecificationsTable extends StatefulWidget {
  final Rental rental;

  const RentalSpecificationsTable({super.key, required this.rental});

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
          'Características del Alquiler',
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
                        Text(
                          spec.title,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
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
      _SpecificationItem(
        icon: Icons.checkroom,
        title: 'Amoblado',
        value: widget.rental.furnished == 'Sí' ? 'Sí' : 'No',
        isHighlighted: widget.rental.furnished == 'Si',
      ),
      _SpecificationItem(
        icon: Icons.construction,
        title: 'Servicios incluidos',
        value: widget.rental.includedServices == 'Sí' ? 'Sí' : 'No',
        isHighlighted: widget.rental.includedServices == 'Sí',
      ),
      _SpecificationItem(
        icon: Icons.location_city,
        title: 'Ciudad',
        value: widget.rental.city.name,
      ),
      _SpecificationItem(
        icon: Icons.business,
        title: 'Empresa',
        value: widget.rental.company.name,
      ),
      _SpecificationItem(
        icon: Icons.person,
        title: 'Publicado por',
        value: widget.rental.user.name,
      ),
      _SpecificationItem(
        icon: Icons.calendar_today,
        title: 'Fecha de publicación',
        value: _formatDate(widget.rental.publishedAt),
      ),
      if (widget.rental.company.phone.isNotEmpty)
        _SpecificationItem(
          icon: Icons.phone,
          title: 'Teléfono',
          value: widget.rental.company.phone,
        ),
      if (widget.rental.company.email.isNotEmpty)
        _SpecificationItem(
          icon: Icons.email,
          title: 'Email',
          value: widget.rental.company.email,
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