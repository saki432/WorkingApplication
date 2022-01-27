//
//  ContentView.swift
//  Shared
//
//  Created by 432 on 2022/01/24.
//

import SwiftUI

// おすすめ絵本一覧（初回ページ）
struct ContentView: View {
    @ObservedObject private var bookListLoader = BookListLoader()

    init() {
        self.bookListLoader.url = "https://itunes.apple.com/search?term=%E5%B9%BC%E5%85%90%E5%90%91%E3%81%91%E7%B5%B5%E6%9C%AC&country=jp&media=ebook"
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.white, .yellow]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                List(self.bookListLoader.results, id: \.trackId) { item in
                    LinkCell(title: item.trackName ?? "", artistName: item.artistName ?? "", artworkUrl: item.artworkUrl60 ?? "", destination: DetailView(book: item))
                }.navigationTitle("iTunesで読める絵本")
            }.onAppear(perform: self.bookListLoader.loadData)
        }
    }
}

// セル
struct LinkCell<Destination: View>: View {
    // 絵本タイトル
    let title: String
    // 著者名
    let artistName: String
    // イメージ画像
    let artworkUrl: String
    // 遷移先画面
    let destination: Destination
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack(alignment: .leading) {
                HStack{
                    URLImage(url: artworkUrl)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    VStack(alignment: .leading) {
                        Text(title)
                        Text(artistName)
                            .font(.subheadline)
                    }
                }
            }
        }
    }
}

// SwiftUIのプレビュー表示
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
