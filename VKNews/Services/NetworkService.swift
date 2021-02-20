//
//  NetworkService.swift
//  VKNews
//
//  Created by Eugene Kiselev on 20.02.2021.
//

import Foundation

protocol Networking {
    func request(path: String, params: [String: String], completion: @escaping  (Data?, Error?) -> ())
}

class NetworkService {
    private let authService: AuthService
    
    init(authService: AuthService = SceneDelegate.shared().authService) {
        self.authService = authService
    }
    
    private func url(from path: String, params: [String: String]) -> URL {
        
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.path = API.newsFeed
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        
        return components.url!
    }
    
    private func createTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> ()) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
}

extension NetworkService: Networking {
    func request(path: String, params: [String : String], completion: @escaping (Data?, Error?) -> ()) {
        guard let token = authService.token else { return }
        var allParams = params
        allParams["access_token"] = token
        allParams["v"] = API.version
        let url = self.url(from: path, params: allParams)
        
        let request = URLRequest(url: url)
        let task = createTask(from: request, completion: completion)
        
        task.resume()
    }
}
