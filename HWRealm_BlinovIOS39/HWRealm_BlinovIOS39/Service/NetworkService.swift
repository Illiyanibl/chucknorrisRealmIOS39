//
//  NetworkService.swift
//  HWRealm_BlinovIOS39
//
//  Created by Illya Blinov on 14.02.24.
//

import Foundation

enum NetworkError: Error {
    case custom(description: String)
    case server
    case unknown
}
struct NetworkServiceSession {
    let sessionQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .utility
        queue.name = "sessionQueue"
        return queue
    }()
    lazy var session = URLSession(
        configuration: .default,
        delegate: nil,
        delegateQueue: sessionQueue
    )
    static var shared = NetworkServiceSession()
}

struct NetworkService {
    weak static var delegate: AlertsDelegate?
    static func requestURL(for url: String, completion: @escaping (Result<Data, NetworkError>) -> Void){
        guard let url = URL(string: url) else {
            delegate?.callAlert(description: "Неверный Url", title: "Внимание")
            return
        }
        let request = URLRequest(url: url)
        let task = NetworkServiceSession.shared.session.dataTask(with: request) { data, response, error in
            if let error {
                DispatchQueue.main.async {
                    completion(.failure(.custom(description: error.localizedDescription)))
                }
            }
            guard response is HTTPURLResponse else { return }

            guard let data else {
                DispatchQueue.main.async {
                    completion(.failure(.server))
                }
                return
            }
            DispatchQueue.main.async {
                completion(.success(data))
            }
        }
        task.resume()
    }
}
