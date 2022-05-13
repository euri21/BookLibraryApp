//
//  ApiClient.swift
//  BookLibraryApp
//
//  Created by solution888 on 5/12/22.
//

import Combine
import ComposableArchitecture
import Moya

struct ApiClient {
    var getBooks: () -> Effect<BookResponse, MoyaError>
}

extension ApiClient {
    static let live = ApiClient(
        getBooks: { request(BookRequest.get) }
    )
}

extension ApiClient {
    static func request<T: ApiRequest>(_ request: T,
                                       jsonDecoder: JSONDecoder = defaultJSONDecoder) -> Effect<T.Response, MoyaError> {
        Future<T.Response, MoyaError> { promise in
            makeProvider(request).request(request) { result in
                switch result {
                case let .success(response):
                    do {
                        let content = try jsonDecoder.decode(T.Response.self, from: response.data)
                        promise(.success(content))
                    } catch {
                        promise(.failure(MoyaError.jsonMapping(response)))
                    }
                case let .failure(error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToEffect()
    }

    static func makeProvider<T>(_ target: T) -> MoyaProvider<T> where T: ApiRequest {
        let loggerPlugin = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
        return MoyaProvider<T>(plugins: [loggerPlugin])
    }
    
    static let defaultJSONDecoder: JSONDecoder = {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        d.keyDecodingStrategy = .convertFromSnakeCase
        return d
    }()
}
