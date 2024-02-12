//
//  RecipeFilterEncoder.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/11/24.
//

import Foundation
import Alamofire

struct CustomBoolEncoder: ParameterEncoder {
    func encode<Parameters>(_ parameters: Parameters?, into request: URLRequest) throws -> URLRequest where Parameters : Encodable {
        var request = request
        guard let parameters = parameters else { return request }
        let mirror = Mirror(reflecting: parameters)
        var queryItems: [URLQueryItem] = []
        
        for case let (key?, value) in mirror.children {
            // Exclude query if it's empty
            if key == "query", let value = value as? String, !value.isEmpty {
                queryItems.append(URLQueryItem(name: key, value: value))
            }
            // Add bool parameters if they're true
            else if key != "query", let boolValue = value as? Bool, boolValue {
                queryItems.append(URLQueryItem(name: key, value: nil))
            }
        }

        guard let urlString = request.url?.absoluteString else { return request }
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = queryItems
        request.url = urlComponents?.url
        
        return request
    }
}

struct RecipeFilterEncoder: ParameterEncoder {
    let boolEncoder = CustomBoolEncoder()
    let encoder: URLEncodedFormParameterEncoder
    
    func encode<Parameters>(_ parameters: Parameters?, into request: URLRequest) throws -> URLRequest where Parameters : Encodable {
        let urlRequest = try encoder.encode(parameters, into: request)
        return try boolEncoder.encode(parameters, into: urlRequest)
    }
}
