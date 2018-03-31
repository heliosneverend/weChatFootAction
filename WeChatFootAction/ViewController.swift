//
//  ViewController.swift
//  WeChatFootAction
//
//  Created by RRD on 2018/3/31.
//  Copyright © 2018年 RRD. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var button:UIButton = {
        let button = UIButton(frame:CGRect(x:100, y:200, width: 100, height:50))
        button.setTitle("Helios", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(buttonSender), for: .touchUpInside)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(button)
        // Do any additional setup after loading the view, typically from a nib.
    }

    @objc func buttonSender() {
        let option1 = SelectViewInfo(title: "语音通话", color: nil)
        let option2 = SelectViewInfo(title: "视频聊天", color: nil)
        FootActionView.show(title: "请选择聊天方式？", options: [option1, option2], cancelTitle: nil, selectCallBack: { index in
            print(index)
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

