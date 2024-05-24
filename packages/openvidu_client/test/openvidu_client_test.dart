import 'package:flutter_test/flutter_test.dart';
import 'package:openvidu_client/openvidu_client_method_channel.dart';
import 'package:openvidu_client/openvidu_client_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockOpenviduClientPlatform
    with MockPlatformInterfaceMixin
    implements OpenviduClientPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final OpenviduClientPlatform initialPlatform =
      OpenviduClientPlatform.instance;

  test('$MethodChannelOpenviduClient is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelOpenviduClient>());
  });

  test('getPlatformVersion', () async {
    // OpenViduClient openviduClientPlugin = OpenViduClient();
    // MockOpenviduClientPlatform fakePlatform = MockOpenviduClientPlatform();
    // OpenviduClientPlatform.instance = fakePlatform;

    // expect(await openviduClientPlugin.getPlatformVersion(), '42');
  });
}
