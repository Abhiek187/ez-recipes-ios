//
//  RecipeFilterEncoder.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/11/24.
//

import Foundation
import Alamofire

private struct CustomBoolEncoder: ParameterEncoder {
    func encode<Parameters>(_ parameters: Parameters?, into request: URLRequest) throws -> URLRequest where Parameters : Encodable {
        var request = request
        guard let parameters else { return request }
        // Use reflection to conform parameters to Sequence (to iterate)
        let mirror = Mirror(reflecting: parameters)
        var queryItems: [URLQueryItem] = []
        let boolParams = ["vegetarian", "vegan", "gluten-free", "healthy", "cheap", "sustainable"]
        
        for case let (key?, value) in mirror.children {
            // Add bool parameters if they're true
            if boolParams.contains(key), let boolValue = value as? Bool, boolValue {
                queryItems.append(URLQueryItem(name: key, value: nil))
            } else if let value = value as? String {
                queryItems.append(URLQueryItem(name: key, value: value))
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
    fileprivate let boolEncoder = CustomBoolEncoder()
    let baseEncoder: URLEncodedFormParameterEncoder
    
    func encode<Parameters>(_ parameters: Parameters?, into request: URLRequest) throws -> URLRequest where Parameters : Encodable {
        let urlRequest = try baseEncoder.encode(parameters, into: request)
        return try boolEncoder.encode(parameters, into: urlRequest)
    }
}
