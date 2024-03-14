import SwiftUI

@main
struct AvataryugWebCloudApp: App {
    @StateObject private var viewModel = AppViewModel()
        var body: some Scene {
            WindowGroup {
                if viewModel.showContent {
                      ContentView()
                          .environmentObject(viewModel)
                  } else {
                      AYSwiftUIView()
                          .environmentObject(viewModel)
                  }
              
            }
        }
}
