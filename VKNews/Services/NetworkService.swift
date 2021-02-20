//
//  NetworkService.swift
//  VKNews
//
//  Created by Eugene Kiselev on 20.02.2021.
//

import Foundation

class NetworkService {
    private let authService: AuthService
    
    init(authService: AuthService = SceneDelegate.shared().authService) {
        self.authService = authService
    }
    
    func getFeed() {
        guard let token = authService.token else { return }
        
        let params = ["filters": "post, photos"]
        var allParams = params
        
        allParams["access_token"] = token
        allParams["v"] = API.version
        
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.path = API.newsFeed
        components.queryItems = allParams.map { URLQueryItem(name: $0, value: $1) }
        
        let url = components.url!
    }
}
