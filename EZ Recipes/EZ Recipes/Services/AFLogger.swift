//
//  AFLogger.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 10/30/22.
//

import Alamofire
import OSLog
import RegexBuilder

/// Logs the network requests & responses
final class AFLogger: EventMonitor {
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? Constants.appName, category: "AFLogger")
    // Header checks should be case insensitive
    private let headersToRedact = ["authorization", "cookie"]
    private let fieldsToRedact = ["password"]
    private let MASK = "██"
    
    private func redact(_ headers: [String: String]) -> [String: String] {
        var redactedHeaders = headers
        
        for key in headers.keys {
            if headersToRedact.contains(key.lowercased()) {
                redactedHeaders[key] = MASK
            }
        }
        
        return redactedHeaders
    }
    
    private func redact(_ body: String) -> String {
        var redactedBody = body
        
        for field in fieldsToRedact {
            let oldFieldRegex = Regex {
                field
                "\":\""
                OneOrMore(CharacterClass.anyOf("\"").inverted) // [^\"]+
                "\""
            }
            
            redactedBody = redactedBody.replacing(oldFieldRegex, with: "\(field)\":\"\(MASK)\"")
        }
        
        return redactedBody
    }
    
    func requestDidResume(_ request: Request) {
        let urlRequest = request.request
        let method = urlRequest?.httpMethod
        let url = urlRequest?.url?.absoluteString
        var log = "[AF Request] Method: \(method ?? "") | URL: \(url ?? "")"
        
        if let headers = urlRequest?.allHTTPHeaderFields {
            log += " | Headers: \(redact(headers))"
        }
        
        if let bodyData = urlRequest?.httpBody, let body = String(data: bodyData, encoding: .utf8) {
            log += " | Data: \(redact(body))"
        }
        
        logger.debug("\(log)") // must use string interpolation
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        // Headers are already logged here
        logger.debug("[AF Response] Metrics: \(response.metrics)")
        
        let urlResponse = response.response
        let method = response.request?.httpMethod
        let url = urlResponse?.url?.absoluteString
        let status = urlResponse?.statusCode
        var log = "[AF Response] Method: \(method ?? "") | URL: \(url ?? "") | Status: \(status?.description ?? "")"
        
        if let bodyData = response.data, let body = String(data: bodyData, encoding: .utf8) {
            log += " | Data: \(redact(body))"
        }
        
        switch response.result {
        case .success:
            logger.debug("\(log)")
        case .failure(let error):
            logger.error("\(log) | Error: \(error.localizedDescription)")
        }
    }
}
