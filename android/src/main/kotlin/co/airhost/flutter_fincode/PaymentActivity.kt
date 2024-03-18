package co.airhost.flutter_fincode

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import co.airhost.flutter_fincode.databinding.ActivityPaymentBinding
import com.epsilon.fincode.fincodesdk.api.FincodeCallback
import com.epsilon.fincode.fincodesdk.config.FincodePaymentConfiguration
import com.epsilon.fincode.fincodesdk.entities.api.FincodeErrorResponse
import com.epsilon.fincode.fincodesdk.entities.api.FincodePaymentResponse
import com.epsilon.fincode.fincodesdk.enumeration.Authorization
import com.epsilon.fincode.fincodesdk.views.FincodeVerticalView


class PaymentActivity : AppCompatActivity(), FincodeCallback<FincodePaymentResponse> {
    private var completionCallback: ((Map<String, Any?>) -> Unit)? = null
    private var binding: ActivityPaymentBinding? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_payment)

        binding = ActivityPaymentBinding.inflate(layoutInflater)
        setContentView(binding!!.root)

        val vg: FincodeVerticalView = binding!!.fincodeView

        paymentVertical(vg)
    }

    private fun paymentVertical(vg: FincodeVerticalView) {
        val config = FincodePaymentConfiguration()
        config.authorization = Authorization.BEARER
        config.apiKey = "p_prod_ZTlkN2JkMzctZDY4Ni00ZDE4LTSample"
        config.apiVersion = "20211001"
        config.customerId = "c_HSZkCAxNS2_Sample"
        config.payType = "Card"
        config.accessId = "qazWSXrfvSample"
        config.id = "12345Sample"
        vg.initForPayment(config, this)
    }

    override fun onResponse(p0: FincodePaymentResponse) {
        completionCallback?.invoke(mapOf(
            "status" to "success",
            "message" to "Payment successfully."
        ))
        finish()
    }

    override fun onFailure(error: FincodeErrorResponse) {
        completionCallback?.invoke(mapOf(
            "status" to "failed",
            "message" to (error.errorInfo.list.firstOrNull()?.message ?: ""),
            "code" to error.statusCode
        ))
        finish()
    }
}
