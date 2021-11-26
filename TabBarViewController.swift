//
//  TabBarViewController.swift
//  MyRoommate
//
//  Created by 서현규 on 2021/10/12.
//

import UIKit
import FirebaseAuth

class TabBarViewController: UITabBarController {

//    MARK: - Properties
    private let newsFeedNav = UINavigationController(rootViewController: NewsFeedViewController())
    private let roommateNav = UINavigationController(rootViewController: RoommateViewController())
    private let messageNav = UINavigationController(rootViewController: MessageViewController())
    private let profileNav = UINavigationController(rootViewController: ProfileViewController())
    
    let tabBarIconImages = ["megaphone", "person.3", "message", "person"]
    let tabBarIconSelectedImages = ["megaphone.fill", "person.3.fill", "message.fill", "person.fill"]
    
//    MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let coreTabNavigations: [UINavigationController] = [newsFeedNav, roommateNav, messageNav, profileNav]
        self.tabBar.backgroundColor = .secondarySystemBackground
        self.tabBar.tintColor = UIColor(named: "IdColor")
        setViewControllers(coreTabNavigations, animated: false)
        setTabItemImages()
        setNavTitle()
        
    }
    
//    MARK: - functions
    private func setTabItemImages() {
        guard let items = self.tabBar.items else {
            return
        }
        
        for idx in 0..<items.count {
            items[idx].image = UIImage(systemName: tabBarIconImages[idx])
            items[idx].selectedImage = UIImage(systemName: tabBarIconSelectedImages[idx])
        }
    }
    
    private func setNavTitle() {
        newsFeedNav.title = "뉴스피드"
        roommateNav.title = "룸메이트"
        messageNav.title = "메세지"
        profileNav.title = "프로필"
    }
    
    
}
