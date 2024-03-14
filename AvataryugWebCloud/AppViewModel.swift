import Foundation
class AppViewModel: ObservableObject {
    @Published var showContent = false
    @Published var webViewURL: URL?
}
