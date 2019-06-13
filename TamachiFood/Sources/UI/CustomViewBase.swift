//
//  CustomViewBase.swift
//  TamachiFood
//
//  Created by sato.ken on 2019/06/13.
//  Copyright © 2019 佐藤賢. All rights reserved.
//

import UIKit

class CustomViewBase: UIView {
    // コンテンツ表示用のView
    weak var contentView: UIView!
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        initContentView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initContentView()
    }
    
    // コンテンツ表示用Viewの初期化処理
    private func initContentView() {
        let viewClass: AnyClass = type(of: self)
        
        contentView = Bundle(for: viewClass).loadNibNamed(String(describing: viewClass), owner: self, options: nil)?.first as? UIView
        contentView.autoresizingMask = autoresizingMask
        contentView.bounds = bounds
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        
        // 上下左右に0の制約を追加する
        let bindings = ["view": contentView as Any]
        let contentViewConstraintH = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[view]|",
            options: NSLayoutConstraint.FormatOptions(rawValue: 0),
            metrics: nil,
            views: bindings
        )
        let contentViewConstraintV = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[view]|",
            options: NSLayoutConstraint.FormatOptions(rawValue: 0),
            metrics: nil,
            views: bindings
        )
        addConstraints(contentViewConstraintH)
        addConstraints(contentViewConstraintV)
        
        initWith()
    }
    
    // このメソッドは継承先のカスタムビューのInitialize時に使用する
    func initWith() {}
}
