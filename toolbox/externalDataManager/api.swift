//
//  api.swift
//  toolbox
//
//  Created by Cesar Guasca on 12/07/21.
//

import Foundation
import Alamofire
import SwiftyJSON

open class CoreApi {
    var listenerGetToken: ListenerGetToken?
    var listenerGetCarrousel: ListenerGetCarrousell?
    
    func getToken() {
        let headers: HTTPHeaders = [
            .acceptEncoding("UTF-8"),
            .contentType("application/json"),
            .accept("application/json")
        ]
        var dic:[String: String] = [:]
        dic["sub"] =  "ToolboxMobileTest"
        let jsonData = try! JSONEncoder().encode(dic)
        let jsonDebugg = String(data: jsonData, encoding: String.Encoding.utf8)
        print("json GETTOKEN: \(jsonDebugg!)")
        URLCache.shared.removeAllCachedResponses()
        let url = URL(string: "https://echo-serv.tbxnet.com/v1/mobile/auth")
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.headers = headers
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    self.listenerGetToken?.failureGetToken("json GETTOKEN ERROR \(error)")
                    return
                }
                guard let data = data else {return}
                do{
                    let resp = try JSONDecoder().decode(Auth.self, from: data)
                    
                    print("json GETTOKEN RESPONSE: \(try! JSONEncoder().encode(resp))")
                    self.listenerGetToken?.successGetToken(resp)
                }catch let jsonErr {
                    self.listenerGetToken?.failureGetToken("json GETTOKEN ERROR SERIALIZE - ERR: \(jsonErr)")
                }
        }
        task.resume()
    }
    
    func getCarrousell(type: String, token: String){
        let headers: HTTPHeaders = [
            .authorization("\(type) \(token)")
        ]
        let url = URL(string: "https://echo-serv.tbxnet.com/v1/mobile/data")
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        request.headers = headers
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    self.listenerGetCarrousel?.failureGetCarrousell("json DATA ERROR \(error)")
                    return
                }
                guard let data = data else {return}
                do{
                    let resp = try JSONDecoder().decode([Carrousell].self, from: data)
                    
                    print("json DATA RESPONSE: \(try! JSONEncoder().encode(resp))")
                    self.listenerGetCarrousel?.successGetCarrousell(resp)
                }catch let jsonErr {
                    self.listenerGetCarrousel?.failureGetCarrousell("json DATA ERROR SERIALIZE - ERR: \(jsonErr)")
                }
        }
        task.resume()
    }
}
