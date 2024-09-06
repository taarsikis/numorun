import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let htmlFileName: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = Bundle.main.url(forResource: htmlFileName, withExtension: "html") {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}

