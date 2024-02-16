//
//  RandovJokesPresenter.swift
//  HWRealm_BlinovIOS39
//
//  Created by Illya Blinov on 14.02.24.
//

import Foundation
protocol IRandomJokesPresenter {
    func loadRandomJokes()
}
final class RandomJokesPresenter: IRandomJokesPresenter {
    weak var randomJokesView: IRandomJokesView?
    let jokesRandomUrl: String = "https://api.chucknorris.io/jokes/random"
    let badUrl = ""

    func loadRandomJokes(){
        let networkServise = NetworkService.self
        networkServise.delegate = randomJokesView
            NetworkService.requestURL(for: jokesRandomUrl){ [weak self] result in
                switch result {
                case let .success(resultData):
                    let data = try? JSONSerialization.jsonObject(with: resultData, options: .allowFragments) as? [String: Any]
                    let jokes = data?["value"] as? String
                    let jokesId = data?["id"] as? String
                    let categories = data?["categories"]
                    let jokesLoadTime = Date()
                    print(categories)
                    self?.randomJokesView?.pushJokes(jokes: jokes ?? "Error")
                    break
                case .failure:
                    
                    break
                }
            }
        }
}
