//
//  BookDetailStore.swift
//  BookLibraryApp
//
//  Created by solution888 on 5/12/22.
//

import ComposableArchitecture
import Moya

struct BookDetailState: Equatable {
    var isMyBook = false
    var currentBook: BookRecord?
}

enum BookDetailAction {
    case onAppear
    case myBookButtonTapped
    case addToMyBook
    case addToMyBookResult(Result<Bool, NSError>)
    case removeToMyBook
    case removeToMyBookResult(Result<Bool, NSError>)
}

struct BookDetailEnvironment {
    var realmClient: RealmClient
}

let bookDetailReducer = Reducer<BookDetailState, BookDetailAction, BookDetailEnvironment> { state, action, env in
    switch action {
    case .onAppear:
        if let currentBook = state.currentBook {
            state.isMyBook = env.realmClient.isMyBook(MyBook(bookRecord: currentBook))
        }
        return .none
    case .myBookButtonTapped:
        if state.isMyBook {
            return Effect(value: .removeToMyBook)
        }
        return Effect(value: .addToMyBook)
    case .addToMyBook:
        if let currentBook = state.currentBook {
            return env.realmClient
                .add(MyBook(bookRecord: currentBook))
                .catchToEffect(BookDetailAction.addToMyBookResult)
        }
        return .none
    case let .addToMyBookResult(result):
        if case let .success(success) = result {
            state.isMyBook = success
        }
        return .none
    case .removeToMyBook:
        if let currentBook = state.currentBook {
            return env.realmClient
                .remove(MyBook(bookRecord: currentBook))
                .catchToEffect(BookDetailAction.removeToMyBookResult)
        }
        return .none
    case let .removeToMyBookResult(result):
        if case let .success(success) = result {
            state.isMyBook = !success
        }
        return .none
    }
}
