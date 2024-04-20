//
//  PrivacyPolicyVC.swift
//  Skazule-Employee
//
//  Created by Anita Singh on 25/01/24.
//

import UIKit
import WebKit

class PrivacyPolicyVC: UIViewController {

//MARK: IBOutlets
@IBOutlet weak var customNavigationBar: CustomNavigationBar!
@IBOutlet weak var webView: WKWebView!
    
//MARK: VAriables
    
    var isFrom = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        var urls = ""
       
        urls = isFrom == "Privacy" ? "https://skazule.com/privacy-policy.html" : "https://skazule.com/terms-service.html"
        
        let url = URL(string: urls)
        webView.scrollView.setZoomScale(1, animated: false)
        webView.load(URLRequest(url: url!))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
 //       self.navigationController?.navigationBar.isHidden = true
    }
    private func configureNavigationBar(){
        self.customNavigationBar.titleLabel.text = ""
        customNavigationBar.customRightBarButton.isHidden = true
    }
    
}
