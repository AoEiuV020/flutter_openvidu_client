import 'package:permission_handler/permission_handler.dart';

class PermissionChecker {
  static Future check() async {
    await _ckeckCamera();
    await _ckeckMicrophone();
  }

  static Future _ckeckCamera() async {
    final isGranted = await Permission.camera.isGranted;
    if (!isGranted) {
      final status = await Permission.camera.request();
      if (status != PermissionStatus.granted) {
        openAppSettings();
      }
    }
  }

  static Future _ckeckMicrophone() async {
    final isGranted = await Permission.microphone.isGranted;
    if (!isGranted) {
      final status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        openAppSettings();
      }
    }
  }
}
