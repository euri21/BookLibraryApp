//
//  ApiRequest.swift
//  BookLibraryApp
//
//  Created by solution888 on 5/12/22.
//

import Foundation
import Moya

protocol ApiRequest: TargetType {
    associatedtype Response: Decodable
}

extension ApiRequest {
    var baseURL: URL {
        return URL(string: "your server url")!
    }
    
    var validationType: ValidationType {
        .successCodes
    }
    
    var headers: [String: String]? {
        [
            "Accept": "application/json",
            "X-Client-Timezone": TimeZone.current.identifier,
            "Accept-Encoding": "gzip, deflate"
        ]
    }
}
