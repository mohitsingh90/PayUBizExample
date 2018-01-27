//
//  ViewController.swift
//  PayUBizExample
//
//  Created by MOHIT SINGH on 27/01/18.
//  Copyright © 2018 MOHIT SINGH. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var paymentParam: PayUModelPaymentParams!
    var hashes :PayUModelHashes!
    var PUSAhelper:PUSAHelperClass!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.paymentParam  = PayUModelPaymentParams()
        self.hashes  = PayUModelHashes()
        self.PUSAhelper = PUSAHelperClass()
    }

    @IBAction func clickToPayAction(_ sender: UIButton) {
        
        paymentParam.key = "gtKFFx"
        paymentParam.transactionID = "txnID20170220"
        paymentParam.amount = "100.0"
        paymentParam.productInfo = "Nokia"
        paymentParam.surl = "https://google.com/"
        paymentParam.furl = "https://facebook.com/"
        paymentParam.firstName = "Mohit"
        paymentParam.email = "test@gmail.com"
        paymentParam.environment = ENVIRONMENT_TEST
        paymentParam.udf1 = "udf1"
        paymentParam.udf2 = "udf2"
        paymentParam.udf3 = "udf3"
        paymentParam.udf4 = "udf4"
        paymentParam.udf5 = "udf5"
        paymentParam.offerKey = ""              // Set this property if you want to give offer:
        paymentParam.userCredentials = ""
        
        PUSAHelperClass.generateHash(fromServer: self.paymentParam, withCompletionBlock: { (hashes, errorString) in
            self.hashes = hashes
            self.paymentParam.hashes = hashes
            self.callPaymentGateway()
        })
    }
    func callPaymentGateway()  {
        
        let webServiceResponse :PayUWebServiceResponse = PayUWebServiceResponse()
        
        webServiceResponse.getPayUPaymentRelatedDetail(forMobileSDK: paymentParam, withCompletionBlock: { (paymentDetail, errString, extraParam) in
            
            if errString == nil {
                //  let payOptionVC: PUUIPaymentOptionVC =  loadVC("PUUIMainStoryBoard", strVCId: VC_IDENTIFIER_PAYMENT_OPTION) as! PUUIPaymentOptionVC
                
                let storyboard = UIStoryboard.init(name: "PUUIMainStoryBoard", bundle: nil)
                let payOptionVC: PUUIPaymentOptionVC = storyboard.instantiateViewController(withIdentifier: "PUUIPaymentOptionVC") as! PUUIPaymentOptionVC
                payOptionVC.paymentParam = self.paymentParam
                payOptionVC.paymentRelatedDetail = paymentDetail
                NotificationCenter.default.addObserver(self, selector: #selector(self.paymentResponseReceived(notify:)), name: NSNotification.Name(rawValue: kPUUINotiPaymentResponse), object: nil)
                self.navigationController?.pushViewController(payOptionVC, animated: true)
               
            }
            else{
                print("Failed to proceed for payment : \(String(describing: errString))")
            }
        })
    }
    @objc func paymentResponseReceived(notify:NSNotification) {
        print(notify)
    }

}

