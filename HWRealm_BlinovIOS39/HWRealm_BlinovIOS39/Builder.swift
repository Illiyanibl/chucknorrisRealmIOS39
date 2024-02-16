//
//  Builder.swift
//  HWRealm_BlinovIOS39
//
//  Created by Illya Blinov on 14.02.24.
//

import UIKit
final class Builder {
    static var share: Builder = Builder()
    var viewController: UIViewController?
    private init(){
    buildMainController()
    }
   func buildMainController(){
        let randomJokesPresenter = RandomJokesPresenter()

        let rootViewController: UIViewController = {
           let tabBarController = UITabBarController()
           tabBarController.tabBar.barStyle = .default
           tabBarController.tabBar.backgroundColor = .darkGray
           tabBarController.tabBar.tintColor = .white
           tabBarController.tabBar.unselectedItemTintColor = .black
           return tabBarController}()

        let allJokesView = AllJokesView()
        let randomJokesView = RandomJokesView(presenter: randomJokesPresenter)
        let categoryView = CategoryView()

        randomJokesPresenter.randomJokesView = randomJokesView

        allJokesView.tabBarItem = UITabBarItem(title: "Все цитаты", image: UIImage(), tag: 1)
        randomJokesView.tabBarItem = UITabBarItem(title: "Загрузка цитаты", image: UIImage(), tag: 0)
        categoryView.tabBarItem = UITabBarItem(title: "Категории", image: UIImage(), tag: 2)

       (rootViewController as? UITabBarController)?.viewControllers = [UINavigationController(rootViewController:randomJokesView), allJokesView, categoryView]
        rootViewController.tabBarController?.selectedIndex = 0
        viewController = rootViewController
    }
}
