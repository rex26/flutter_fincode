//
//  PaymentViewController.swift
//  flutter_fincode
//
//  Created by Matt on 2024/3/1.
//

import UIKit
import FincodeSDK
import Flutter

class PaymentViewController: UIViewController, ResultDelegate {
    @IBOutlet weak var fincodeVerticalView: FincodeVerticalView!
    
    var completionCallback: (([String: Any?]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let config = FincodePaymentConfiguration()
        config.authorizationPublic = .Bearer
        config.apiKey = "m_test_NmQzMWQ5ZDQtYzM3My00ZTZiLWI1MzEtZmY2N2U4YTlhOTJlYWE0ZmI5OTQtNDZlMi00ZmY0LWE2MWQtN2RhMTY3NjJmZmMwc18yNDAyMDU5MzA1Ng"
        config.apiVersion = "20211001"
        config.accessId = "accessId"
        config.id = "id"
        config.payType = "payType"
        config.customerId = "c_fjxcA88QTyCvkD4ijFv7qg"
        config.tds2RetUrl   =   "https:/xxxxx"
        config.tds2ChAccChange  =   "20221001"
        config.tds2ChAccDate    =   "20200501"
        config.tds2ChAccPwChange    =   "20210101"
        config.tds2NbPurchaseAccount    =   "5"
        config.tds2PaymentAccAge    =   "20200503"
        config.tds2ProvisionAttemptsDay =   "2"
        config.tds2ShipAddressUsage =   "20200512"
        config.tds2ShipNameInd  =   "01"
        config.tds2SuspiciousAccActivity    =   "02"
        config.tds2TxnActivityDay   =   "3"
        config.tds2TxnActivityYear  =   "30"
        config.tds2ThreeDsReqAuthData   =   "login-tds2-auth-data"
        config.tds2ThreeDsReqAuthMethod =   "03"
        config.tds2ThreeDsReqAuthTimestamp  =   "202110031213"
        config.tds2AddrMatch    =   "Y"
        config.tds2BillAddrCity =   "札幌"
        config.tds2BillAddrCountry  =   "392"
        config.tds2BillAddrLine1    =   "請求先住所1"
        config.tds2BillAddrLine2    =   "請求先住所2"
        config.tds2BillAddrLine3    =   "請求先住所3"
        config.tds2BillAddrPostCode =   "0650001"
        config.tds2BillAddrState    =   "北海道"
        config.tds2Email    =    "test@xxx.com"
        config.tds2HomePhoneCc  =   "+82"
        config.tds2HomePhoneNo  =   "0112223333"
        config.tds2MobilePhoneCc    =   "+84"
        config.tds2MobilePhoneNo    =   "5033337777"
        config.tds2WorkPhoneCc  =   "+86"
        config.tds2WorkPhoneNo  =   "012088887777"
        config.tds2ShipAddrCity =   "港区"
        config.tds2ShipAddrCountry  =   "356"
        config.tds2ShipAddrLine1    =   "出荷先住所1"
        config.tds2ShipAddrLine2    =   "出荷先住所2"
        config.tds2ShipAddrLine3    =   "出荷先住所3"
        config.tds2ShipAddrPostCode =   "0016789"
        config.tds2ShipAddrState    =   "東京"
        config.tds2DeliveryEmailAddress =    "sample@ss.com"
        config.tds2DeliveryTimeframe    =   "04"
        config.tds2GiftCardAmount   =   "5560"
        config.tds2GiftCardCount    =   "37"
        config.tds2GiftCardCurr =   "392"
        config.tds2PreOrderDate =   "20221125"
        config.tds2PreOrderPurchaseInd  =   "02"
        config.tds2ReorderItemsInd  =   "01"
        config.tds2ShipInd  =   "07"
        config.tds2RecurringExpiry  =   "20221115"
        config.tds2RecurringFrequency   =   "100"
        
        fincodeVerticalView.configuration(config, delegate: self)
    }
    
    func success(_ result: FincodeSDK.FincodeResponse) {
        completionCallback?([
            "status": "success",
            "message": "Payment successfully.",
        ])
        dismiss(animated: true)
    }
    
    func failure(_ result: FincodeSDK.FincodeErrorResponse) {
        completionCallback?([
            "status": "failed",
            "message": result.errors.first?.message ?? "null",
            "code": result.statusCode ?? "-1",
        ])
        dismiss(animated: true)
    }
}
