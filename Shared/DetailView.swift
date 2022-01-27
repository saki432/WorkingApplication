//
//  DetailView.swift
//  WorkingApplication
//
//  Created by 432 on 2022/01/25.
//

import SwiftUI
import WebKit

// 絵本の詳細ページ
struct DetailView: View {
    let book: Book?
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.white, .yellow]), startPoint: .top, endPoint: .bottom)
                         .ignoresSafeArea()
            
            VStack {
                HStack {
                    URLImage(url: "\(book?.artworkUrl100 ?? "")")
                        .aspectRatio(contentMode: .fit)
                        .fixedSize()
                    VStack (alignment: .leading){
                        Text("\(book?.trackName ?? "No Data")")
                            .font(.title2)
                        Text("\(book?.artistName ?? "No Data")")
                            .font(.subheadline)
                    }
                }
                HTMLStringView(content: "\(book?.description ?? "<h1>No Data</h1>")")
            }
        }
        
    }
}

// URLからダウンロードした画像を表示するImage
struct URLImage: View {

    let url: String
    @ObservedObject private var imageDownloader = ImageDownloader()

    init(url: String) {
        self.url = url
        self.imageDownloader.downloadImage(url: self.url)
    }

    var body: some View {
        if let imageData = self.imageDownloader.downloadData {
            let img = UIImage(data: imageData)
            return VStack {
                Image(uiImage: img!).resizable()
            }
        } else {
            return VStack {
                Image(uiImage: UIImage(systemName: "icloud.and.arrow.down")!).resizable()
            }
        }
    }
}

// html形式のテキストを表示するUITextView
struct HTMLStringView: UIViewRepresentable {
    let htmlContent: String
    private var textView: UITextView = UITextView()
    
    init(content: String) {
        self.htmlContent = content
    }
    
    // UITextView作成
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UITextView {
        textView.backgroundColor = .clear
        textView.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width).isActive = true
        textView.isSelectable = false
        textView.isEditable = false
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<Self>) {
        DispatchQueue.main.async {
            if let attributeText = self.converHTML(text: htmlContent) {
                textView.attributedText = attributeText
            } else {
                textView.text = ""
            }
        }
    }
    
    // html形式の文字列をNSAttributedStringに変換
    private func converHTML(text: String) -> NSAttributedString?{
        guard let data = text.data(using: .utf8) else {
            return nil
        }

        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html,.characterEncoding : String.Encoding.utf8.rawValue], documentAttributes: nil) {
            return attributedString
        } else{
            return nil
        }
    }
}

// SwiftUIのプレビュー表示
struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(book: nil)
    }
}
