import Foundation

let baseUrl = "https://jsonplaceholder.typicode.com"

enum ApiEndpoint {
    case UserListApi
    case PostListApi
    
    var url: String {
        switch self {
        case .UserListApi:
            return baseUrl + "/users"
        case .PostListApi:
            return baseUrl + "/posts"
        }
    }
}
