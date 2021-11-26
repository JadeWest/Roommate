//
//  RoommateViewController.swift
//  MyRoommate
//
//  Created by 서현규 on 2021/10/12.
//

import UIKit

class RoommateViewController: UIViewController {

//    MARK: - Properties
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        
        return table
    }()
//    MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
//    MARK: - Setup Layouts

}
