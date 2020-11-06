//
//  FCNetworkManager.swift
//  Forex Converter
//
//  Created by Idan Moshe on 25/09/2019.
//  Copyright © 2019 Idan Moshe. All rights reserved.
//

import UIKit
import Alamofire

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
    
}
