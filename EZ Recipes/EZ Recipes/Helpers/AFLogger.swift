//
//  AFLogger.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 10/30/22.
//

import Alamofire

// Logs the network requests & responses
class AFLogger: EventMonitor {
    func requestDidResume(_ request: Request) {
        print("Request: \(request)")
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        print("Response: \(response)")
    }
}
