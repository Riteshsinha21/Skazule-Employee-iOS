//
//  ViewDocumentsVC.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 5/30/23.
//

import UIKit
import WebKit

class ViewDocumentsVC: UIViewController {
    
//MARK: IBOutlets

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var customNavigationBar: CustomNavigationBar!
    @IBOutlet weak var noDataView: UIView!
    
//MARK: Variables
    
    var urls = ""
    var isDocAvailable = true
    var docName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        if self.isDocAvailable{
       
            self.noDataView.isHidden = true
            self.webView.isHidden = false
            //let webViews = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.webView.frame.size.height))
           // self.view.addSubview(webView)
           /// let url = URL(string: URL)
        let url = URL(string: urls)
        webView.scrollView.setZoomScale(1, animated: false)
        let requestObj = URLRequest(url: url! as URL)
            webView.load(URLRequest(url: url!))
        }else{
            self.noDataView.isHidden = false
            self.webView.isHidden = true
        }
    }
    private func configureNavigationBar(){
        self.customNavigationBar.titleLabel.text = docName
        customNavigationBar.customRightBarButton.isHidden = true
//        customNavigationBar.customRightBarButton.addTarget(self, action: #selector(didTapNotificationButton), for: .touchUpInside)
    }
}
