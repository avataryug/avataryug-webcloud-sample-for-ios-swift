import SwiftUI
import WebKit
struct ContentView: View {
    @EnvironmentObject var viewModel: AppViewModel
     private var urlString = "" // Added your url here
     @State private var orientation: UIDeviceOrientation? = nil
     
     var body: some View {
         GeometryReader { geometry in
             VStack {
                 if let webViewURL = viewModel.webViewURL {
            
                      WebView(url: webViewURL, onMessageReceived: { message in
                          // Handle the received message as needed
                          print("Received message from web content: \(message)")
                      })
                  } else {
                      // Handle the case where webViewURL is nil
                     
                      WebView(url: URL(string: urlString)!, onMessageReceived: { message in
                          // Handle the received message as needed
                          print("Received message from web content: \(message)")
                      })
                     
                  }
                
             } .frame(width: geometry.size.width, height: geometry.size.height)
         }
     }
}

struct WebView: UIViewRepresentable {
    
    var url: URL
    var onMessageReceived: ((String) -> Void)?  // Closure to handle received messages
    
    func makeCoordinator() -> Coordinator
    {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) ->  WKWebView
    {
        let webView = WKWebView()
        context.coordinator.clearWebViewCache()
        webView.navigationDelegate = context.coordinator
        webView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        // Add script message handler
        let userContentController = WKUserContentController()
        userContentController.add(context.coordinator, name: "iosListener")
     

        let source = """
            window.addEventListener('message', function(e) {
                window.webkit.messageHandlers.iosListener.postMessage(JSON.stringify(e.data));
            });
            """
        let script = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        userContentController.addUserScript(script)
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        
        return WKWebView(frame: .zero, configuration: configuration)
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        
        uiView.load(request)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            print("message: \(message.body)") //You can use messge.body urls which will have the urls
        }
        
        func clearWebViewCache()
        {
             let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache])
             let date = NSDate(timeIntervalSince1970: 0)
             WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: date as Date) {
                 print("Cache cleared")
             }
         }
    }
}
