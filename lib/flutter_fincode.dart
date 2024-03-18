
import 'flutter_fincode_platform_interface.dart';

class FlutterFincode {
  Future<String?> getPlatformVersion() {
    return FlutterFincodePlatform.instance.getPlatformVersion();
  }

  Future<dynamic> payment(Map<String, String> data) {
    return FlutterFincodePlatform.instance.payment(data);
  }

  Future<dynamic> cardInfoList(String customerId) {
    return FlutterFincodePlatform.instance.cardInfoList(customerId);
  }

  Future<dynamic> registerCard(Map<String, String> data) {
    return FlutterFincodePlatform.instance.registerCard(data);
  }

  Future<dynamic> showPaymentSheet() {
    return FlutterFincodePlatform.instance.showPaymentSheet();
  }
}
