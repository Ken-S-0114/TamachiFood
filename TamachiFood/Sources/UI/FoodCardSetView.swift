//
//  FoodCardSetView.swift
//  TamachiFood
//
//  Created by sato.ken on 2019/06/13.
//  Copyright © 2019 佐藤賢. All rights reserved.
//

import Foundation
import UIKit

protocol FoodCardSetViewProtocol: NSObject {
    // ドラッグ開始時に実行されるアクション
    func beganDragging()
    // 位置の変化が生じた際に実行されるアクション
    func updatePosition()
    // 左側へのスワイプ動作が完了した場合に実行されるアクション
    func swipedLeftPosition()
    // 右側へのスワイプ動作が完了した場合に実行されるアクション
    func swipedRightPosition()
    // 元の位置に戻る動作が完了したに実行されるアクション
    func returnToOriginalPosition()
}

class FoodCardSetView: CustomViewBase {
    @IBOutlet private weak var storeNameLabel: UILabel!
    @IBOutlet private weak var foodNameLabel: UILabel!
    @IBOutlet private weak var remarkLabel: UILabel!
    @IBOutlet private weak var foodImageView: UIImageView!
    @IBOutlet private weak var readmoreButton: UIButton!
    
    private var initialCenter: CGPoint = CGPoint(
        x: UIScreen.main.bounds.size.width / 2,
        y: UIScreen.main.bounds.size.height / 2
    )
    
    private var initialTransform: CGAffineTransform = .identity
    private var originalPoint: CGPoint = CGPoint.zero
    
    private var xPositionFromCenter: CGFloat = 0.0
    private var yPositionFromCenter: CGFloat = 0.0
    
    private var currentMoveXPercentFromCenter: CGFloat = 0.0
    private var currentMoveYPercentFromCenter: CGFloat = 0.0
    
    private let durationOfInitialize: TimeInterval = FoodCardDefaultSettings.durationOfInitialize
    private let durationOfStartDragging: TimeInterval = FoodCardDefaultSettings.durationOfStartDragging
    
    private let durationOfReturnOriginal: TimeInterval = FoodCardDefaultSettings.durationOfReturnOriginal
    private let durationOfSwipeOut: TimeInterval = FoodCardDefaultSettings.durationOfSwipeOut
    
    private let startDraggingAlpha: CGFloat = FoodCardDefaultSettings.startDraggingAlpha
    private let stopDraggingAlpha: CGFloat = FoodCardDefaultSettings.stopDraggingAlpha
    private let maxScaleOfDragging: CGFloat = FoodCardDefaultSettings.maxScaleOfDragging
    
    private let swipeXPosLimitRatio: CGFloat = FoodCardDefaultSettings.swipeXPosLimitRatio
    private let swipeYPosLimitRatio: CGFloat = FoodCardDefaultSettings.swipeYPosLimitRatio
    
    private let beforeInitializeScale: CGFloat = FoodCardDefaultSettings.beforeInitializeScale
    private let afterInitializeScale: CGFloat = FoodCardDefaultSettings.afterInitializeScale
    
    // FoodCardSetDelegate のインスタンス宣言
    weak var delegate: FoodCardSetViewProtocol?
    
    var readMoreButtonAction: (() -> Void)?
    
    var index: Int = 0
    
    override func initWith() {
        setupFoodCardSetView()
    }
    
    // Viewに対する初期設定
    private func setupFoodCardSetView() {
        clipsToBounds = true
        backgroundColor = FoodCardDefaultSettings.backgroundColor
        frame = CGRect(
            origin: CGPoint.zero,
            size: CGSize(
                width: FoodCardDefaultSettings.cardSetViewWidth,
                height: FoodCardDefaultSettings.cardSetViewHeight
            )
        )
        
        layer.masksToBounds = false
        layer.borderColor = FoodCardDefaultSettings.backgroundBorderColor
        layer.borderWidth = FoodCardDefaultSettings.backgroundBorderWidth
        layer.cornerRadius = FoodCardDefaultSettings.backgroundCornerRadius
        layer.shadowRadius = FoodCardDefaultSettings.backgroundShadowRadius
        layer.shadowOpacity = FoodCardDefaultSettings.backgroundShadowOpacity
        layer.shadowOffset = FoodCardDefaultSettings.backgroundShadowOffset
        layer.shadowColor = FoodCardDefaultSettings.backgroundBorderColor
    }
    
    @objc func readMoreButtonTapped() {
        readMoreButtonAction?()
    }
    
    @objc func startDragging() {}
    
    // Viewのボタンに対する初期設定
    private func setupReadMoreButton() {
        readmoreButton.addTarget(self, action: #selector(readMoreButtonTapped), for: .touchUpInside)
    }
    
    private func setupPanGestureRecognizer() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(startDragging))
        addGestureRecognizer(panGestureRecognizer)
    }
}
