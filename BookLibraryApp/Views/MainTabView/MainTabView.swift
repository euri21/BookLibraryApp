//
//  MainTabView.swift
//  BookLibraryApp
//
//  Created by solution888 on 5/12/22.
//

import SwiftUI
import ComposableArchitecture

struct MainTabView: View {
    let store: Store<MainTabState, MainTabAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            tabView(viewStore)
        }
    }
}

private func tabView(_ viewStore: ViewStore<MainTabState, MainTabAction>) -> some View {
    TabView {
        Group {
            home
            search
            library
        }
    }
    .accentColor(Color.red)
}

private var home: some View {
    HomeView()
        .tabItem(image: "home", text: "ホーム")
}

private var search: some View {
    SearchView(
        store: Store(
            initialState: .init(),
            reducer: searchReducer,
            environment: .init(
                apiClient: .live
            )
        )
    )
        .tabItem(image: "search", text: "見つける")
}

private var library: some View {
    LibraryView()
        .tabItem(image: "library", text: "ライブラリ")
}

fileprivate extension View {
    func tabItem(image: String, text: String) -> some View {
        self.tabItem {
            VStack {
                Image("home")
                    .renderingMode(.template)
                    .imageScale(.large)
                
                Text(text)
            }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(
            store: Store(
                initialState: .init(),
                reducer: mainTabReducer,
                environment: .init()
            )
        )
    }
}
