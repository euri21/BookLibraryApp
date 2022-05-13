//
//  BookRequest.swift
//  BookLibraryApp
//
//  Created by solution888 on 5/12/22.
//

import Foundation
import Moya

enum BookRequest {
    case get
}

extension BookRequest: ApiRequest {
    typealias Response = BookResponse
    
    var path: String {
        "/mock/book/all"
    }
    
    var method: Moya.Method {
        switch self {
        case .get:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .get:
            return .requestPlain
        }
    }
    
    var sampleData: Data {
        """
        {
            "top_category_list": [
                {
                  "id_top_category": "_id_top_category",
                  "name_category": "string",
                  "sub_category_list": [
                    {
                      "book_list": [
                        {
                          "author": "string",
                          "id_book": "_id_book",
                          "img_url": "string",
                          "name_book": "string",
                          "publisher": "string"
                        }
                      ],
                      "id_category": "_id_category",
                      "name_category": "_name_category",
                    }
                  ]
                }
            ]
        }
        """.data(using: .utf8)!
    }
}

struct BookResponse: Decodable, Equatable {
    let topCategoryList: [TopCategory]
}

struct TopCategory: Decodable, Equatable {
    let idTopCategory: String
    let nameCategory: String
    let subCategoryList: [SubCategory]
}

struct SubCategory: Decodable, Equatable {
    let bookList: [BookRecord]
    let idCategory: String
    let nameCategory: String
}

struct BookRecord: Decodable, Equatable {
    let author: String
    let idBook: String
    let imgUrl: String
    let nameBook: String
    let publisher: String
}
