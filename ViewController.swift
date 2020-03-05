//
//  ViewController.swift
//  Freindsta_Project_1
//
//  Created by Lance Samaria on 3/5/20.
//  Copyright © 2020 Lance Samaria. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    //MARK:- UIElements
    fileprivate lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        button.layer.cornerRadius = 7
        button.layer.masksToBounds = true
        return button
    }()
    
    //MARK:- Properties
    fileprivate var postDate: Double?
    fileprivate var expoDate: Double?
    
    
    // MARK:- View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setnavigationAppearance()
        
        configureAnchors()
    }
    
    fileprivate func setnavigationAppearance() {
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    //MARK:- Target Actions
    @objc fileprivate func nextButtonPressed() {
        
        let chatVC = ChatController()
        navigationController?.pushViewController(chatVC, animated: true)
    }
    
    //MARK:- Anchors
    fileprivate func configureAnchors() {
        view.addSubview(nextButton)
        nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        nextButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    //MARK:- Deinit
    deinit {
        print("ViewController - DEINIT")
    }
}
