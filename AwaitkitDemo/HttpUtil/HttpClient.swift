import Foundation
import Alamofire
import PromiseKit
import AwaitKit


let httpClient = HttpClient()

class HttpClient {
    
    func request(_ method: HTTPMethod,
                 _ apiEndpoint: ApiEndpoint,
                 parameters: [String : String] = [:],
                 headers: [String : String] = [:],
                 encoding: URLEncoding = .default)-> Promise<[AnyObject]> {

        return Promise { seal in
            Alamofire.request(apiEndpoint.url, method: method, parameters: parameters,
                              encoding: encoding, headers: headers)
                .validate()
                .responseJSON { response in
                    
                    switch response.result {
                    case .success(let json):
                        
                        guard let objectArray = json as? [AnyObject] else {
                            return seal.reject(AFError.responseValidationFailed(reason: .dataFileNil))
                        }
                        seal.fulfill(objectArray)
                    case .failure(let error):
                        seal.reject(error)
                    }
            }
        }
    }
    
    func getAllUsers() -> Promise<[AnyObject]> {
        return self.request(.get, .UserListApi)
    }
    
    func getPostsOfUser(userId: Int) -> Promise<[AnyObject]> {
        return self.request(.get, .PostListApi, parameters: ["userId": "\(userId)"], encoding: .queryString)
    }
}


