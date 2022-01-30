//
//  RoommateViewController.swift
//  MyRoommate
//
//  Created by 서현규 on 2021/10/12.
//

import UIKit

class RoommateViewController: UIViewController {

//    MARK: - Properties
    private let roomateTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(RoommateTableViewCell.self, forCellReuseIdentifier: RoommateTableViewCell.identifier)
        table.layoutMargins = .zero
        return table
    }()
//    MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(roomateTableView)
        setupLayout()
    }
    
//    MARK: - Setup Layouts
    private func setupLayout() {
        NSLayoutConstraint.activate([
            roomateTableView.topAnchor.constraint(equalTo: view.topAnchor),
            roomateTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            roomateTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            roomateTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension RoommateViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RoommateTableViewCell.identifier, for: indexPath) as! RoommateTableViewCell
        
//        cell.configure()
        return cell
    }
    
    
}
