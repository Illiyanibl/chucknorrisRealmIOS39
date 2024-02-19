//
//  RealmService.swift
//  HWRealm_BlinovIOS39
//
//  Created by Illya Blinov on 16.02.24.
//

import RealmSwift
protocol IRealmService: AnyObject {
    var delegate: AlertsDelegate? { get }
    func fetchJokes(category: CategoryModel?) -> [JokesModel]
    func fetchCategory() -> [CategoryModel]
    func isNewJokes(id: String) -> Bool
    func foundCategory(category: String) -> CategoryModel
    func addJokes(jokesModel: JokesModel)
    func associationJokesAndCategory(categoryModel: CategoryModel, jokesModel: JokesModel)
    func addCategory(categoryModel: CategoryModel)
    func deleteJokes(deleteModel: JokesModel)
}
final class RealmService: IRealmService {
    let realm: Realm?
    private var jokes: [JokesModel] {
        return fetchJokes() }
    private var categoryes: [CategoryModel] {
        return fetchCategory() }
    weak var delegate: AlertsDelegate?
    init(delegate: AlertsDelegate? = nil, version: UInt64) {
        self.delegate = delegate
        let config = Realm.Configuration(schemaVersion: version)
        self.realm = try? Realm(configuration: config)
    }
    func fetchJokes(category: CategoryModel? = nil) -> [JokesModel]{
        guard let realm else { return []}
        guard let category else { return realm.objects(JokesModel.self).sorted(by: {$0.loadingDate > $1.loadingDate }) }
        return category.jokesList.map { $0 }
    }
    func fetchCategory() -> [CategoryModel]{
        guard let realm else { return []}
        return realm.objects(CategoryModel.self).map { $0 }
    }
    func addCategory(categoryModel: CategoryModel) {
        print("Пытаюсь добавить категорию")
        guard let realm else { return }
        do {
            try realm.write {
                realm.add(categoryModel)
            }
        } catch {
            delegate?.callAlert(description: "Ошибка записи", title: "Внимание")
        }
    }

    func addJokes(jokesModel: JokesModel) {
        guard let realm else { return }
        do {
            try realm.write {
                realm.add(jokesModel)
            }
        } catch {
            delegate?.callAlert(description: "Ошибка записи", title: "Внимание")
        }
    }

    func associationJokesAndCategory(categoryModel: CategoryModel, jokesModel: JokesModel){
        guard let realm else { return }
        do {
            try realm.write {
                categoryModel.jokesList.append(jokesModel)
                jokesModel.categorys.append(categoryModel)
            }
        } catch {
        }
    }

    func isNewJokes(id: String) -> Bool {
        var isNew = true
        jokes.forEach(){
            if $0.id == id { isNew = false }
        }
        return isNew
    }

    func foundCategory(category: String) -> CategoryModel {
        var categoryModel: CategoryModel?  = nil
        fetchCategory().forEach(){
            if category == $0.category { categoryModel = $0}
        }
        let newCategory = CategoryModel()
        newCategory.category = category
        if categoryModel == nil { addCategory(categoryModel: newCategory) }
        return categoryModel ?? newCategory
    }

    func deleteJokes(deleteModel: JokesModel) {
        guard let realm else { return }
        do {
            try realm.write {
                realm.delete(deleteModel)
            }
        } catch {
            delegate?.callAlert(description: "Ошибка удаления", title: "Внимание")
        }
    }
}

