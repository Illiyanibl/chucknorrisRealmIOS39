//
//  File.swift
//  HWRealm_BlinovIOS39
//
//  Created by Illya Blinov on 14.02.24.
//

import UIKit

protocol IRandomJokesView: AnyObject{
    func pushJokes(jokes: String)
    func callAlert(description: String, title: String)
    func enableLoadButton()
}

final class RandomJokesView: UIViewController, IRandomJokesView{

    lazy var loadButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .darkGray
        button.setTitle("Загрузить", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemFill.cgColor
        button.addTarget(self, action: #selector(loadButtonClick), for: .touchUpInside)
        return button
    }()

    lazy var jokesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.text = "Loading..."
        return label
    }()

    let presenter: IRandomJokesPresenter?
    init(presenter: IRandomJokesPresenter?) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    func setupView(){
        view.backgroundColor = .white
        view.addSubview(loadButton)
        view.addSubview(jokesLabel)
    }

    @objc func loadButtonClick(){
        loadButton.isEnabled = false
        presenter?.loadRandomJokes()
    }

    func enableLoadButton(){
        loadButton.isEnabled = true
    }
    
    func pushJokes(jokes: String){
        jokesLabel.text = jokes
    }

    private func setupConstraints(){
        let nearIndent: CGFloat = 5
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            loadButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: nearIndent),
            loadButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -nearIndent),
            loadButton.heightAnchor.constraint(equalToConstant: 40),
            loadButton.widthAnchor.constraint(equalToConstant: 120),

            jokesLabel.topAnchor.constraint(equalTo: loadButton.bottomAnchor, constant: 2 * nearIndent),
            jokesLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: nearIndent),
            jokesLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -nearIndent),
        ])
    }
}

