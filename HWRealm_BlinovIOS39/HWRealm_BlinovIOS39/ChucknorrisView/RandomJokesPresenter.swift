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
final class RandomJokesPresenter: IRandomJokesPresenter, AlertsDelegate {
    weak var randomJokesView: IRandomJokesView?
    var realmService: IRealmService?
    let jokesRandomUrl: String = "https://api.chucknorris.io/jokes/random"
    let badUrl = ""

    init(randomJokesView: IRandomJokesView? = nil, realmService: IRealmService?) {
        self.randomJokesView = randomJokesView
        self.realmService = realmService
    }

    func loadRandomJokes(){
        let networkServise = NetworkService.self
        networkServise.delegate = self
            NetworkService.requestURL(for: jokesRandomUrl){ [weak self] result in
                switch result {
                case let .success(resultData):
                    //MARK: Serialization
                    let data = try? JSONSerialization.jsonObject(with: resultData, options: .allowFragments) as? [String: Any]
                    let jokes = data?["value"] as? String
                    let id = data?["id"] as? String
                    let jokesLoadTime = Date()
                    let categoriesString: [String] = data?["categories"] as? [String] ?? []
                    //MARK: Save if empty categorie
                    let saveJokes = JokesModel()
                    saveJokes.id = id ?? ""
                    saveJokes.jokes = jokes ?? "Error"
                    saveJokes.loadingDate = jokesLoadTime
                    self?.randomJokesView?.pushJokes(jokes: saveJokes.jokes)
                    let isNewJokes: Bool = self?.realmService?.isNewJokes(id: id ?? saveJokes.id) ?? false
                    guard isNewJokes else { return }
                    guard saveJokes.id != ""  else { return }
                    self?.realmService?.addJokes(jokesModel: saveJokes)
                    if categoriesString.isEmpty {} else {
                    //MARK: Save if no empty categorie
                        print("Получил шутку с категорией")
                        self?.addCategory(categoryes: categoriesString, jokes: saveJokes)
                    }
                    self?.randomJokesView?.enableLoadButton()
                case .failure(.custom):
                    self?.callAlert(description: "Ошибка сети", title: "Внимание")
                case .failure(.server):
                    self?.callAlert(description: "Ошибка сервера", title: "Внимание")
                case .failure(.unknown):
                    self?.callAlert(description: "Неизвестная ошибка", title: "Внимание")
                }
            }
        }
    func addCategory(categoryes: [String], jokes: JokesModel){
        categoryes.forEach(){
            let categoryModel = realmService?.foundCategory(category: $0) ?? CategoryModel()
            realmService?.associationJokesAndCategory(categoryModel: categoryModel, jokesModel: jokes)
        }
    }
}
extension RandomJokesPresenter {
    func callAlert(description: String, title: String) {
        randomJokesView?.callAlert(description: description, title: title)
    }
}
