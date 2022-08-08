//
//  NetworkError.swift
//  FPEU
//
//  Created by son on 08/08/2022.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case apiFailed(statusCode: Int?, message: String)
    case timeout(message: String?)
    case other(error: Error)
    
    var errorDescription: String? {
        switch self {
        case .apiFailed(statusCode: _, message: let message):
            return message
        case .timeout(let message):
            return message
        case .other(let error):
            return error.localizedDescription
        }
    }
    
    var errorCode: String {
        switch self {
        case .apiFailed(let code, _):
            return code != nil ? "\(code!)" : ""
        case .timeout:
            return ""
        case .other(let error):
            return "\((error as NSError).code)"
        }
    }
}
