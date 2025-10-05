import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _sendLocation = true;
  bool _pushNotifications = true;
  Set<int> _days = {}; // 0=Mo .. 6=Su

  static const _kSendLocation = 'notif_send_location';
  static const _kPushNotifications = 'notif_push_notifications';
  static const _kDailyDays = 'notif_daily_days';

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _sendLocation = prefs.getBool(_kSendLocation) ?? true;
      _pushNotifications = prefs.getBool(_kPushNotifications) ?? true;
      final daysCsv = prefs.getString(_kDailyDays) ?? '';
      _days = daysCsv.isEmpty
          ? {}
          : daysCsv
                .split(',')
                .map((s) => int.tryParse(s) ?? -1)
                .where((v) => v >= 0)
                .toSet();
    });
  }

  Future<void> _saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> _saveDays() async {
    final prefs = await SharedPreferences.getInstance();
    final csv = _days.join(',');
    await prefs.setString(_kDailyDays, csv);
  }

  void _toggleDay(int index) {
    setState(() {
      if (_days.contains(index))
        _days.remove(index);
      else
        _days.add(index);
    });
    _saveDays();
  }

  @override
  Widget build(BuildContext context) {
    const week = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildToggleCard(
              title: 'Send location information',
              subtitle:
                  'Be the first to learn about new stores, great tips, updates, and even more.',
              value: _sendLocation,
              onChanged: (v) {
                setState(() => _sendLocation = v);
                _saveBool(_kSendLocation, v);
              },
            ),
            const SizedBox(height: 12),
            _buildToggleCard(
              title: 'Push notifications',
              subtitle:
                  'Get notified about availability, feature updates, promotions, and more.',
              value: _pushNotifications,
              onChanged: (v) {
                setState(() => _pushNotifications = v);
                _saveBool(_kPushNotifications, v);
              },
            ),
            const SizedBox(height: 12),
            const Text(
              'Daily reminder',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Select which days you\'d like an extra reminder to save food.',
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: List.generate(7, (i) {
                final selected = _days.contains(i);
                return ChoiceChip(
                  label: Text(week[i]),
                  selected: selected,
                  onSelected: (_) => _toggleDay(i),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleCard({
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                if (subtitle != null) const SizedBox(height: 6),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
              ],
            ),
          ),
          Switch.adaptive(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
