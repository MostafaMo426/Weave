import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/nearby_service.dart';
import '../services/language_service.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _msgController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NearbyService>(context, listen: false).checkPermissions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final nearbyService = Provider.of<NearbyService>(context);
    final lang = Provider.of<LanguageService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.t('app_title')),
        actions: [
          TextButton(
            onPressed: lang.toggleLanguage,
            child: Text(
              lang.currentLocale == 'ar' ? 'English' : 'عربي',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: Icon(Icons.stop_circle_outlined),
            tooltip: lang.t('stop_all'),
            onPressed: nearbyService.stopAll,
          )
        ],
      ),
      body: Column(
        children: [
          // أزرار التحكم
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: nearbyService.startAdvertising,
                  child: Text(lang.t('advertise_btn')),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                ),
                ElevatedButton(
                  onPressed: nearbyService.startDiscovery,
                  child: Text(lang.t('discover_btn')),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              ],
            ),
          ),

          Divider(),

          // 1. قسم الأجهزة المتاحة (للاتصال اليدوي)
          if (nearbyService.availableDevices.isNotEmpty) ...[
            Container(
              padding: EdgeInsets.all(8),
              color: Colors.yellow[100],
              width: double.infinity,
              child: Text(
                lang.currentLocale == 'ar' ? "أجهزة متاحة (اضغط للاتصال)" : "Available Devices (Tap to connect)",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              height: 100, // مساحة صغيرة للقائمة
              child: ListView(
                children: nearbyService.availableDevices.entries.map((entry) {
                  return ListTile(
                    title: Text(entry.value), // اسم الجهاز
                    subtitle: Text(entry.key), // الـ ID
                    leading: Icon(Icons.bluetooth_searching),
                    trailing: ElevatedButton(
                      child: Text(lang.currentLocale == 'ar' ? "اتصال" : "Connect"),
                      onPressed: () {
                        // هنا الفعل اليدوي!
                        nearbyService.requestConnection(entry.key, entry.value);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            Divider(thickness: 2),
          ],

          // 2. قسم الأجهزة المتصلة
          Container(
            padding: EdgeInsets.all(8),
            color: Colors.grey[200],
            width: double.infinity,
            child: Text(
              "${lang.t('connected_label')}${nearbyService.connectedDevices.length}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          // 3. منطقة الشات
          Expanded(
            child: ListView.builder(
              itemCount: nearbyService.logs.length,
              itemBuilder: (context, index) {
                final logItem = nearbyService.logs[index];
                String displayText;
                if (logItem.key == 'msg_received' || logItem.key == 'msg_sent') {
                  displayText = logItem.param;
                } else {
                  displayText = lang.translateLog(logItem);
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Text(displayText),
                );
              },
            ),
          ),

          Divider(),

          // 4. حقل الإرسال
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    textDirection: lang.textDirection,
                    decoration: InputDecoration(
                      hintText: lang.t('hint_text'),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  color: Colors.blue,
                  onPressed: () {
                    if (_msgController.text.isNotEmpty) {
                      nearbyService.broadcastMessage(_msgController.text);
                      _msgController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}