import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_fincode/flutter_fincode.dart';
import 'package:flutter_fincode/flutter_fincode_platform_interface.dart';
import 'package:flutter_fincode/flutter_fincode_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterFincodePlatform
    with MockPlatformInterfaceMixin
    implements FlutterFincodePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<dynamic> payment(Map<String, String> data) => Future.value();

  @override
  Future<dynamic> cardInfoList(String customerId) => Future.value();

  @override
  Future<dynamic> registerCard(Map<String, String> data) => Future.value();

  @override
  Future<void> showPaymentSheet() => Future.value();
}

void main() {
  final FlutterFincodePlatform initialPlatform = FlutterFincodePlatform.instance;

  test('$MethodChannelFlutterFincode is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterFincode>());
  });

  test('getPlatformVersion', () async {
    FlutterFincode flutterFincodePlugin = FlutterFincode();
    MockFlutterFincodePlatform fakePlatform = MockFlutterFincodePlatform();
    FlutterFincodePlatform.instance = fakePlatform;

    expect(await flutterFincodePlugin.getPlatformVersion(), '42');
  });
}
