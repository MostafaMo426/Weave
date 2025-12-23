import 'dart:convert'; // <--- مهم جداً عشان العربي (utf8)
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:permission_handler/permission_handler.dart';

class LogMessage {
  final String key;
  final String param;
  LogMessage(this.key, {this.param = ''});
}

class NearbyService extends ChangeNotifier {
  final Strategy strategy = Strategy.P2P_CLUSTER;
  String userName = "User_${DateTime.now().second}"; // ممكن تغير الاسم ده براحتك

  // 1. قايمة الأجهزة المتصلة بالفعل (بكلمهم دلوقتي)
  Map<String, String> connectedDevices = {};

  // 2. قايمة الأجهزة المتاحة (اللي لقيتها بس لسه متصلتش بيها)
  Map<String, String> availableDevices = {}; // <--- جديد

  List<LogMessage> logs = [];

  void log(String key, {String param = ''}) {
    logs.add(LogMessage(key, param: param));
    notifyListeners();
  }

  // ... (checkPermissions زي ما هي) ...
  Future<void> checkPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.bluetooth,
      Permission.bluetoothAdvertise,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.nearbyWifiDevices
    ].request();
    if (statuses.values.every((element) => element.isGranted)) {
      log('log_perms_ok');
    }
  }

  // ... (startAdvertising زي ما هي تقريباً) ...
  Future<void> startAdvertising() async {
    try {
      await Nearby().startAdvertising(
        userName,
        strategy,
        onConnectionInitiated: _onConnectionInitiated,
        onConnectionResult: (id, status) {
          if (status == Status.CONNECTED) {
            log('log_connected', param: id);
            connectedDevices[id] = "Unknown";
            // لو كنت حاطه في قايمة المتاح، شيله خلاص بقيت متصل بيه
            availableDevices.remove(id);
            notifyListeners();
          } else {
            log('log_error', param: "Connection failed");
          }
        },
        onDisconnected: (id) {
          log('log_disconnected', param: id);
          connectedDevices.remove(id);
          notifyListeners();
        },
      );
      log('log_adv_started');
    } catch (e) {
      log('log_error', param: e.toString());
    }
  }

  // 3. تعديل البحث (Discovery) عشان ميتصلش لوحده
  Future<void> startDiscovery() async {
    try {
      availableDevices.clear(); // نضف القايمة القديمة
      await Nearby().startDiscovery(
        userName,
        strategy,
        onEndpointFound: (id, name, serviceId) {
          // هنا التغيير الجوهري:
          // بدل ما نتصل علطول، هنضيفه للقايمة ونعرف الـ UI
          log('log_endpoint_found', param: "$name ($id)");
          availableDevices[id] = name; // ضيفه للقائمة
          notifyListeners(); // حدث الشاشة
        },
        onEndpointLost: (id) {
          log('log_endpoint_lost', param: id ?? "Unknown");
          availableDevices.remove(id); // شيله من القايمة لو مشي
          notifyListeners();
        },
      );
      log('log_disc_started');
    } catch (e) {
      log('log_error', param: e.toString());
    }
  }

  // 4. دالة جديدة: انت اللي بتناديها لما تدوس على اسم الجهاز
  void requestConnection(String id, String nickname) {
    Nearby().requestConnection(
      userName,
      id,
      onConnectionInitiated: _onConnectionInitiated,
      onConnectionResult: (id, status) {
        if (status == Status.CONNECTED) {
          log('log_connected', param: nickname);
          connectedDevices[id] = nickname;
          availableDevices.remove(id); // شيله من المتاح
          notifyListeners();
        } else {
          log('log_error', param: "Connection rejected");
        }
      },
      onDisconnected: (id) {
        log('log_disconnected', param: id);
        connectedDevices.remove(id);
        notifyListeners();
      },
    );
  }

  void _onConnectionInitiated(String id, ConnectionInfo info) {
    log('log_conn_req', param: info.endpointName);

    // القبول التلقائي (ممكن نخليه يدوي برضه لو حبيت، بس خليه تلقائي دلوقتي للسهولة)
    Nearby().acceptConnection(
      id,
      onPayLoadRecieved: (endPointId, payload) {
        if (payload.type == PayloadType.BYTES) {
          // 5. حل مشكلة العربي: استخدام utf8.decode
          String message = utf8.decode(payload.bytes!);
          logs.add(LogMessage('msg_received', param: "$endPointId: $message"));
          notifyListeners();
        }
      },
    );
  }

  void broadcastMessage(String message) {
    if (connectedDevices.isEmpty) return;

    connectedDevices.forEach((id, name) {
      try {
        // 6. حل مشكلة العربي: استخدام utf8.encode
        Nearby().sendBytesPayload(id, Uint8List.fromList(utf8.encode(message)));
      } catch (e) {
        // ignore
      }
    });
    logs.add(LogMessage('msg_sent', param: "Me: $message"));
    notifyListeners();
  }

  void stopAll() {
    Nearby().stopAdvertising();
    Nearby().stopDiscovery();
    Nearby().stopAllEndpoints();
    connectedDevices.clear();
    availableDevices.clear(); // نضف دي كمان
    log('log_stopped');
    notifyListeners();
  }
}