//
//  FootActionView.swift
//  WeChatFootAction
//
//  Created by RRD on 2018/3/31.
//  Copyright © 2018年 RRD. All rights reserved.
//

import UIKit

private let DefaultHeight: CGFloat = 50.0
private let CancelButtonPadding:CGFloat = 8.0
private let CellHeight:CGFloat = 50
private let CellCount:CGFloat = 4.0
private let DefaultFont = UIFont.systemFont(ofSize: 16)

public struct SelectViewInfo {
    public var title: String?
    public var color: UIColor?
    
    public init(title: String?, color: UIColor?) {
        self.title = title
        self.color = color
    }
}


open class FootActionView: UIView {
  
    var coverView: UIView!
    var contentView: UIView!
    var titleLabel: UILabel!
    var optionTableView: UITableView!
    
    var title: String?
    var cancelTitle: SelectViewInfo?
    var contentViewH: CGFloat!
    var tableViewH: CGFloat!
    var options: [SelectViewInfo]!
    
    var selectCallBack: ((_ index: Int) -> Void)?
    var cancelCallBack: (() -> Void)?
    
    
    init(title: String?, options: [SelectViewInfo], cancelTitle: SelectViewInfo?, selectCallBack: ((_ index: Int) -> Swift.Void)?, cancelCallBack: (() -> Swift.Void)?) {
        super.init(frame: UIScreen.main.bounds)
        self.title = title
        self.options = options
        self.cancelTitle = cancelTitle
        self.selectCallBack = selectCallBack
        self.cancelCallBack = cancelCallBack
        
        let count = CGFloat(options.count)
        tableViewH = (count <= CellCount ? count : 4) * CellHeight
        contentViewH = CancelButtonPadding + CGFloat(tableViewH) + (title == nil ? DefaultHeight : DefaultHeight * 2)
        
        setupView()
    }
    class open func show(title: String?, options: [SelectViewInfo], cancelTitle: SelectViewInfo?, selectCallBack: ((_ index: Int) -> Swift.Void)?) {
        FootActionView(title: title, options: options, cancelTitle: cancelTitle, selectCallBack: selectCallBack, cancelCallBack: nil).showSelectView()
    }
    
    class open func show(title: String?, options: [SelectViewInfo], cancelTitle: SelectViewInfo?, selectCallBack: ((_ index: Int) -> Swift.Void)?, cancelCallBack: (() -> Swift.Void)?) {
        FootActionView(title: title, options: options, cancelTitle: cancelTitle, selectCallBack: selectCallBack, cancelCallBack: cancelCallBack).showSelectView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
// MARK: - 初始化
private extension FootActionView {
    
    func setupView() {
        // 设置背景
        coverView = UIView(frame: self.bounds)
        coverView.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        coverView.alpha = 0
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapBgViewOrCancel))
        coverView.addGestureRecognizer(tap)
        addSubview(coverView)
        
        // 内容
        contentView = UIView(frame: CGRect(x: 0, y: frame.height, width: frame.width, height: contentViewH))
        contentView.backgroundColor = UIColor.groupTableViewBackground
        addSubview(contentView)
        
        // 标题
        if let title = title {
            let titleBgView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: DefaultHeight))
            titleBgView.backgroundColor = UIColor.groupTableViewBackground
            titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: DefaultHeight - 0.5))
            titleLabel.text = title
            titleLabel.font = UIFont.systemFont(ofSize: 13)
            titleLabel.backgroundColor = UIColor.white
            titleLabel.textColor = UIColor.lightGray
            titleLabel.textAlignment = .center
            titleBgView.addSubview(titleLabel)
            contentView.addSubview(titleBgView)
        }
        
        // 设置选项列表
        let tableViewY = titleLabel == nil ? 0 : DefaultHeight
        let optionTableViewF = CGRect(x: 0, y: tableViewY, width: frame.width, height: CGFloat(tableViewH))
        optionTableView = UITableView(frame: optionTableViewF, style: .grouped)
        optionTableView.register(SelectCell.self, forCellReuseIdentifier: "SelectCell")
        optionTableView.showsVerticalScrollIndicator = false
        optionTableView.showsHorizontalScrollIndicator = false
        if #available(iOS 11.0, *) {
            optionTableView.contentInsetAdjustmentBehavior = .never
        }
        optionTableView.estimatedRowHeight = 0
        optionTableView.estimatedSectionHeaderHeight = 0
        optionTableView.estimatedSectionFooterHeight = 0
        optionTableView.dataSource = self
        optionTableView.delegate = self
        optionTableView.separatorStyle = .none
        optionTableView.bounces = false
        optionTableView.isScrollEnabled = CGFloat(options.count) > CellCount
        contentView.addSubview(optionTableView)
        
        // 取消按钮
        let cancelButton = UIButton(frame: CGRect(x: 0, y: contentView.bounds.height - DefaultHeight, width: frame.width, height: DefaultHeight))
        cancelButton.setTitle(cancelTitle == nil ? "取消" : cancelTitle?.title, for: .normal)
        cancelButton.setTitleColor(cancelTitle == nil ? UIColor.darkGray : cancelTitle?.color, for: .normal)
        cancelButton.titleLabel?.font = DefaultFont
        cancelButton.backgroundColor = UIColor.white
        cancelButton.addTarget(self, action: #selector(tapBgViewOrCancel), for: .touchUpInside)
        contentView.addSubview(cancelButton)
    }
    
    func showSelectView() {
        UIApplication.shared.keyWindow?.addSubview(self)
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.7, options: .curveEaseInOut, animations: {
            self.coverView.alpha = 1.0
            self.contentView.transform = CGAffineTransform(translationX: 0, y: -self.contentView.bounds.height)
        }, completion: nil)
    }
    
    @objc func tapBgViewOrCancel() {
        if cancelCallBack != nil {
            cancelCallBack!()
        }
        close()
    }
    
    @objc func close() {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.7, options: .curveEaseInOut, animations: {
            self.coverView.alpha = 0.0
            self.contentView.transform = CGAffineTransform.identity
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
}

extension  FootActionView: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCell", for: indexPath) as! SelectCell
        cell.titleLabel.text = options[indexPath.row].title
        if let color = options[indexPath.row].color {
            cell.titleLabel.textColor = color
        }
        return cell
    }
}

extension FootActionView: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CellHeight
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if selectCallBack != nil {
            selectCallBack!(indexPath.row)
        }
        close()
    }
}

