//
//  BookDetailView.swift
//  BookLibraryApp
//
//  Created by solution888 on 5/12/22.
//

import SwiftUI
import ComposableArchitecture

struct BookDetailView: View {
    let store: Store<BookDetailState, BookDetailAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            if let currentBook = viewStore.currentBook {
                VStack {
                    HStack(alignment: .top, spacing: 20) {
                        AsyncImage(url: currentBook.imgUrl, placeholder: {
                            Text("Loading ...")
                                .font(.callout)
                                .foregroundColor(Color.cyan)
                        })
                        .frame(width: 100, height: 150)
                        .aspectRatio(contentMode: .fill)
                        
                        VStack(alignment: .leading) {
                            Text(currentBook.nameBook)
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("著者：\(currentBook.author)")
                                .font(.body)
                                .foregroundColor(.gray)
                            Text("出版社：\(currentBook.publisher)")
                                .font(.body)
                                .foregroundColor(.gray)
                            
                            HStack {
                                Button(action: {
                                    viewStore.send(.myBookButtonTapped)
                                }) {
                                    Text(viewStore.isMyBook ? "MyBooksから外す" : "MyBooks追加")
                                        .fontWeight(.bold)
                                        .font(.body)
                                        .foregroundColor(.red)
                                        .padding(5)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(Color.red, lineWidth: 2)
                                        )
                                }
                                
                                Button(action: {
                                    print("Hello button tapped!")
                                }) {
                                    Text("購入")
                                        .fontWeight(.bold)
                                        .font(.body)
                                        .foregroundColor(.white)
                                        .padding(5)
                                        .background(.blue)
                                        .cornerRadius(5)
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                .navigationBarTitle("書籍紹介", displayMode: .inline)
                .onAppear {
                    viewStore.send(.onAppear)
                }
            }
        }
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailView(
            store: .init(
                initialState: .init(),
                reducer: bookDetailReducer,
                environment: .init(
                    realmClient: .live
                )
            )
        )
    }
}
