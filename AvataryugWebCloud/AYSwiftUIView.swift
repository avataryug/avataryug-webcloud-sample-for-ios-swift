import SwiftUI

struct AYSwiftUIView: View {
    @EnvironmentObject var viewModel: AppViewModel
    var body: some View {
    ZStack{
            VStack{
                Button("Server Login")
                {
                    loadWebViewURL()
                }.frame(width: 200,height: 50).background(Color(.systemGray4)).cornerRadius(6).shadow(radius: 5,x: 2,y: 2).padding()
               
                  Button("Custom Login")
                {
                    LoadDirectWebView()
                }.frame(width: 200,height: 50).background(Color(.systemGray4)).cornerRadius(6).shadow(radius: 5,x: 2,y: 2).padding()
            }
        }.frame(width: UIScreen.main.bounds.width,height:UIScreen.main.bounds.height).background(Gradient(colors: [Color.white,Color(.systemGray4)]))
    }
    private func printResponse(_ response: Response?)
    {
          if let response = response {
              print("API Response:")
              print("AccessToken: \(response.Data.AccessToken)")
              print("UserID: \(response.Data.User.UserID)")
          } else {print("API Response: nil")}
    }
     func loadWebViewURL()
     {ApiServices.shared.onCreeateUser(userID: "YourUserName")
        { response, error in
            guard let userID = response?.Data.User.UserID
            else
            { print("Error: Unable to get UserID")
                return
            }
            let queryParams = [
                "AccessToken": response?.Data.AccessToken ?? "",
                "UserID": userID
            ]
            let urlString = "https://\(ApiServices.shared.projectTitle).avataredge.net?" + queryParams.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
            
            printResponse(response)
            
            if let url = URL(string: urlString) {viewModel.webViewURL = url
                viewModel.showContent = true
            } else {print("Failed to load webView")}
        }
    }
    
    func LoadDirectWebView()
    {
        viewModel.webViewURL = nil
        viewModel.showContent = true
    }
}

struct AYSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        AYSwiftUIView()
    }
}


