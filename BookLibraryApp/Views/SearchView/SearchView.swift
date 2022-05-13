//
//  SearchView.swift
//  BookLibraryApp
//
//  Created by solution888 on 5/12/22.
//

import SwiftUI
import ComposableArchitecture

struct SearchView: View {
    let store: Store<SearchState, SearchAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                VStack {
                    Tabs(tabs: .constant(viewStore.tabList),
                         selection: viewStore.binding(get: \.selectedTab, send: SearchAction.tabChanged),
                         underlineColor: .red) { title, isSelected in
                        Text(title.uppercased())
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(isSelected ? .black : .gray)
                    }
                    
                    SubCategoryListView(subCategoryList: viewStore.selectedSubCategories, store: self.store)
                    Spacer()
                }
                .onAppear {
                    viewStore.send(.onAppear)
                }
                .navigationBarHidden(true)
            }
        }
    }
}

struct SubCategoryListView: View {
    let subCategoryList: [SubCategory]
    let store: Store<SearchState, SearchAction>
    
    var body: some View {
        ScrollView(.vertical) {
            ForEach(subCategoryList, id: \.idCategory) { subCategory in
                Section(
                    header: Text(subCategory.nameCategory)
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(10)
                ) {
                    SubCategoryView(subCategory: subCategory, store: self.store)
                }
            }
        }
    }
}

struct SubCategoryView: View {
    let subCategory: SubCategory
    let store: Store<SearchState, SearchAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView(.horizontal) {
                HStack {
                    ForEach(subCategory.bookList, id: \.idBook) { book in
                        NavigationLink(
                            destination: BookDetailView.init(store: self.store.scope(state: \.bookDetail, action: SearchAction.bookDetail))
                        ) {
                            BookView(currentBook: book, store: self.store)
                                .padding(10)
                        }
                        .simultaneousGesture(
                            TapGesture()
                                .onEnded { _ in
                                    viewStore.send(.bookItemTapped(book))
                                }
                        )
                    }
                }
            }
        }
    }
}

struct BookView: View {
    let currentBook: BookRecord
    let store: Store<SearchState, SearchAction>
    
    var body: some View {
        AsyncImage(url: currentBook.imgUrl, placeholder: {
            Text("Loading ...")
                .font(.callout)
                .foregroundColor(Color.cyan)
        })
        .frame(width: 100, height: 150)
        .aspectRatio(contentMode: .fit)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(
            store: Store(
                initialState: .init(),
                reducer: searchReducer,
                environment: .init(
                    apiClient: .live
                )
            )
        )
    }
}
