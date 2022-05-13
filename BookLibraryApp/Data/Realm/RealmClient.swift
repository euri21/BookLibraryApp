//
//  RealmClient.swift
//  BookLibraryApp
//
//  Created by solution888 on 5/12/22.
//

import Foundation
import RealmSwift
import ComposableArchitecture
import Combine

struct RealmClient {
    var findAll: () -> [MyBook]
    var add: (MyBook) -> Effect<Bool, NSError>
    var remove: (MyBook) -> Effect<Bool, NSError>
    var isMyBook: (MyBook) -> Bool
}

extension RealmClient {
    static let live = RealmClient(
        findAll: { findAll() },
        add: { add($0) },
        remove: { remove($0) },
        isMyBook: { isMyBook($0) }
    )
}

extension RealmClient {
    static func findAll() -> [MyBook] {
        Array(Realm.instance.objects(MyBook.self))
    }
    
    static func add(_ book: MyBook) -> Effect<Bool, NSError> {
        return Deferred {
            Future<Bool, NSError> { promise in
                let realm = Realm.instance
                do {
                    try realm.write {
                        Realm.instance.add(book, update: .modified)
                        promise(.success(true))
                    }
                } catch {
                    promise(.failure(NSError()))
                }
            }
        }
        .eraseToEffect()
    }
    
    static func remove(_ book: MyBook) -> Effect<Bool, NSError> {
        return Deferred {
            Future<Bool, NSError> { promise in
                let realm = Realm.instance
                do {
                    try realm.write {
                        realm.delete(findAll().filter{ $0.idBook == book.idBook })
                        promise(.success(true))
                    }
                } catch {
                    promise(.failure(NSError()))
                }
            }
        }
        .eraseToEffect()
    }
    
    static func isMyBook(_ book: MyBook) -> Bool {
        return !findAll().filter { $0.idBook == book.idBook }.isEmpty
    }
}

extension Realm {
    static var instance: Realm {
        do {
            return try Realm()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
