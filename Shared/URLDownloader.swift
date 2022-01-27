//
//  URLDownloader.swift
//  WorkingApplication
//
//  Created by 432 on 2022/01/25.
//
import Foundation

// 画像ダウンロード
class ImageDownloader : ObservableObject {
    @Published var downloadData: Data? = nil

    func downloadImage(url: String) {

        guard let imageURL = URL(string: url) else { return }

        DispatchQueue.global().async {
            let data = try? Data(contentsOf: imageURL)
            DispatchQueue.main.async {
                self.downloadData = data
            }
        }
    }
}

// 絵本情報
struct Book: Codable {
    var trackId: Int
    var trackName: String?
    var artistName: String?
    var formattedPrice: String?
    var artworkUrl60: String?
    var artworkUrl100: String?
    var description: String?
}

// 絵本一覧
struct BookList: Codable {
    var results: [Book]
}

// API通信処理
class BookListLoader : ObservableObject {
    var url: String? = nil
    @Published var results = [Book]()
    
    func loadData() {
        guard let bookURL = URL(string: self.url ?? "") else { return }

        let request = URLRequest(url: bookURL)

        URLSession.shared.dataTask(with: request) { data, response, responseError in

            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let decodedResponse = try decoder.decode(BookList.self, from: data)
                    DispatchQueue.main.async {
                        self.results = decodedResponse.results
                    }
                } catch {
                    print(error)
                    print(error.localizedDescription)
                    return
                }
                
            } else {
                print("データ取得失敗: \(responseError?.localizedDescription ?? "不明なエラー")")
            }
        }.resume() // 通信開始
    }
}
