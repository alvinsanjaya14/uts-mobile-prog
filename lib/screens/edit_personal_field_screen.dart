import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditPersonalFieldScreen extends StatefulWidget {
  final String title;
  final String initialValue;

  const EditPersonalFieldScreen({
    super.key,
    required this.title,
    required this.initialValue,
  });

  @override
  State<EditPersonalFieldScreen> createState() =>
      _EditPersonalFieldScreenState();
}

class _EditPersonalFieldScreenState extends State<EditPersonalFieldScreen> {
  late TextEditingController _controller;
  String _prefix = '+1';
  final List<Map<String, String>> _countries = const [
    {'label': 'US', 'code': '+1'},
    {'label': 'ID', 'code': '+62'},
    {'label': 'UK', 'code': '+44'},
    {'label': 'IN', 'code': '+91'},
  ];

  @override
  void initState() {
    super.initState();
    final isPhone = widget.title.toLowerCase().contains('phone');
    if (isPhone) {
      final trimmed = widget.initialValue.trim();
      if (trimmed.startsWith('+')) {
        final parts = trimmed.split(RegExp(r'\s+'));
        final first = parts.first;
        final match = _countries.firstWhere(
          (c) => first.startsWith(c['code']!),
          orElse: () => {'label': 'US', 'code': '+1'},
        );
        _prefix = match['code']!;
        final rest = trimmed
            .substring(_prefix.length)
            .replaceAll(RegExp(r'\D'), '');
        _controller = TextEditingController(text: _formatDigits(rest));
      } else {
        final digits = widget.initialValue.replaceAll(RegExp(r'\D'), '');
        _controller = TextEditingController(text: _formatDigits(digits));
      }
    } else {
      _controller = TextEditingController(text: widget.initialValue);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final isPhone = widget.title.toLowerCase().contains('phone');
    if (isPhone) {
      final digits = _controller.text.replaceAll(RegExp(r'\D'), '');
      Navigator.of(context).pop('$_prefix ${_formatDigits(digits)}'.trim());
    } else {
      Navigator.of(context).pop(_controller.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPhone = widget.title.toLowerCase().contains('phone');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [TextButton(onPressed: _save, child: const Text('Save'))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isPhone
            ? Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _prefix,
                        items: _countries
                            .map(
                              (c) => DropdownMenuItem(
                                value: c['code'],
                                child: Text('${c['label']} ${c['code']}'),
                              ),
                            )
                            .toList(),
                        onChanged: (v) {
                          if (v != null) setState(() => _prefix = v);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _controller,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (text) {
                        final digits = text.replaceAll(RegExp(r'\D'), '');
                        final formatted = _formatDigits(digits);
                        if (formatted != text) {
                          _controller.value = TextEditingValue(
                            text: formatted,
                            selection: TextSelection.collapsed(
                              offset: formatted.length,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              )
            : TextFormField(
                controller: _controller,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
      ),
    );
  }

  String _formatDigits(String digits) {
    if (digits.isEmpty) return '';
    if (digits.length >= 10) {
      final part1 = digits.substring(0, digits.length - 7);
      final part2 = digits.substring(digits.length - 7, digits.length - 4);
      final part3 = digits.substring(digits.length - 4);
      final parts = [part1, part2, part3].where((s) => s.isNotEmpty).toList();
      return parts.join(' ');
    }
    final matches = RegExp(
      r'.{1,3}',
    ).allMatches(digits).map((m) => m.group(0)).whereType<String>();
    return matches.join(' ');
  }
}
