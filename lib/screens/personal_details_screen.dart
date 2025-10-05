import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'edit_personal_field_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({Key? key}) : super(key: key);

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  String _name = 'John Doe';
  String _email = 'johndoe@gmail.com';
  String _phone = '+1 778 646 1646';

  static const _kName = 'user_name';
  static const _kEmail = 'user_email';
  static const _kPhone = 'user_phone';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString(_kName) ?? _name;
      _email = prefs.getString(_kEmail) ?? _email;
      _phone = prefs.getString(_kPhone) ?? _phone;
    });
  }

  Future<void> _saveProfileValue(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<void> _editField(
    String title,
    String current,
    String key,
    ValueChanged<String> onSaved,
  ) async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) =>
            EditPersonalFieldScreen(title: title, initialValue: current),
      ),
    );
    if (result != null && result.isNotEmpty) {
      onSaved(result);
      await _saveProfileValue(key, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          _buildDetailTile(
            'Name',
            _name,
            onTap: () => _editField(
              'Your name',
              _name,
              _kName,
              (v) => setState(() => _name = v),
            ),
          ),
          _buildDetailTile(
            'Email',
            _email,
            onTap: () => _editField(
              'Your email',
              _email,
              _kEmail,
              (v) => setState(() => _email = v),
            ),
          ),
          _buildDetailTile(
            'Phone',
            _phone,
            onTap: () => _editField(
              'Your phone',
              _phone,
              _kPhone,
              (v) => setState(() => _phone = v),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailTile(String title, String value, {VoidCallback? onTap}) {
    return Column(
      children: [
        ListTile(
          title: Text(title, style: const TextStyle(color: Colors.grey)),
          subtitle: Text(value, style: const TextStyle(fontSize: 16)),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
        const Divider(height: 1),
      ],
    );
  }
}
