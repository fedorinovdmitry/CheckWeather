//
//  APIManager.swift
//  CheckWeather
//
//  Created by Дмитрий Федоринов on 30.04.2020.
//  Copyright © 2020 Дмитрий Федоринов. All rights reserved.
//

import Foundation


typealias JSONTask = URLSessionDataTask
typealias JSONCompletionHandler = (Data?, HTTPURLResponse?, Error?) -> Void

enum APIResult<T> {
    case success(T)
    case failure(Error)
}

protocol FinalURLProtocol {
    var baseURL: URL { get }
    var path: String { get }
    var request: URLRequest { get }
    
}

protocol APIManager {
    
    var sessionConfiguration: URLSessionConfiguration { get }
    var session: URLSession { get }
    
    func JSONTaskWith(request: URLRequest,
                      completionHandler: @escaping JSONCompletionHandler ) -> JSONTask
    func fetch<T: Decodable>(request: URLRequest,
                             parse: @escaping (Data) -> T?,
                             completionHandler: @escaping (APIResult<T>) -> Void)
    
}

extension APIManager {
    
    func JSONTaskWith(request: URLRequest,
                      completionHandler: @escaping JSONCompletionHandler ) -> JSONTask {
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            //проверяем ответ действительно идет по HTTP
            guard let httpResponse = response as? HTTPURLResponse else {
                let userInfo = [
                    NSLocalizedDescriptionKey: NSLocalizedString("Missing HTTP Response",
                                                                 comment: "")
                ]
                let error = NSError(domain: CWNetworkingErrorDomain,
                                    code: MissingHTTPResponseError,
                                    userInfo: userInfo)
                completionHandler(nil, nil, error)
                return
            }
            
            guard let data = data else {
                if let error = error {
                    completionHandler(nil, httpResponse, error)
                }
                return
            }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                print(json)
            }
            //ответ пришел, рассматриваем статус ответа
            switch httpResponse.statusCode {
            case 200:
                completionHandler(data,
                                  httpResponse,
                                  nil)
            default:
                let error = NSError(domain: CWResponseErrorDomain, code: WrongResponse, userInfo: nil)
                completionHandler(nil, httpResponse, error)
                print("We have got response status \(httpResponse.statusCode)")
            }
            
        }
        
        return dataTask
        
    }
    
    func fetch<T: Decodable>(request: URLRequest,
                             parse: @escaping (Data) -> T?,
                             completionHandler: @escaping (APIResult<T>) -> Void) {
        let dataTask = JSONTaskWith(request: request) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    completionHandler(.failure(error))
                }
                return
            }
            
            //проверяем соответствует json ожидаемому результату
            if let value = parse(data) {
                completionHandler(.success(value))
            } else {
                let error = NSError(domain: CWNetworkingErrorDomain,
                                    code: WrongJSON,
                                    userInfo: nil)
                completionHandler(.failure(error))
            }
            
        }
        dataTask.resume()
    }
    
    
}

