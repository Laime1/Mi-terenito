import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String hintText;

  const CustomSearchBar({
    Key? key,
    required this.onChanged,
    this.hintText = 'Buscar...',
  }) : super(key: key);

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  bool _isExpanded = false;
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _focusNode.requestFocus();
      } else {
        _controller.clear();
        widget.onChanged('');
        _focusNode.unfocus();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 1.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: _isExpanded ? MediaQuery.of(context).size.width * 0.8 : 50,
          height: 50,
          // padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: _isExpanded
                ? Colors.grey.shade100
            : Colors.green,
            borderRadius: BorderRadius.circular(25),
            // border: Border.all(),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(100),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
           mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: IconButton(
                  icon:  Icon(Icons.search, color: _isExpanded ? Colors.black : Theme.of(context).bottomNavigationBarTheme.selectedItemColor),
                  onPressed: _toggleExpansion,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
              if (_isExpanded)
                Expanded(
                  flex: 4,
                  child: TextField(
                    style: const TextStyle(color: Colors.black),
                    controller: _controller,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      hintText: widget.hintText,
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: widget.onChanged,
                    onSubmitted: (_) => _toggleExpansion(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}