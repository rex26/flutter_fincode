import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_fincode_platform_interface.dart';

/// An implementation of [FlutterFincodePlatform] that uses method channels.
class MethodChannelFlutterFincode extends FlutterFincodePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_fincode');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<dynamic> payment(Map<String, String> data) async {
    return await methodChannel.invokeMethod<dynamic>('payment', data);
  }

  @override
  Future<dynamic> cardInfoList(String customerId) async {
    return await methodChannel.invokeMethod<dynamic>('cardInfoList', customerId);
  }

  @override
  Future<dynamic> registerCard(Map<String, String> data) async {
    return await methodChannel.invokeMethod<dynamic>('registerCard', data);
  }

  @override
  Future<dynamic> showPaymentSheet() async {
    return await methodChannel.invokeMethod<void>('showPaymentSheet');
  }
}
