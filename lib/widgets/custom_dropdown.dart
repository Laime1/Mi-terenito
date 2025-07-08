import 'package:flutter/material.dart';
import '../models/app_colors.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> items;
  final String? selectedItem;
  final ValueChanged<String> onChanged;
  final String hint;

  const CustomDropdown({
    Key? key,
    required this.items,
    required this.onChanged,
    this.selectedItem,
    required this.hint,
  }) : super(key: key);

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _iconRotation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _iconRotation = Tween<double>(begin: 0, end: 0.5).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleDropdown() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = (widget.items.length * 48).clamp(0, 150).toDouble();

    return Column(
      children: [
        GestureDetector(
          onTap: toggleDropdown,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: Color(0xFF022021),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade500),
            ),
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                Center(
                  child: Text(
                    widget.selectedItem ?? widget.hint,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFc49c2e), // será reemplazado por el degradado
                    ),
                  ),
                ),
                RotationTransition(
                  turns: _iconRotation,
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFFc49c2e),
                  ),
                ),
              ],
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: isExpanded ? maxHeight : 0,
            decoration: BoxDecoration(
              color: AppColors.bodyBackground,
              border: Border.all(color: Colors.grey.shade400),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: widget.items.map((item) {
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        widget.onChanged(item);
                        toggleDropdown();
                      },
                      child: Container(
                        height: 48,
                        alignment: Alignment.center,
                        child: Text(
                          item,
                          style: const TextStyle(color: AppColors.cardText),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
