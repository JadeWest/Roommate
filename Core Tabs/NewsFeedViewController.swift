//
//  ViewController.swift
//  MyRoommate
//
//  Created by 서현규 on 2021/10/11.
//

import UIKit
import FirebaseAuth

struct NewsFeedRenderViewModel {
    let header: PostRenderViewModel
    let post: PostRenderViewModel
    let actions: PostRenderViewModel
    let comments: PostRenderViewModel
}
class NewsFeedViewController: UIViewController {

    private var feedRenderViewModels = [NewsFeedRenderViewModel]()
    private let currentUser = Auth.auth().currentUser
    //    MARK: - Properties
    private let newsTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(NewsFeedHeaderTableViewCell.self,
                       forCellReuseIdentifier: NewsFeedHeaderTableViewCell.identifier)
        table.register(NewsFeedContentTableViewCell.self,
                       forCellReuseIdentifier: NewsFeedContentTableViewCell.identifier)
        table.register(NewsFeedActionTableViewCell.self,
                       forCellReuseIdentifier: NewsFeedActionTableViewCell.identifier)
        table.register(NewsFeedGeneralTableViewCell.self,
                       forCellReuseIdentifier: NewsFeedGeneralTableViewCell.identifier)
        table.layoutMargins = .zero
        
        return table
    }()
    
//    MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(newsTable)
        view.backgroundColor = .systemBackground
        newsTable.delegate = self
        newsTable.dataSource = self
//        setupLayout()
        createMockModels()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        newsTable.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func createMockModels() {
        let user = User(email: "John@gmail.com",
                        username: "John",
                        createdDate: Date(),
                        modifiedDate: Date(),
                        gender: .male,
                        birthDate: Date())
        let post = UserPost(identifier: "",
                            postType: .photo,
                            thumbnailImage: URL(string: "https://www,google.com")!,
                            postURL: URL(string: "https://www,google.com")!,
                            caption: nil,
                            linkCount: [],
                            comments: [],
                            createdDate: Date(),
                            owner: user)
        
        var comments = [PostComment]()
        for x in 0..<2 {
            comments.append(
                PostComment(identifier: "\(x)",
                            username: "@jenny",
                            text: "This is best post i've seen",
                            createdDate: Date(),
                            likes: [])
            )
        }
        
        for x in 0..<5 {
            
            let viewModel = NewsFeedRenderViewModel(header: PostRenderViewModel(renderType: .header(provider: user)),
                                                    post: PostRenderViewModel(renderType: .primaryContent(provider: post)),
                                                    actions: PostRenderViewModel(renderType: .actions(provider: "")),
                                                    comments: PostRenderViewModel(renderType: .comments(comments: comments)))
            feedRenderViewModels.append(viewModel)
        }
    }
    
    
//    MARK: - Setup Layout
    private func setupLayout() {
        NSLayoutConstraint.activate([
            newsTable.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            newsTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            newsTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            newsTable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        ])
    }
}


//    MARK: - Extension
extension NewsFeedViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return feedRenderViewModels.count * 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sec = section
        let model: NewsFeedRenderViewModel
        if sec == 0 {
            model = feedRenderViewModels[0]
        }
        // 섹션이 0을 제외한 1이상 넘어갔을때 계산
        // ex
        else {
            let position = sec % 4 == 0 ? sec/4 : ((sec - (sec%4)) / 4)
            model = feedRenderViewModels[position]
        }
        
        let subSection = sec % 4
        
        if subSection == 0 {
            // header
            return 1
        }
        else if subSection == 1 {
            // post
            return 1
        }
        else if subSection == 2 {
            // actions
            return 1
        }
        else if subSection == 3 {
            // comments
            let commentModel = model.comments
            switch commentModel.renderType {
            case .comments(let comments): return comments.count > 2 ? 2: comments.count
            case .header, .actions, .primaryContent: return 0
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let idxSection = indexPath.section
        let model: NewsFeedRenderViewModel
        if idxSection == 0 {
            model = feedRenderViewModels[0]
        }
        else {
            let position = idxSection % 4 == 0 ? idxSection/4 : ((idxSection - (idxSection % 4)) / 4)
            model = feedRenderViewModels[position]
        }
        
        let subSection = idxSection % 4
        
        if subSection == 0 {
            // header
            switch model.header.renderType {
            case .header(let user):
                let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedHeaderTableViewCell.identifier, for: indexPath) as! NewsFeedHeaderTableViewCell
                
                cell.configure(with: user)
                cell.delegate = self
                return cell
            case .comments, .actions, .primaryContent: return UITableViewCell()
            }
        }
        else if subSection == 1 {
            // post
            switch model.post.renderType {
            case .primaryContent(let post):
                let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedContentTableViewCell.identifier, for: indexPath) as! NewsFeedContentTableViewCell
                cell.configure(with: post)
                return cell
            case .comments, .actions, .header: return UITableViewCell()
            }
        }
        else if subSection == 2 {
            // actions
            switch model.actions.renderType {
            case .actions(let provider):
                let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedActionTableViewCell.identifier, for: indexPath) as! NewsFeedActionTableViewCell
                cell.delegate = self
                return cell
            case .header, .primaryContent, .comments: return UITableViewCell()
            }
        }
        else if subSection == 3 {
            // comment
            switch model.comments.renderType {
            case .comments(let comments):
                let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedGeneralTableViewCell.identifier, for: indexPath) as! NewsFeedGeneralTableViewCell
                return cell
            case .header, .primaryContent, .actions: return UITableViewCell()
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let subSection = indexPath.section % 4
        
        if subSection == 0 {
            return 70
        }
        else if subSection == 1 {
            return tableView.frame.width
        }
        else if subSection == 2 {
            return 60
        }
        else if subSection == 3 {
            return 50
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let subSection = section % 4
        return subSection == 3 ? 70 : 0
    }
}

extension NewsFeedViewController: NewsFeedHeaderTableViewCellDelegate {
    func didTapMoreButton() {
        let actionSheet = UIAlertController(title: "게시물 옵션", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "신고", style: .destructive, handler: { [weak self] _ in
            self?.reportPost()
        }))
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    func reportPost() {
        print("reportPost Tapped")
    }
    
    
}

extension NewsFeedViewController: NewsFeedActionTableViewCellDelegate {
    func didTapLikeButton() {
        print("Like Button Tapped")
    }
    
    func didTapCommentButton() {
        print("Comment Button Tapped")
    }
    
    func didTapSendButton() {
        print("Send Button Tapped")
    }
    
    
}

extension NewsFeedViewController: NewsFeedGeneralTableViewCellDelegate {
    
}
