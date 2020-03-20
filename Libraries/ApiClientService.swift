//
//  ApiClientService.swift
//  ApiClientService
//
//  Created by mhlee on 2020/03/20.
//  Copyright © 2020 mhlee. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

struct ApiClientError: Error {
  var statusCode: Int?
  var data: Data?
  var error: Error?

  var localizedDescription: String {
    let statusCodeString = statusCode != nil ? "\(statusCode!)" : "0"
    let errorString = error != nil ? "\(error!)" : "nil"
    let dataString = data != nil ? (String(data: data!, encoding: .utf8) ?? "nil") : "nil"
    return "\(statusCodeString), \(errorString), \(dataString)"
  }
}

class ApiClientService: NSObject {
  class Get<T: Mappable> {
    static func create(_ url: URLConvertible,
                       encoding: ParameterEncoding = URLEncoding.default,
                       headers: HTTPHeaders? = nil) -> Observable<T> {
      return Observable<T>.create { observer -> Disposable in
        Alamofire
          .request(url,
                   method: .get,
                   encoding: JSONEncoding.default)
          .validate()
          .responseObject { (response: DataResponse<T>) in
            if let result = response.result.value {
              observer.onNext(result)
              observer.onCompleted()
              return
            }
            
            let error = ApiClientError(statusCode: response.response?.statusCode, data: response.data, error: response.error)
            observer.onError(error)
        }
        return Disposables.create()
      }
    }
  }
}
