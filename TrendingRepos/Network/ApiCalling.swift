//
//  ApiCalling.swift
//  Jadeer
//
//  Created by taha hamdi on 1/6/20.
//  Copyright © 2020 taha hamdi. All rights reserved.
//
import Foundation
import UIKit
import Alamofire
import SwiftyJSON
enum RequestContentType: String {
    case json = "application/json"
    case urlencoded  = "application/x-www-form-urlencoded"
}
class ApiCalling {
    class func request (requestUrl url : String,
                        httpMethod : HTTPMethod = .post ,
                        paramter : [String : Any]? = nil ,
                        contentType :String = RequestContentType.urlencoded.rawValue ,
                        Result:@escaping(_ result : Any? ,_ responseCode : Int , _ errorMessage : Any?)->()) {
        
        let headers :HTTPHeaders  = ["Authorization": "Basic \(Constant.base64LoginString)",
                                    "Content-Type" : contentType,
                                    "Accept-Language":Helper.getCurrentLanguage(),
                                    "Accept-Country":"eg",
                                    "x-access-token" : Helper.getFromDefault(key: "token") ]
        let loadview = Loading()
        loadview.loading()
        //print("ApiCalling ------------->",Helper.getCurrentLanguage())
        
        let date = Date()
        
        PrintHelper.logNetwork("""
            🙇‍♂️ \(httpMethod.rawValue.uppercased()) '\(url)':
            📝 Request headers = \(headers.dictionary.json )
            📝 Request Body = \(paramter?.json ?? "No Parameters")
            """ )
         
        let manager = Alamofire.Session.default
        manager.session.configuration.timeoutIntervalForRequest = 15
        //manager.session.configuration.timeoutIntervalForResource = 15
        
        AF.request( url ,
                    method: httpMethod ,
                    parameters: paramter ,
                    encoding: URLEncoding.default  ,
                    headers: headers )
            //            .validate(statusCode: 200..<400)
            .responseJSON(completionHandler: {
                
                response in
                loadview.stopAnimating()
                let statusCode = response.response?.statusCode
                
                switch response.result
                {
                case .failure(let error) :
                    //print("> Error on Response JSON " , error.localizedDescription)
                    let errorMessage = "\(error.localizedDescription)"
                    PrintHelper.logNetwork("""
                        ❌ Error in response: \(response.request?.httpMethod?.uppercased() ?? "") '\(url)' (\(response.response?.statusCode ?? 0), \(response.result)):
                        ❌ Error: \(error)
                        ⬇️ Response headers = \(response.response?.allHeaderFields.json ?? "No Headers")
                        """ )
                      
                    guard let code = statusCode, statusCode != 408 else { // timeout request
                        Result(nil , statusCode ?? 0, errorMessage)
//                        if let topVC = Helper.getCurrentViewController(), !topVC.isKind(of: NoInternertVC.self)  {
//                             Helper.showInternetMessage()
//                        }
                        
                        return
                    }
                    
                    Result(nil , code, errorMessage)
                    
                    return
                case .success(let requestResult):
                    //print("///////////////////---->",JSON(requestResult))
                    guard let data = response.data else { return }
                    PrintHelper.logNetwork("""
                        ✅ Response: \(response.request?.httpMethod?.uppercased() ?? "") '\(url)':
                        🧾 Status Code: \(response.response?.statusCode ?? 0), 💾 \(data), ⏳ time: \(Date().timeIntervalSince(date))
                        ⬇️ Response headers = \(response.response?.allHeaderFields.json ?? "No Headers")
                        ⬇️ Response Body = \(String(data: data, encoding: String.Encoding.utf8) ?? "")
                        """ )
                     
                    if statusCode == 200 {
                        Result(requestResult, statusCode ?? 0 , nil)
                    } else {
                        do {
                            guard let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {return}
                            
                            Result(requestResult, statusCode ?? 0 , jsonResponse["msg"] ?? "")
                            
                            if statusCode == 421 {
//                                if let topVC = Helper.getCurrentViewController(), !topVC.isKind(of: BlockedViewController.self)  {
//                                     Helper.showBlockedMessage((jsonResponse["msg"] as? String) ?? "")
//                                }
                                return
                            } else if statusCode == 403 { // Unauthorized token.
                                if !Helper.getFromDefault(key: "token").isEmpty ||  Helper.getFromDefault(key: "token") != ""  {
//                                    if let topVC = Helper.getCurrentViewController(), !topVC.isKind(of: BlockedViewController.self)  {
//                                        Helper.showBlockedMessage("You are not authorized, try to login again.".localized)
//                                    }
                                    return
                                }
                            }  
                            
                        } catch let jsonErr {
                            print(jsonErr.localizedDescription)
                            Result(requestResult, statusCode ?? 0 , jsonErr.localizedDescription)
                        }
                    }
                    
                    return
                    
                    
                }
            })
    }
    
}
extension String {
    func base64Encoded() -> String {
        return (data(using: .utf8)?.base64EncodedString())!
    }
    
    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

class PrintHelper {
    
    static func logNetwork<T>(_ items: T, separator: String = " ", terminator: String = "\n") {
        print("""
            \n===================== 📟 ⏳ 📡 =========================
            \(items)
            ======================= 🚀 ⌛️ 📡 =========================
            """, separator: separator, terminator: terminator)
    }
}

extension Dictionary {
    var json: String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? "Not a valid JSON"
        } catch {
            return "Not a valid JSON"
        }
    }
}
