package co.airhost.flutter_fincode

import android.content.Context
import android.content.Intent
import androidx.annotation.NonNull
import com.epsilon.fincode.fincodesdk.Repository.FincodeCardOperateRepository
import com.epsilon.fincode.fincodesdk.Repository.FincodePaymentRepository
import com.epsilon.fincode.fincodesdk.api.FincodeCallback
import com.epsilon.fincode.fincodesdk.entities.api.*
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterFincodePlugin */
class FlutterFincodePlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private var context: Context? = null
    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_fincode")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "payment" -> {
                payment(call.arguments as Map<String, String>, result)
            }
            "cardInfoList" -> {
                val args = call.arguments as String
                cardInfoList(args, result)
            }
            "registerCard" -> {
                registerCard(call.arguments as Map<String, String>, result)
            }
            "showPaymentSheet" -> {
                showPaymentSheet(result)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun payment(paymentInfo: Map<String, String>, @NonNull result: Result) {
        val header = hashMapOf(
            "Content-Type" to "application/json",
            "Authorization" to "Bearer m_test_NmQzMWQ5ZDQtYzM3My00ZTZiLWI1MzEtZmY2N2U4YTlhOTJlYWE0ZmI5OTQtNDZlMi00ZmY0LWE2MWQtN2RhMTY3NjJmZmMwc18yNDAyMDU5MzA1Ng",
            "Tenant-Shop-Id" to "s_24020521229"
        )
        val request = FincodePaymentRequest().apply {
            payType = paymentInfo["payType"]
            accessId = paymentInfo["accessId"]
            orderId = paymentInfo["id"] ?: ""
            customerId = paymentInfo["customerId"]
            cardId = paymentInfo["cardId"]
            method = paymentInfo["method"]
        }
        val orderId = paymentInfo["id"] ?: ""
        FincodePaymentRepository.getInstance()?.payment(
            header,
            orderId,
            request,
            object : FincodeCallback<FincodePaymentResponse> {
                override fun onResponse(response: FincodePaymentResponse) {
                    result.success(mapOf(
                        "status" to "success",
                        "message" to "Payment successful.",
                        "customerId" to response.customerId,
                        "id" to response.orderId,
                        "cardNo" to response.cardNo,
                        "expire" to response.expire,
                        "holderName" to response.holderName,
                        "created" to response.created,
                        "updated" to response.updated,
                        "brand" to response.cardBrand
                    ))
                }

                override fun onFailure(error: FincodeErrorResponse) {
                    result.success(mapOf(
                        "status" to "failed",
                        "message" to (error.errorInfo.list.firstOrNull()?.message ?: ""),
                        "code" to error.statusCode
                    ))
                }
            }
        )
    }


    private fun cardInfoList(customerId: String, @NonNull result: Result) {
        val header = hashMapOf(
            "Content-Type" to "application/json",
            "Authorization" to "Bearer m_test_NmQzMWQ5ZDQtYzM3My00ZTZiLWI1MzEtZmY2N2U4YTlhOTJlYWE0ZmI5OTQtNDZlMi00ZmY0LWE2MWQtN2RhMTY3NjJmZmMwc18yNDAyMDU5MzA1Ng",
            "Tenant-Shop-Id" to "s_24020521229",
        )
        FincodeCardOperateRepository.getInstance()?.getCardInfoList(header, customerId, object : FincodeCallback<FincodeCardInfoListResponse> {
            override fun onResponse(response: FincodeCardInfoListResponse) {
                val cardList = response.cardInfoList.map { cardInfo ->
                    mapOf(
                        "id" to cardInfo.cardId,
                        "cardNo" to cardInfo.cardNo,
                        "brand" to cardInfo.cardBrand,
                        "holderName" to cardInfo.holderName,
                        "expire" to cardInfo.expire
                    )
                }
                result.success(mapOf(
                    "status" to "success",
                    "message" to "successfully obtained.",
                    "data" to cardList
                ))
            }

            override fun onFailure(error: FincodeErrorResponse) {
                result.success(mapOf(
                    "status" to "failed",
                    "message" to (error.errorInfo.list.firstOrNull()?.message ?: ""),
                    "code" to error.statusCode
                ))
            }

        })
    }

    private fun registerCard(cardInfo: Map<String, String>, @NonNull result: Result) {
        val header = hashMapOf(
            "Content-Type" to "application/json",
            "Authorization" to "Bearer m_test_NmQzMWQ5ZΩDQtYzM3My00ZTZiLWI1MzEtZmY2N2U4YTlhOTJlYWE0ZmI5OTQtNDZlMi00ZmY0LWE2MWQtN2RhMTY3NjJmZmMwc18yNDAyMDU5MzA1Ng",
            "Tenant-Shop-Id" to "s_24020521229",
        )
        val customerId = cardInfo["customerId"] ?: ""
        val request = FincodeCardRegisterRequest().apply {
            defaltFlag = "1"
            cardNo = cardInfo["cardNo"]
            expire = cardInfo["expire"]
            holderName = cardInfo["holderName"]
            securityCode = cardInfo["securityCode"]
        }

        FincodeCardOperateRepository.getInstance()?.cardRegister(header, customerId, request, object : FincodeCallback<FincodeCardRegisterResponse> {
            override fun onResponse(response: FincodeCardRegisterResponse) {
                result.success(mapOf(
                    "status" to "success",
                    "message" to "Registered successfully.",
                    "customerId" to response.customerId,
                    "id" to response.cardId,
                    "cardNo" to response.cardNo,
                    "expire" to response.expire,
                    "holderName" to response.holderName,
                    "created" to response.created,
                    "updated" to response.updated,
                    "type" to response.cardType,
                    "brand" to response.cardBrand,
                ))
            }

            override fun onFailure(error: FincodeErrorResponse) {
                result.success(mapOf(
                    "status" to "failed",
                    "message" to (error.errorInfo.list.firstOrNull()?.message ?: ""),
                    "code" to error.statusCode
                ))
            }

        })
    }

    private fun showPaymentSheet(@NonNull result: Result) {
        if (context == null) {
            result.success(mapOf(
                "status" to "failed",
                "message" to "Context is null."
            ))
            return
        }
        val intent = Intent(context, PaymentActivity::class.java)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        context?.startActivity(intent)
        result.success(mapOf(
            "status" to "success",
            "message" to "Payment sheet displayed."
        ))
    }
}
