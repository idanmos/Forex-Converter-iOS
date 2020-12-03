//
//  FCNetworkManager.swift
//  Forex Converter
//
//  Created by Idan Moshe on 25/09/2019.
//  Copyright © 2019 Idan Moshe. All rights reserved.
//

import UIKit
import Alamofire
import Combine

class NetworkManager {
    
    static func downloadXMLFile(url: URL, timeout: TimeInterval, completion: @escaping(Result<Data?>) -> Void) {
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = timeout
        
        Alamofire.request(urlRequest).response { (dataResponse: DefaultDataResponse) in
            if let data = dataResponse.data {
                completion(Result.success(data))
            } else {
                if let error = dataResponse.error {
                    completion(Result.failure(error))
                }
            }
        }
    }
    
    // MARK: - Combine
    
    var cancellable: Set<AnyCancellable> = Set()
    
    func fetchData(url: String, completionHandler: @escaping (Any?) -> Void) {
        guard let fixedURL = URL(string: url) else {
            completionHandler(nil)
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: fixedURL)
            .map({$0.data})
            // .decode(type: ChuckJokes.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                //
            } receiveValue: { (data1: Data) in
                //
            }
            .store(in: &self.cancellable)
    }
    
}
