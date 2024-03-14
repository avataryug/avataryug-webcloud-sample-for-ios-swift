import Foundation
class ApiServices{
    static let shared = ApiServices()
     let projectTitle = "<YourProjectTitle>" // Replace with your actual project title
     let APIKEY = "<API Key>" // Replace with your actual API key

    func onCreeateUser(userID: String, completion: @escaping (Response?, Error?) -> Void) {
        let url = URL(string: "https://\(projectTitle).avataryugapi.com/server/LoginWithServerCustomID")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let body: [String: Any] = ["CustomID": userID,"CreateAccount": true]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        request.setValue("\(projectTitle).local.host", forHTTPHeaderField: "X-Forwarded-Host")
        request.setValue(APIKEY, forHTTPHeaderField: "X-API-Key")

        let task = URLSession.shared.dataTask(with: request)
        {(data, response, error) in
            DispatchQueue.main.async
            {
                if let error = error
                {
                 completion(nil, error)
                    return
                }
                guard let data = data else
                {completion(nil, NSError(domain: "Data not found!", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
                    return
                }
                do
                {let decodedResponse = try JSONDecoder().decode(Response.self, from: data)
                    completion(decodedResponse, nil)
                } catch
                {completion(nil, error)}
            }
        }
        task.resume()
    }
}
struct Response: Decodable {
    // Define your Response structure based on your API response
    let Data: Data
}

struct Data: Decodable {
    let AccessToken: String
    let User: User
}

struct User: Decodable {
    let UserID: String
}
