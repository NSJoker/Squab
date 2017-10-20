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

typealias returnBlock = (Data?, String?) -> Void

private let timeOutInterval:Double = 30.0

class SquabDataCenter: NSObject {
    
    var domain: String = ""
    
    class var sharedInstance: SquabDataCenter {
        struct Static {
            static let instance: SquabDataCenter = SquabDataCenter()
        }
        return Static.instance
    }
    
    func sendRequest(connectingURL:String, httpMethod:HttpMethod, parameters:[String:Any]?, returnBlock: @escaping returnBlock) {
        let url = domain + connectingURL
        
        if url.isEmpty {
            print("Unable to connect to API.\nThe base url and the connecting url are empty. Use setDomain: method to set a base url or provide an endurl in this method call to connect to the API");
            return
        }
        
        guard let connectingURL = URL.init(string: url) else {
            return
        }
        
        var request = getURLRequestWitPrefilledHeaders(connectingURL: connectingURL)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        SquabProgressIndicator.sharedInstance.show(with: "")
        
        if let parameters = parameters {
            
            let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            request.httpBody = jsonData
        }
        request.httpMethod = httpMethod.rawValue
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeOutInterval
        configuration.timeoutIntervalForResource = timeOutInterval
        
        let session = URLSession(configuration: configuration)
        
        session.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                SquabProgressIndicator.sharedInstance.hide()
                
                if let data = data {
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
                    returnBlock(nil, "Something went wrong. Unable to parse the response.")
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

/*
 
 //Make the DummyJSONClass confirm to Decodable protocol
 
 SquabDataCenter.sharedInstance.sendRequest(connectingURL: "jsondecodable/course", httpMethod: .GET, parameters: nil) { (data, errorMessage) in
 
 if let data = data {
 do {
 let course = try JSONDecoder().decode(DummyJSONClass.self, from: data)
 print("course = \(course.name ?? "XOXO")")
 }
 catch let jsonError {
 print("Some jsonError happened! \(jsonError.localizedDescription)")
 self.showErrorHud(position: .top, message: jsonError.localizedDescription, bgColor: .red, isPermanent: false)
 }
 }
 else {
 self.showErrorHud(position: .top, message: errorMessage ?? "", bgColor: .red, isPermanent: false)
 }
 }
 */
