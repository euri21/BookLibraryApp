//
//  MainTabStore.swift
//  BookLibraryApp
//
//  Created by solution888 on 5/12/22.
//

import ComposableArchitecture

struct MainTabState: Equatable {
}

enum MainTabAction: Equatable {
}

struct MainTabEnvironment {
}

let mainTabReducer = Reducer<MainTabState, MainTabAction, MainTabEnvironment> { state, action, env in
    return .none
}
