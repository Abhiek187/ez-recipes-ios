//
//  AFLogger.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 10/30/22.
//

import Alamofire
import OSLog

// Logs the network requests & responses
final class AFLogger: EventMonitor {
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? Constants.appName, category: "AFLogger")
    
    func requestDidResume(_ request: Request) {
        logger.debug("Request: \(request)")
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        logger.debug("Response: \(response)")
    }
}
