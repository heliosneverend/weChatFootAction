//
//  SelectCell.swift
//  WeChatFootAction
//
//  Created by RRD on 2018/3/31.
//  Copyright © 2018年 RRD. All rights reserved.
//

import UIKit
//titleLabel
class SelectCell: UITableViewCell {
    lazy var titleLabel:UILabel = {
        let lable = UILabel(frame:CGRect(x:0 , y:0 ,width:UIScreen.main.bounds.size.width, height: self.frame.height))
        lable.textAlignment = .center
        return lable
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.contentView.addSubview(titleLabel)
    }
}

