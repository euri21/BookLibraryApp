//
//  SearchStore.swift
//  BookLibraryApp
//
//  Created by solution888 on 5/12/22.
//

import ComposableArchitecture
import Moya

struct SearchState: Equatable {
    var selectedTab = 0
    var tabList: [String] = []
    var response: BookResponse?
    var selectedSubCategories: [SubCategory] {
        if let bookList = response?.topCategoryList {
            return bookList.filter {
                $0.nameCategory == tabList[safe: selectedTab]
            }.first?.subCategoryList ?? []
        }
        return []
    }
    var bookDetail: BookDetailState = .init()
}

enum SearchAction {
    case onAppear
    case getBooks
    case getBookResponse(Result<BookResponse, MoyaError>)
    case tabChanged(Int)
    case bookItemTapped(BookRecord)
    case bookDetail(BookDetailAction)
}

struct SearchEnvironment {
    var apiClient: ApiClient
}

let searchReducer = Reducer<SearchState, SearchAction, SearchEnvironment>.combine(
    bookDetailReducer.pullback(state: \SearchState.bookDetail, action: /SearchAction.bookDetail, environment: { _ in
            .init(realmClient: .live)
    }),
    Reducer { state, action, env in
        switch action {
        case .onAppear:
            return Effect(value: .getBooks)
        case .getBooks:
            struct RoomListId: Hashable {}
            
            return env.apiClient
                .getBooks()
                .catchToEffect(SearchAction.getBookResponse)
                .cancellable(id: RoomListId(), cancelInFlight: true)
        case let .getBookResponse(.success(response)):
            state.response = response
            state.tabList = response.topCategoryList.map { $0.nameCategory }
            return .none
        case let .getBookResponse(.failure(error)):
            return .none
        case let .tabChanged(tabIndex):
            state.selectedTab = tabIndex
            return .none
        case let .bookItemTapped(bookItem):
            state.bookDetail.currentBook = bookItem
            return .none
        case .bookDetail(_):
            return .none
        }
    }
).debug()

