import 'package:flutter/material.dart';

class EditPersonalFieldScreen extends StatefulWidget {
  final String title;
  final String initialValue;

  const EditPersonalFieldScreen({
    Key? key,
    required this.title,
    required this.initialValue,
  }) : super(key: key);

  @override
  State<EditPersonalFieldScreen> createState() =>
      _EditPersonalFieldScreenState();
}

class _EditPersonalFieldScreenState extends State<EditPersonalFieldScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    Navigator.of(context).pop(_controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
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
        child: TextFormField(
          controller: _controller,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
      ),
    );
  }
}
