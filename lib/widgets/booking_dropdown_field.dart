import 'package:flutter/material.dart';

/// 🎨 STUDIO THEME COLORS
const Color neonPink = Color(0xFFFF2FB3);
const Color textGrey = Color(0xFFB0B0C3);
const Color cardBlack = Color(0xFF14141C);

class BookingDropdownField extends StatefulWidget {
  final String label;
  final List<String> items;
  final String? initialValue;
  final Function(String?) onChanged;

  const BookingDropdownField({
    super.key,
    required this.label,
    required this.items,
    this.initialValue,
    required this.onChanged,
  });

  @override
  State<BookingDropdownField> createState() => _BookingDropdownFieldState();
}

class _BookingDropdownFieldState extends State<BookingDropdownField> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue ?? widget.items.first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardBlack,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        dropdownColor: cardBlack,
        icon: Icon(Icons.keyboard_arrow_down, color: neonPink),
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: const TextStyle(color: textGrey),
          border: InputBorder.none,
        ),
        style: const TextStyle(color: Colors.white),
        items: widget.items
            .map((item) => DropdownMenuItem(
          value: item,
          child: Text(item),
        ))
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedValue = value;
          });
          widget.onChanged(value);
        },
      ),
    );
  }
}
