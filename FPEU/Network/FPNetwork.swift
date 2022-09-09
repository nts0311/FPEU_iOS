//
//  FPNetwork.swift
//  FPEU
//
//  Created by son on 08/08/2022.
//

import Foundation
import Alamofire
import RxSwift

public class FPNetwork {
    
    private static let isDebug = true
    
    //public static let networkErrorMessage = "Có lỗi xảy ra, vui lòng thử lại sau."
    private static let timeoutErrorMessage = "Request timeout! Please try again later."
    
    private static let manager = Alamofire.Session.default
    private static let queue = DispatchQueue(label: "API", attributes: .concurrent)
    
    public static func makeRequest(
        method: HTTPMethod,
        otherUrl: String? = nil,
        endpoint: String,
        params: [String: Any]?,
        success: @escaping (_ data: Data) -> Void,
        failure: @escaping (_ code: Int?, _ message: String) -> Void,
        timeout: @escaping (_ message: String) -> Void
    ) {
        
        let url = otherUrl == nil ? ServiceUrl.baseUrl + endpoint : otherUrl! + endpoint
        let headers = buildRequestHeaders()
        
        let encoding: ParameterEncoding = method == .post ? JSONEncoding.default : URLEncoding.default

        manager.session.configuration.timeoutIntervalForRequest = 30
        manager.request(url, method: method, parameters: params, encoding: encoding, headers: headers).validate(statusCode: 200...499).responseData(queue:queue, completionHandler: { dataResponse in
            if isDebug {
                print("\n===> Request URL : \(dataResponse.request?.url?.absoluteString ?? "")")
                print(params)
                print("Header = ", dataResponse.request?.allHTTPHeaderFields)
            }
            switch dataResponse.result {
                case .success:
                    if let data = dataResponse.data {
                        if isDebug {
                            debugData(data)
                        }
                        
                        if !isSessionExpired(data) {
                            success(data)
                        } else {
                            NotificationCenter.default.post(name: .sessionExpired, object: nil, userInfo: nil)
                        }
                
                    } else {
                        failure(nil, networkErrorMessage)
                    }

                case .failure(let error):
                    if error._code == NSURLErrorTimedOut {
                        timeout(timeoutErrorMessage)
                    } else {
                        failure(error._code, networkErrorMessage)
                    }
            }
        })
    }
    
    public static func get(
        otherUrl: String? = nil,
        endpoint: String,
        params: [String: Any]?,
        success: @escaping (_ data: Data) -> Void,
        failure: @escaping (_ code: Int?, _ message: String) -> Void,
        timeout: @escaping (_ message: String) -> Void
    ) {
        makeRequest(method: .get, otherUrl: otherUrl, endpoint: endpoint, params: params, success: success, failure: failure, timeout: timeout)
    }
    
    public static func post(
        otherUrl: String? = nil,
        endpoint: String,
        params: [String: Any]?,
        success: @escaping (_ data: Data) -> Void,
        failure: @escaping (_ code: Int?, _ message: String) -> Void,
        timeout: @escaping (_ message: String) -> Void
    ) {
        makeRequest(method: .post, otherUrl: otherUrl, endpoint: endpoint, params: params, success: success, failure: failure, timeout: timeout)
    }
    
}

extension FPNetwork {
    public static func makeRequestSingle(
        method: HTTPMethod,
        otherUrl: String? = nil,
        endpoint: String,
        params: [String: Any]?
    ) -> Single<Data> {
        return Single.create {single in
            
            self.makeRequest(method:method, otherUrl: otherUrl, endpoint: endpoint, params: params) {data in
                single(.success(data))
            } failure:  { code, message in
                single(.success(Data()))
            } timeout: { message in
                single(.success(Data()))
            }
            
            return Disposables.create()
        }
        
    }
    
    public static func makeRequestSingle<T: Decodable>(
        method: HTTPMethod,
        otherUrl: String? = nil,
        endpoint: String,
        params: [String: Any]?
    ) -> Single<T?> {
        return self.makeRequestSingle(method: method, otherUrl: otherUrl, endpoint: endpoint, params: params)
            .map {data in
                do {
                    return try JSONDecoder().decode(T.self, from: data) as T
                } catch {
                   return nil
                }
            }.observe(on: MainScheduler.instance)
    }
    
    public static func singleGet<T: Decodable>(
        otherUrl: String? = nil,
        endpoint: String,
        params: [String: Any]?
    ) -> Single<T?> {
        return self.makeRequestSingle(method: .get, endpoint: endpoint, params: params)
    }
    
    public static func singlePost<T: Decodable>(
        otherUrl: String? = nil,
        endpoint: String,
        params: [String: Any]?
    ) -> Single<T?> {
        return self.makeRequestSingle(method: .post, endpoint: endpoint, params: params)
    }
    
    public static func singlePost<T: Decodable>(_ T: T.Type,
        otherUrl: String? = nil,
        endpoint: String,
        params: [String: Any]?
    ) -> Single<T?> {
        return self.makeRequestSingle(method: .post, endpoint: endpoint, params: params)
    }
    
    public static func singleGet<T: Decodable>(_ T: T.Type,
        otherUrl: String? = nil,
        endpoint: String,
        params: [String: Any]?
    ) -> Single<T?> {
        return self.makeRequestSingle(method: .get, endpoint: endpoint, params: params)
    }
}

extension FPNetwork {
    static func buildRequestHeaders() -> HTTPHeaders {
        var headers: HTTPHeaders = ["Content-Type": "application/json",
                                    "Accept-Language": "vi"]
        
        
        if let jwtToken = UserDataDefaults.shared.jwtToken, jwtToken.isNotEmpty {
            let requestToken = "Bearer " + jwtToken
            headers["Authorization"] = requestToken
        }
        
        return headers
    }
    
    private static func isSessionExpired(_ data: Data) -> Bool {
        do {
            let result = try JSONDecoder().decode(FPBaseResponse.self, from: data)
            if let status = result.httpStatus, status == 401 {
                return true
            }
            return false
        } catch let error {
            debugPrint(error)
            return false
        }
    }
}

extension FPNetwork {
    public static func debugData(_ data: Data) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            let datatwo = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let printableJson = String(data: datatwo, encoding: .utf8)
            print("Json From Data:\n\(printableJson ?? "null")")
        } catch {
            print("Json From Data: ?? :D ??")
        }
    }
}
