import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_fincode_method_channel.dart';

abstract class FlutterFincodePlatform extends PlatformInterface {
  /// Constructs a FlutterFincodePlatform.
  FlutterFincodePlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterFincodePlatform _instance = MethodChannelFlutterFincode();

  /// The default instance of [FlutterFincodePlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterFincode].
  static FlutterFincodePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterFincodePlatform] when
  /// they register themselves.
  static set instance(FlutterFincodePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> payment(Map<String, String> data) {
    throw UnimplementedError('payment() has not been implemented.');
  }

  Future<dynamic> cardInfoList(String customerId) {
    throw UnimplementedError('cardInfoList() has not been implemented.');
  }

  Future<dynamic> registerCard(Map<String, String> data) {
    throw UnimplementedError('registerCard() has not been implemented.');
  }

  Future<dynamic> showPaymentSheet() {
    throw UnimplementedError('showPaymentSheet() has not been implemented.');
  }
}
