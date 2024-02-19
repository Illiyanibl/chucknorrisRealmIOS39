//
//  AllJokesView.swift
//  HWRealm_BlinovIOS39
//
//  Created by Illya Blinov on 14.02.24.
//

import UIKit
final class AllJokesView: UIViewController{
    var realmService: IRealmService?
    var jokesList: [JokesModel] = []
    var jokesCategory: CategoryModel? = nil

    lazy var jokesTable : UITableView = {
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
        jokesReload()
        print(jokesList.count)
    }
    func setupView(){
        view.addSubview(jokesTable)
    }

    func jokesReload(){
        jokesList = realmService?.fetchJokes(category: jokesCategory) ?? []
        jokesTable.reloadData()
    }

    private func setupConstraints(safeArea: UILayoutGuide){
        NSLayoutConstraint.activate([
            jokesTable.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            jokesTable.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            jokesTable.topAnchor.constraint(equalTo: safeArea.topAnchor),
            jokesTable.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        ])
    }
}

extension AllJokesView:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        jokesList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        var content = cell.defaultContentConfiguration()
        let cellJokes = jokesList[indexPath.row]
        content.text = cellJokes.jokes
        content.secondaryText = "Loaded: \(cellJokes.loadingDate)"
        cell.contentConfiguration = content
        return cell
    }

}

