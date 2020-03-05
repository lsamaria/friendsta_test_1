//
//  ChatController.swift
//  Freindsta_Project_1
//
//  Created by Lance Samaria on 3/5/20.
//  Copyright © 2020 Lance Samaria. All rights reserved.
//

import UIKit
import UserNotifications



protocol ChatControllerDelegate: class {
    func sendBackPostAndExpoDate(postDate: Double, expoDate: Double)
}

class ChatController: UIViewController {
    
    //MARK:- UIElements
    fileprivate lazy var colllectionView: UICollectionView  = {
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(ChatCell.self, forCellWithReuseIdentifier: chatCell)
        
        return collectionView
    }()
    
    fileprivate lazy var dummySearchBar: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "    Search"
        label.font = UIFont.systemFont(ofSize: 21)
        label.textColor = .red
        label.textAlignment = .left
        label.backgroundColor = .blue
        return label
    }()
    
    fileprivate lazy var notificationButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.setTitle("Enable Notifications", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        
        let yellowColor = hexStringToUIColor(hex: "ffffcc")
        
        button.backgroundColor = yellowColor
        button.addTarget(self, action: #selector(notificationButtonPressed), for: .touchUpInside)
        
        button.layer.cornerRadius = notificationButtonCorners
        button.layer.masksToBounds = true
        button.sizeToFit()
        
        return button
    }()
    
    //MARK:- Properties
    weak var delegate: ChatControllerDelegate?
    
    fileprivate var tableData = [String]()
    fileprivate let chatCell = "ChatCell"
    
    fileprivate let notificationNormalHeight: CGFloat = 60
    
    fileprivate let notificationButtonCorners: CGFloat = 0 // use this to change the
    
    //MARK:- View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureNotifications()
        
        configureAnchors()
        
        createData()
        
        set2LinesOfTextForNotifcationButton()
        decideWetherOrToEnableNotifications()
    }
    
    //MARK:- Target Actions
    fileprivate func createData() {
        tableData.append("0")
        tableData.append("1")
        tableData.append("2")
        tableData.append("3")
        tableData.append("4")
        tableData.append("5")
        tableData.append("6")
        tableData.append("7")
        tableData.append("8")
        tableData.append("9")
        tableData.append("10")
        colllectionView.reloadData()
    }
    
    @objc fileprivate func notificationButtonPressed() {
        
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        DispatchQueue.main.async {
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                })
            } else {
                print("Settings URL did Not Open")
            }
        }
    }
    
    //MARK:-Helper Functions
    fileprivate func decideWetherOrToEnableNotifications() {
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                // Already authorized
                
                DispatchQueue.main.async { [weak self] in
                    self?.toggleNotificationButtonHeightToZero()
                }
                
            } else {
                // Either denied or notDetermined
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                    (granted, error) in
                    // add your own
                    //UNUserNotificationCenter.current().delegate = self
                    if !granted {
                        print("not granted")
                        
                        DispatchQueue.main.async { [weak self] in
                            self?.toggleNotificationButtonHeightToNormalHeight()
                        }
                        
                    } else {
                        print("granted")
                    }
                }
            }
        }
    }
    
    public func set2LinesOfTextForNotifcationButton() {
        
        let button = self.notificationButton
        
        //getting the range to separate the button title strings
        //let buttonText = "\(buttonTitle)\n\(String(numOfFollowing))" as NSString
        let buttonText = "Notifications are off\nTap to re-enable" as NSString
        let newlineRange: NSRange = buttonText.range(of: "\n")
        
        //getting both substrings
        var substring1 = ""
        var substring2 = ""

        if(newlineRange.location != NSNotFound) {
            substring1 = buttonText.substring(to: newlineRange.location)
            substring2 = buttonText.substring(from: newlineRange.location)
        }
        
        let attrString1 = NSMutableAttributedString(string: substring1,
                                                    attributes: [NSMutableAttributedString.Key.font:
                                                        UIFont.boldSystemFont(ofSize: 16),
                                                                 NSMutableAttributedString.Key.foregroundColor: UIColor.black])
        
        let attrString2 = NSMutableAttributedString(string: substring2,
                                                    attributes: [NSMutableAttributedString.Key.font:
                                                        UIFont.systemFont(ofSize: 14),
                                                                 NSMutableAttributedString.Key.foregroundColor: UIColor.black])

        //appending both attributed strings
        attrString1.append(attrString2) //<<
        button.setAttributedTitle(attrString1, for: [])
    }
    
    //MARK:- Anchors
    fileprivate var notificationButtonHeightConstraint: NSLayoutConstraint?
    fileprivate func configureAnchors() {
        
        notificationButtonHeightConstraint?.isActive = false
        
        view.addSubview(notificationButton)
        view.addSubview(dummySearchBar)
        view.addSubview(colllectionView)
        
        notificationButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        notificationButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        notificationButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        notificationButtonHeightConstraint = notificationButton.heightAnchor.constraint(equalToConstant: notificationNormalHeight)
        notificationButtonHeightConstraint?.isActive = true
        
        dummySearchBar.topAnchor.constraint(equalTo: notificationButton.bottomAnchor).isActive = true
        dummySearchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        dummySearchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        dummySearchBar.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        colllectionView.topAnchor.constraint(equalTo: dummySearchBar.bottomAnchor).isActive = true
        colllectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        colllectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        colllectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    fileprivate func toggleNotificationButtonHeightToZero() {
        notificationButtonHeightConstraint?.isActive = false
        notificationButtonHeightConstraint = notificationButton.heightAnchor.constraint(equalToConstant: 0)
        notificationButtonHeightConstraint?.isActive = true
    }
    
    fileprivate func toggleNotificationButtonHeightToNormalHeight() {
        notificationButtonHeightConstraint?.isActive = false
        notificationButtonHeightConstraint = notificationButton.heightAnchor.constraint(equalToConstant: notificationNormalHeight)
        notificationButtonHeightConstraint?.isActive = true
    }
    
    //MARK:- Deinit
    deinit {
        print("ChatVC -DEINIT")
    }
}

//MARK: UICollectionView Delegate
extension ChatController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: chatCell, for: indexPath) as! ChatCell
        
        cell.resetProperties()
        cell.textStr = tableData[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        
        return CGSize(width: width, height: 40)
    }
}

extension ChatController {
    
    fileprivate func configureNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(appHasEnteredBackground), name: UIApplication.willResignActiveNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
    }
    
    @objc fileprivate func appHasEnteredBackground() {
        
    }
    
    @objc fileprivate func appWillEnterForeground() {
        
        decideWetherOrToEnableNotifications()
    }
}
