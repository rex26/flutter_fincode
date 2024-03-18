import Flutter
import UIKit
import FincodeSDK

public class FlutterFincodePlugin: NSObject, FlutterPlugin, UIViewControllerTransitioningDelegate {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_fincode", binaryMessenger: registrar.messenger())
        let instance = FlutterFincodePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let errorInfo: [String : Any] = [
            "status": "failed",
            "message": "Parameter error.",
            "code": -1,
        ]
        switch call.method {
        case "payment":
            guard let args = call.arguments else {
                result(errorInfo)
                return
            }
            if let getArgs = args as? [String: String] {
                payment(getArgs, result)
            }
        case "cardInfoList":
            guard let args = call.arguments else {
                result(errorInfo)
                return
            }
            if let getArgs = args as? String {
                cardInfoList(getArgs, result)
            }
        case "registerCard":
           guard let args = call.arguments else {
               result(errorInfo)
               return
           }
           if let getArgs = args as? [String: String] {
               registerCard(getArgs, result)
           }
        case "updateCard":
            updateCard()
        case "showPaymentSheet":
            showPaymentSheet(result)
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        default:
            result("\(call.method) has not been implemented.")
        }
    }
    
    func payment(_ paymentInfo: [String: String], _ callback: @escaping FlutterResult) {
        let header = [
            "Content-Type": "application/json",
            "Authorization":"Bearer m_test_NmQzMWQ5ZDQtYzM3My00ZTZiLWI1MzEtZmY2N2U4YTlhOTJlYWE0ZmI5OTQtNDZlMi00ZmY0LWE2MWQtN2RhMTY3NjJmZmMwc18yNDAyMDU5MzA1Ng",
            "Tenant-Shop-Id": "s_24020521229",
        ]
        let orderId = paymentInfo["id"] ?? ""
        let request = FincodePaymentRequest()
        request.payType = paymentInfo["payType"]
        request.accessId = paymentInfo["accessId"]
        request.id = orderId
        request.customerId = paymentInfo["customerId"]
        request.cardId = paymentInfo["cardId"]
        request.method = paymentInfo["method"]
        FincodePaymentRepository.sharedInstance.payment(orderId, request: request, header: header) { result in
            let response: [String: Any?]
            switch result {
            case .success(let data):
                response = [
                    "status": "success",
                    "message": "Payment successful.",
                    "customerId": data.customerId,
                    "id": data.id,
                    "cardNo": data.cardNo,
                    "expire": data.expire,
                    "holderName": data.holderName,
                    "created": data.created,
                    "updated": data.updated,
                    "brand": data.brand,
                ]
            case .failure(let error):
                response = [
                    "status": "failed",
                    "message": error.errorResponse.errors.first?.message ?? "",
                    "code": error.errorResponse.statusCode ?? 0,
                ]
            @unknown default:
                response = [
                    "status": "failed",
                    "message": "Unknown error.",
                    "code": -1,
                ]
                print("Unknown error.")
            }
            callback(response)
        }
    }
    
    func cardInfoList(_ customerId: String, _ callback: @escaping FlutterResult) {
        let header = [
            "Content-Type": "application/json",
            "Authorization":"Bearer m_test_NmQzMWQ5ZDQtYzM3My00ZTZiLWI1MzEtZmY2N2U4YTlhOTJlYWE0ZmI5OTQtNDZlMi00ZmY0LWE2MWQtN2RhMTY3NjJmZmMwc18yNDAyMDU5MzA1Ng",
            "Tenant-Shop-Id": "s_24020521229",
        ]
        FincodeCardOperateRepository.sharedInstance.cardInfoList(customerId, header: header) { result in
            let response: [String: Any?]
            switch result {
            case .success(let data):
                var cardList: Array = []
                data.cardInfoList.forEach { cardInfo in
                    cardList.append([
                        "id": cardInfo.id,
                        "cardNo": cardInfo.cardNo,
                        "brand": cardInfo.brand,
                        "holderName": cardInfo.holderName,
                        "expire": cardInfo.expire,
                    ])
                }
                response = [
                    "status": "success",
                    "message": "successfully obtained.",
                    "data": cardList,
                ]
            case .failure(let error):
                response = [
                    "status": "failed",
                    "message": error.errorResponse.errors.first?.message ?? "",
                    "code": error.errorResponse.statusCode ?? 0,
                ]
            @unknown default:
                response = [
                    "status": "failed",
                    "message": "Unknown error.",
                    "code": -1,
                ]
                print("Unknown error.")
            }
           callback(response)
        }
    }
    
    func registerCard(_ cardInfo: [String: String], _ callback: @escaping FlutterResult) {
        let header = [
            "Content-Type": "application/json",
            "Authorization":"Bearer m_test_NmQzMWQ5ZDQtYzM3My00ZTZiLWI1MzEtZmY2N2U4YTlhOTJlYWE0ZmI5OTQtNDZlMi00ZmY0LWE2MWQtN2RhMTY3NjJmZmMwc18yNDAyMDU5MzA1Ng",
            "Tenant-Shop-Id": "s_24020521229",
        ]
        let customerId = cardInfo["customerId"] ?? ""
        let request = FincodeCardRegisterRequest()
        request.defaultFlag = "1"
        request.cardNo = cardInfo["cardNo"]
        request.expire = cardInfo["expire"]
        request.holderName = cardInfo["holderName"]
        request.securityCode = cardInfo["securityCode"]

        FincodeCardOperateRepository.sharedInstance.registerCard(customerId, request: request, header: header) { result in
            let response: [String: Any?]
            switch result {
            case .success(let data):
                response = [
                    "status": "success",
                    "message": "Registered successfully.",
                    "customerId": data.customerId,
                    "id": data.id,
                    "cardNo": data.cardNo,
                    "expire": data.expire,
                    "holderName": data.holderName,
                    "created": data.created,
                    "updated": data.updated,
                    "type": data.type,
                    "brand": data.brand,
                ]
            case .failure(let error):
                response = [
                    "status": "failed",
                    "message": error.errorResponse.errors.first?.message ?? "",
                    "code": error.errorResponse.statusCode ?? 0,
                ]
            @unknown default:
                response = [
                    "status": "failed",
                    "message": "Unknown error.",
                    "code": -1,
                ]
                print("Unknown error.")
            }
           callback(response)
        }
    }
    
    func updateCard() {
        
    }
    
    func showPaymentSheet(_ callback: @escaping FlutterResult) {
        let bundle = Bundle(for: PaymentViewController.self)
        let storyboard = UIStoryboard(name: "Payment", bundle: bundle)
        let viewController = storyboard.instantiateViewController(withIdentifier: "sid_payment") as! PaymentViewController
        viewController.completionCallback = { result in
            callback(result)
        }
        UIApplication.shared.keyWindow?.rootViewController?.present(viewController, animated: true, completion: nil)
    }
}
