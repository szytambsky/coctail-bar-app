//
//  ApiError.swift
//  coctailbar
//
//  Created by Szymon Tamborski on 28/07/2022.
//

import Foundation

enum APIError: Error, CustomStringConvertible {
    case badURL
    case badResponse(statusCode: Int)
    case url(URLError?)
    case parsing(DecodingError?)
    case unknown
    
    /// User feedback
    var localizedDescription: String {
        switch self {
        case .badURL, .parsing, .unknown:
            return "Sorry, something went wrong."
        case .badResponse(statusCode: _):
            return "Sorry, the connection to our server failed."
        case .url(let error):
            return "\(debugPrint(error ?? "Something went wrong"))"
        }
    }
    
    /// Informations for debugging
    var description: String {
        switch self {
        case .badURL: return "invalid url"
        case .unknown: return "unknown error"
        case .url(let error):
            return error?.localizedDescription ?? "url session error"
        case .parsing(let error):
            return "parsing error \(debugPrint(error ?? "Something with parsing went wrong"))"
        case .badResponse(statusCode: let statusCode):
            return "bad response with status code: \(statusCode)"
        }
    }
}
