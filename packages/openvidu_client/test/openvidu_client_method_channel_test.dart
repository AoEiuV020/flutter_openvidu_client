import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openvidu_client/openvidu_client_method_channel.dart';

void main() {
  MethodChannelOpenviduClient platform = MethodChannelOpenviduClient();
  const MethodChannel channel = MethodChannel('openvidu_client');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
