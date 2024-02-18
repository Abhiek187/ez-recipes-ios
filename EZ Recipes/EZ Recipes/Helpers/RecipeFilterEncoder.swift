//
//  RecipeFilterEncoder.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/11/24.
//

import Foundation
import Alamofire

extension URLQueryItem {
    fileprivate func toEncodable() -> EncodableParameter {
        return EncodableParameter(name: self.name, value: self.value)
    }
}

private struct EncodableParameter: Encodable {
    let name: String
    let value: String?
}

private struct CustomBoolEncoder: ParameterEncoder {
    func encode<Parameters>(_ parameters: Parameters?, into request: URLRequest) throws -> URLRequest where Parameters : Encodable {
        var request = request
        guard let urlString = request.url?.absoluteString else { return request }
        // Conform parameters to Sequence (to iterate)
        guard let parameters = parameters as? [EncodableParameter] else { return request }
        
        var queryItems: [URLQueryItem] = []
        let boolParams = ["vegetarian", "vegan", "gluten-free", "healthy", "cheap", "sustainable"]
        
        for parameter in parameters {
            let name = parameter.name
            guard let value = parameter.value else { continue }
            
            switch name {
            case "query":
                // Remove query if it's empty
                if !value.isEmpty {
                    queryItems.append(URLQueryItem(name: name, value: value))
                }
            case _ where boolParams.contains(name):
                // Add bool parameters if they're true
                if value == "1" {
                    queryItems.append(URLQueryItem(name: name, value: nil))
                }
            default:
                // Add all other query params by default
                queryItems.append(URLQueryItem(name: name, value: value))
            }
        }
        
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
        
        // Pass the encoded parameters to the 2nd encoder
        guard let urlString = urlRequest.url?.absoluteString else { return urlRequest }
        let urlComponents = URLComponents(string: urlString)
        // Convert the query parameters to an Encodable type
        let newParameters = urlComponents?.queryItems?.map { $0.toEncodable() }
        return try boolEncoder.encode(newParameters, into: urlRequest)
    }
}
