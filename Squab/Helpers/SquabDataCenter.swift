//
//  SquabDataCenter.swift
//  Squab
//
//  Created by Chandrachudh on 20/10/17.
//  Copyright © 2017 NSJoker. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

enum HttpMethod : String {
    case  GET
    case  POST
    case  DELETE
    case  PUT
}

typealias returnBlock = (Any?, String?) -> Void

private let timeOutInterval:Double = 30.0

class SquabDataCenter: NSObject {
    
    var domain: String = ""
    
    class var sharedInstance: SquabDataCenter {
        struct Static {
            static let instance: SquabDataCenter = SquabDataCenter()
        }
        return Static.instance
    }
    
    func sendRequest(connectingURL:String, httpMethod:HttpMethod, parameters:[String:Any]?, shoulShowLoadingIndicator:Bool, returnBlock: @escaping returnBlock) {
        let url = domain + connectingURL
        
        if url.isEmpty {
            print("Unable to connect to API.\nThe base url and the connecting url are empty. Use setDomain: method to set a base url or provide an endurl in this method call to connect to the API");
            return
        }
        
        guard let URL = URL.init(string: url) else {
            return
        }
        
        var request = getURLRequestWitPrefilledHeaders(connectingURL: URL)
        
        if shoulShowLoadingIndicator {
            SquabProgressIndicator.sharedInstance.show(with: "")
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        if let parameters = parameters {
            
            let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            request.httpBody = jsonData
        }
        request.httpMethod = httpMethod.rawValue
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeOutInterval
        configuration.timeoutIntervalForResource = timeOutInterval
        
        let session = URLSession(configuration: configuration)
        
        print("Connecting URL = \(url)")
        
        session.dataTask(with: request) { (data, response, error) in
            
            
            DispatchQueue.main.async {
                if shoulShowLoadingIndicator {
                    SquabProgressIndicator.sharedInstance.hide()
                }
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                if let data = data {
                    //print("response data = \(String.init(data: data, encoding: .utf8) ?? "WHAT HAPPEND HERE?")")
                    if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {//SUCCESS SCENARIO
                        returnBlock(data, nil)
                    } else {//FAILURE SCENARIO
                        guard let error = error else {
                            returnBlock(nil, "Something went wrong")
                            return
                        }
                        returnBlock(nil, error.localizedDescription)
                    }
                }
                else {//FAILURE SCENARIO
                    print("error = \(error?.localizedDescription ?? "Something went wrong")")
                    returnBlock(nil, error?.localizedDescription)
                }
            }
        }.resume()
    }
    
    private func getURLRequestWitPrefilledHeaders(connectingURL:URL) -> URLRequest {
        var request = URLRequest.init(url: connectingURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
}
