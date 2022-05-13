//
//  MyBook.swift
//  BookLibraryApp
//
//  Created by solution888 on 5/12/22.
//

import Foundation
import RealmSwift

@objcMembers
class MyBook: Object, Codable {
    dynamic var idBook: String
    
    override static func primaryKey() -> String? {
        return "idBook"
    }
    
    convenience init(bookRecord: BookRecord) {
        self.init()
        
        idBook = bookRecord.idBook
    }
}
