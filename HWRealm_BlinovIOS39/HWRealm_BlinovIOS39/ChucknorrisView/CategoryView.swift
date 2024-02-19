//
//  CategoryView.swift
//  HWRealm_BlinovIOS39
//
//  Created by Illya Blinov on 14.02.24.
//

import UIKit
final class CategoryView: UIViewController {
    var realmService: IRealmService?
    var categoryList: [CategoryModel] = []

    lazy var categoriesTable : UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    init(realmServise: IRealmService?){
        self.realmService = realmServise
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints(safeArea: view.safeAreaLayoutGuide)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        categoryReload()
        print(categoryList.count)
    }
    func setupView(){
        view.addSubview(categoriesTable)
    }
    func categoryReload(){
        categoryList = realmService?.fetchCategory() ?? []
        categoriesTable.reloadData()
    }

    private func setupConstraints(safeArea: UILayoutGuide){
        NSLayoutConstraint.activate([
            categoriesTable.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            categoriesTable.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            categoriesTable.topAnchor.constraint(equalTo: safeArea.topAnchor),
            categoriesTable.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        ])
    }
}
extension CategoryView:  UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        var content = cell.defaultContentConfiguration()
        let cellCategory = categoryList[indexPath.row]
        content.text = cellCategory.category
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Выбрана катеогрия \(categoryList[indexPath.row].category) ")
        let categoryJokesView = AllJokesView(realmServise: Builder.realmService)
        categoryJokesView.jokesCategory = categoryList[indexPath.row]
        navigationController?.pushViewController(categoryJokesView, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
