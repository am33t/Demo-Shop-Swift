//
//  APIManager.swift
//  Demo-Shop-Swift
//
//  Created by MobCast Innovations on 06/03/18.
//  Copyright © 2018 MobCast Innovations. All rights reserved.
//

import Foundation
import Alamofire
class ATAPIManager
{
    private static var sharedManagerObject: ATAPIManager = {
        let sharedManagerObject = ATAPIManager()
        return sharedManagerObject
    }()

    class func sharedManager() -> ATAPIManager {
        return sharedManagerObject
    }
    
    func getData(completion: @escaping(_ result: [String:Any])->()) {
        
        let todoEndpoint: String = "https://stark-spire-93433.herokuapp.com/json"
        Alamofire.request(todoEndpoint)
            .responseJSON { (response) in
                guard response.result.error == nil else {
                    print("Error calling API")
                    return
                }

                guard let json = response.result.value as? [String: Any] else {
                    print("Returned object in not JSON")
                    return
                }
                completion(json)
        }
        
    }
}
