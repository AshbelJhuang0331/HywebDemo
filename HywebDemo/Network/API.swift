//
//  API.swift
//  HywebDemo
//
//  Created by Chuan-Jie Jhuang on 2022/6/7.
//

import Foundation

class API: NSObject {
    
    // MARK: - Config
    
    private struct URI {
        static let scheme = "https"
        static let host = "mservice.ebook.hyread.com.tw"
        static let path = ""
        static let defaultQuery = ""
    }
    
    // MARK: - Init
    
    private var urlComponents = URLComponents()
    private let session = URLSession.shared
    
    override init() {
        super.init()
        self.urlComponents.scheme = URI.scheme
        self.urlComponents.host = URI.host
        self.urlComponents.path = URI.path
    }
    
    // MARK: - Public Methods
    
    func fetchMyBookcase(succeed: @escaping (Data) -> Void, fail: @escaping (Error) -> Void) {
        self.urlComponents.path = "/exam/user-list"
        let url = self.urlComponents.url
        session.dataTask(with: url!) { (data: Data?, response: URLResponse?, error: Error?) in
            DispatchQueue.main.async {
                guard error == nil else {
                    fail(error!)
                    return
                }
                if let data = data {
                    succeed(data)
                }
            }
        }.resume()
    }
    
}
