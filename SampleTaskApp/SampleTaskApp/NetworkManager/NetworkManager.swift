//
//  NetworkManager.swift
//  SampleTaskApp
//
//  Created by Pravin's Mac M1 on 10/04/24.
//

import Foundation
import ProgressHUD
import Alamofire
import UIKit

class NetworkManager: NSObject {
    
    class func apiCall(serviceName: String, apiType: HTTPMethod, param: [String: Any]?, showLoader: Bool? = nil, completionClosure: @escaping (HTTPURLResponse?, Data?, Error?) -> Void) {
        
        if isInternetAvailable() {
            
            var isShowLoader = true
            
            if let show = showLoader, !show {
                isShowLoader = false
            }
            
            if isShowLoader {
                startLoader(title: "Please wait...")
            }
            
            let manager = Alamofire.Session.default
            manager.session.configuration.timeoutIntervalForRequest = 10
            manager.session.configuration.urlCache = nil
            manager.session.configuration.urlCache?.removeAllCachedResponses()
            
            print("Request URL: \(serviceName)")
            
            manager.request(serviceName, method: apiType, parameters: param, encoding: JSONEncoding.default).responseJSON { response in
                
                stopLoader()
                print("Response is: ", response)
                
                switch response.result {
                case .success(_):
                    DispatchQueue.main.async {
                        completionClosure(response.response, response.data, response.error)
                    }
                case .failure(let error):
                    print(error)
                    DispatchQueue.main.async {
                        completionClosure(response.response, response.data, response.error)
                    }
                }
            }
        }
    }
}


//MARK: - Helper methods for api call. -

extension NetworkManager {
    
    //Check internet connection
    class func isInternetAvailable() -> Bool {
        let reach = Reachability()!
        if(!reach.isReachable) {
            Common.showAlert(title: "Alert!", message: "No internet connection available, Please check your internet connection.")
        }
        return reach.isReachable
    }
    
    //MARK: - Loader
    class func startLoaderWithoutTitle() {
        ProgressHUD.animationType = .pacmanProgress
    }
    
    class func startLoader(title: String) {
        
        // Set custom properties for ProgressHUD
        ProgressHUD.animationType = .circleRippleMultiple
        ProgressHUD.colorHUD = .black
        ProgressHUD.colorBackground = .clear
        ProgressHUD.colorProgress = .white
        ProgressHUD.colorAnimation = .black
        
        //ProgressHUD.banner("Banner title", "Banner message to display.")
        ProgressHUD.animate("Please wait...", interaction: false)
    }
    
    class func stopLoader() {
        ProgressHUD.dismiss()
    }
    
}
