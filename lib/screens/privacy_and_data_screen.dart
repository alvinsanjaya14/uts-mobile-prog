import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrivacyAndDataScreen extends StatefulWidget {
  const PrivacyAndDataScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyAndDataScreen> createState() => _PrivacyAndDataScreenState();
}

class _PrivacyAndDataScreenState extends State<PrivacyAndDataScreen> {
  bool _shareForAds = false;
  bool _trackAcrossApps = false;
  bool _sendLocation = true;

  static const _kShareForAds = 'privacy_share_for_ads';
  static const _kTrackAcrossApps = 'privacy_track_across_apps';
  static const _kSendLocation = 'privacy_send_location';

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _shareForAds = prefs.getBool(_kShareForAds) ?? false;
      _trackAcrossApps = prefs.getBool(_kTrackAcrossApps) ?? false;
      _sendLocation = prefs.getBool(_kSendLocation) ?? true;
    });
  }

  Future<void> _saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy and data'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        child: Column(
          children: [
            _buildToggleCard(
              title: 'Sharing personal information for targeted advertising',
              value: _shareForAds,
              onChanged: (v) async {
                await _saveBool(_kShareForAds, v);
                setState(() => _shareForAds = v);
              },
            ),
            const SizedBox(height: 12),
            _buildToggleCard(
              title: 'Track activity across apps and websites',
              value: _trackAcrossApps,
              onChanged: (v) async {
                await _saveBool(_kTrackAcrossApps, v);
                setState(() => _trackAcrossApps = v);
              },
            ),
            const SizedBox(height: 12),
            _buildToggleCard(
              title: 'Send location information',
              value: _sendLocation,
              onChanged: (v) async {
                await _saveBool(_kSendLocation, v);
                setState(() => _sendLocation = v);
              },
            ),
            const SizedBox(height: 12),
            const Expanded(
              child: SingleChildScrollView(
                child: Text(
                  'When using the app, precise geolocation may be used to fulfill service and app functionality, such as to help you find a store or ensure products are ready close to when you arrive at store.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleCard({
    required String title,
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
          Expanded(child: Text(title)),
          Switch.adaptive(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
