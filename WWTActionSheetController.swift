//
//  WWTActionSheetController.swift
//  WWTita
//
//  Created by EamonLiang on 2019/7/17.
//  Copyright © 2019 wewave Inc. All rights reserved.
//

import UIKit


@objc enum WWTActionSheetItemStyle: NSInteger {
    case Default
    case Cancel
    case Destructive
}


@objc class WWTActionSheetItem: NSObject {
    
    static let margin: CGFloat = 16
    static let itemHeight: CGFloat = 52
    
    typealias ActionSheetItemAction = (_ item: WWTActionSheetItem) -> Void
    
    @objc private(set) var title: String?
    private(set) var style: WWTActionSheetItemStyle
    private(set) var action: ActionSheetItemAction?
    
    @objc class func item(title: String?, style: WWTActionSheetItemStyle = .Default, action: ActionSheetItemAction?) -> WWTActionSheetItem {

        return WWTActionSheetItem(title: title, style: style, action: action)
    }
    
    @objc init(title: String?, style: WWTActionSheetItemStyle = .Default, action: ActionSheetItemAction?) {
        
        self.title = title
        self.style = style
        self.action = action
    }
}

@objcMembers
class WWTActionSheetController: UIViewController {
    
    private var transition = WWTActionSheetTransiton()
    init() {
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .overCurrentContext
        transitioningDelegate = transition
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        view.addSubview(coverView)
        view.addSubview(contentView)
    }
    
    @objc private func onCoverViewPressAction() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        coverView.frame = view.bounds
        
        var contentH = CGFloat(contentView.itemViews.count) * WWTActionSheetItem.itemHeight
        if contentView.hasCancel {
            contentH += 8
        }
        let x: CGFloat = WWTActionSheetItem.margin
        let width: CGFloat = self.view.frame.width - 2*WWTActionSheetItem.margin
        let height: CGFloat = contentH
        var y: CGFloat = self.view.frame.height - height - WWTActionSheetItem.margin
        if isiPhoneX() {
            y -= 34
        }
        contentView.frame = CGRect(x: x, y: y, width: width, height: height)
    }
    
    //MARK: >> Public Property
    //------------------------------------------------------------------------
    
    var actionSheetTitle: String? {
        didSet {
            contentView.titleLabel.text = actionSheetTitle
        }
    }
    
    var message: String? {
        didSet {
            contentView.messageLabel.text = message
        }
    }
    
    var titleFont: UIFont = UIFont.systemFont(ofSize: 13) {
        didSet {
            contentView.titleLabel.font = titleFont
        }
    }
    
    var titleTextColor: UIColor = UIColor.black {
        didSet {
            contentView.titleLabel.textColor = titleTextColor
        }
    }
    
    var messageFont: UIFont = UIFont.systemFont(ofSize: 13) {
        didSet {
            contentView.messageLabel.font = messageFont
        }
    }
    
    var messageTextColor: UIColor = .gray {
        didSet {
            contentView.messageLabel.textColor = messageTextColor
        }
    }
    
    //MARK: >> Private Property
    //------------------------------------------------------------------------
    fileprivate(set) lazy var contentView: WWTActionSheetContentView = {
        
        var contentView = WWTActionSheetContentView()
        contentView.itemDidPress = { [unowned self](item: WWTActionSheetItem) -> Void in
            
            // 点击取消
            if item.style == .Cancel {
                self.dismiss(animated: true, completion: nil)
                if let action = item.action {
                    action(item)
                }
                return
            }
            
            if let action = item.action {
                self.dismiss(animated: true, completion: nil)
                action(item)
            }
        }
        return contentView
    }()
    
    fileprivate(set) lazy var coverView: UIView = {
        
        var coverView = UIView()
        coverView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.48)
        let tap = UITapGestureRecognizer(target: self, action: #selector(onCoverViewPressAction));
        view.addGestureRecognizer(tap)
        return coverView
    }()
}

@objc
extension WWTActionSheetController {
    
    public func add(item: WWTActionSheetItem) {
        contentView.add(item: item)
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
}

//MARK: >> Public
//------------------------------------------------------------------------

extension WWTActionSheetController {
    
    private func isiPhoneX() -> Bool {
        
        if #available(iOS 11.0, *) {
            if UI_USER_INTERFACE_IDIOM() == .phone {
                let window = UIApplication.shared.windows.first
                let safeAreaBottom = window!.safeAreaInsets.bottom
                return safeAreaBottom > 0
            }
        }
        return false
    }
}
