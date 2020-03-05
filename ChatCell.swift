//
//  ChatCell.swift
//  Freindsta_Project_1
//
//  Created by Lance Samaria on 3/5/20.
//  Copyright © 2020 Lance Samaria. All rights reserved.
//

import UIKit


class ChatCell: UICollectionViewCell {
    
    fileprivate lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 19)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    //MARK:- Properties
    public var textStr: String? {
        didSet {
            
            guard let textStr = textStr else { return }
            
            textLabel.text = textStr
            
            configureAnchors()
        }
    }
    
    //MARK:- Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    //MARK:- Helper Functions
    public func resetProperties() {
        textLabel.text = nil
    }
    
    //MARK:- Anchors
    fileprivate func configureAnchors() {
        contentView.addSubview(textLabel)
        textLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    //MARK:- Deinit
    deinit {
        print("ChatCell -DEINIT")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
