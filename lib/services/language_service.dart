import 'package:flutter/material.dart';
import 'nearby_service.dart'; // عشان يقدر يقرا كلاس LogMessage

class LanguageService extends ChangeNotifier {
  String _currentLocale = 'en'; // خليته يبدأ إنجليزي زي ما طلبت

  String get currentLocale => _currentLocale;

  void toggleLanguage() {
    _currentLocale = (_currentLocale == 'ar') ? 'en' : 'ar';
    notifyListeners();
  }

  // القاموس الكامل
  final Map<String, Map<String, String>> _dictionary = {
    // واجهة المستخدم
    'app_title': {'ar': 'شات بدون إنترنت', 'en': 'Mesh Chat MVP'},
    'advertise_btn': {'ar': 'إعلان (مضيف)', 'en': 'Advertise (Host)'},
    'discover_btn': {'ar': 'بحث (انضمام)', 'en': 'Discover (Join)'},
    'connected_label': {'ar': 'الأجهزة المتصلة: ', 'en': 'Connected Devices: '},
    'hint_text': {'ar': 'اكتب رسالة...', 'en': 'Type a message...'},
    'stop_all': {'ar': 'إيقاف الكل', 'en': 'Stop All'},

    // رسايل الـ Logs (جديد)
    'log_connected': {'ar': 'تم الاتصال بـ: ', 'en': 'Connected to: '},
    'log_disconnected': {'ar': 'انقطع الاتصال بـ: ', 'en': 'Disconnected from: '},
    'log_adv_started': {'ar': 'بدأ الإعلان (Advertising)...', 'en': 'Advertising started...'},
    'log_disc_started': {'ar': 'بدأ البحث (Discovery)...', 'en': 'Discovery started...'},
    'log_conn_req': {'ar': 'طلب اتصال من: ', 'en': 'Connection request from: '},
    'log_endpoint_found': {'ar': 'تم اكتشاف جهاز: ', 'en': 'Endpoint found: '},
    'log_endpoint_lost': {'ar': 'فقدان إشارة الجهاز: ', 'en': 'Endpoint lost: '},
    'log_stopped': {'ar': 'تم إيقاف جميع الخدمات', 'en': 'All services stopped'},
    'log_error': {'ar': 'خطأ: ', 'en': 'Error: '},
    'log_perms_ok': {'ar': 'تم منح الأذونات', 'en': 'Permissions granted'},
  };

  String t(String key) {
    return _dictionary[key]?[_currentLocale] ?? key;
  }

  // دالة خاصة لترجمة رسايل اللوج المدمجة (النص + اسم الجهاز)
  String translateLog(LogMessage log) {
    String baseText = t(log.key);
    if (log.param.isNotEmpty) {
      return "$baseText ${log.param}";
    }
    return baseText;
  }

  TextDirection get textDirection {
    return _currentLocale == 'ar' ? TextDirection.rtl : TextDirection.ltr;
  }
}