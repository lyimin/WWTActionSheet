//
//  WWTActionSheetContentView.swift
//  WWTita
//
//  Created by EamonLiang on 2019/7/17.
//  Copyright © 2019 wewave Inc. All rights reserved.
//

import UIKit



class WWTActionSheetContentView: UIView {
    
    typealias OnItemDidPressAction = (_ item: WWTActionSheetItem) -> Void
    var itemDidPress: OnItemDidPressAction?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(otherItemBGView)
        addSubview(titleLabel)
        addSubview(messageLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let otherItemViews = itemViews.filter {
            $0.item.style != .Cancel
        }
        
        let cancelView = itemViews.filter {
            $0.item.style == .Cancel
            }.first
        
        for i in 0..<otherItemViews.count {
            let itemView = otherItemViews[i]
            itemView.frame = CGRect(x: 0, y: CGFloat(i) * WWTActionSheetItem.itemHeight, width: frame.width, height: WWTActionSheetItem.itemHeight)
            if i == otherItemViews.count - 1 {
                otherItemBGView.frame = CGRect(x: 0, y: 0, width: frame.width, height: itemView.frame.maxY)
            }
            itemView.lineView.isHidden = i == otherItemViews.count - 1
        }
        
        if let item = cancelView {
            item.frame = CGRect(x: 0, y: frame.height - WWTActionSheetItem.itemHeight, width: frame.width, height: WWTActionSheetItem.itemHeight)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func add(item: WWTActionSheetItem) {
        
        let itemView = WWTActionSheetItemView()
        itemView.item = item
        addSubview(itemView)
        itemViews.append(itemView)
        
        layoutIfNeeded()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onItemDidPress(tap:)))
        itemView.addGestureRecognizer(tap)
    }
    
    @objc private func onItemDidPress(tap: UITapGestureRecognizer) {
        
        if let action = itemDidPress {
            let itemView = tap.view as! WWTActionSheetItemView
            action(itemView.item)
        }
    }
    
    //MARK: >> Private Property
    //------------------------------------------------------------------------
    
    var hasCancel: Bool {
        get {
            var flag = false
            itemViews.forEach {
                if $0.item.style == .Cancel {
                    flag = true
                }
            }
            return flag
        }
    }
    
    fileprivate(set) var itemViews: [WWTActionSheetItemView] = []
    
    fileprivate(set) lazy var titleLabel: UILabel = {
        
        var titleLabel = UILabel()
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        return titleLabel
    }()
    
    fileprivate(set) lazy var messageLabel: UILabel = {
        
        var messageLabel = UILabel()
        messageLabel.textColor = .gray
        messageLabel.font = UIFont.systemFont(ofSize: 13)
        return messageLabel
    }()
    
    fileprivate lazy var otherItemBGView: UIView = {
        
        var otherItemBGView = UIView()
        otherItemBGView.layer.cornerRadius = 8
        otherItemBGView.backgroundColor = .white
        return otherItemBGView
    }()
}


class WWTActionSheetItemView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        addSubview(titleLabel)
        addSubview(lineView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = self.bounds
        lineView.frame = CGRect(x: 0, y: frame.height - lineViewHeight, width: frame.width, height: lineViewHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var item: WWTActionSheetItem! {
        didSet {
            self.titleLabel.text = item.title
            
            switch item.style {
            case .Destructive:
                titleLabel.textColor = UIColor(red: 255.0/255.0, green: 40.0/255.0, blue: 0, alpha: 1)
            default:
                titleLabel.textColor = UIColor(red: 51.0/255.0, green:  51.0/255.0, blue:  51.0/255.0, alpha: 1)
            }
            
            if item.style == .Cancel {
                backgroundColor = .white
                layer.cornerRadius = 8
                lineView.isHidden = true
            }
        }
    }
    
    private var lineViewHeight: CGFloat = 1
    
    private lazy var titleLabel: UILabel = {
        
        var titleLabel = UILabel()
        titleLabel.textColor = UIColor(red: 51.0/255.0, green:  51.0/255.0, blue:  51.0/255.0, alpha: 1)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    private(set) lazy var lineView: UIView = {
        
        var lineView = UIView()
        lineView.backgroundColor = UIColor(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1)
        return lineView
    }()
}
