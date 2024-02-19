//
//  JokesModel.swift
//  HWRealm_BlinovIOS39
//
//  Created by Illya Blinov on 16.02.24.
//
import Foundation
import RealmSwift

final class JokesModel: Object {
    @Persisted var id: String
    @Persisted var jokes: String
    @Persisted var loadingDate: Date = Date()
    @Persisted var categorys = List<CategoryModel>()
}
final class CategoryModel: Object {
    @Persisted var category: String
    @Persisted var jokesList =  List<JokesModel>()
}
