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
    func beganDragging(_ cardView: FoodCardSetView)
    // 位置の変化が生じた際に実行されるアクション
    func updatePosition(_ cardView: FoodCardSetView, centerX: CGFloat, centerY: CGFloat)
    // 左側へのスワイプ動作が完了した場合に実行されるアクション
    func swipedLeftPosition(_ cardView: FoodCardSetView)
    // 右側へのスワイプ動作が完了した場合に実行されるアクション
    func swipedRightPosition(_ cardView: FoodCardSetView)
    // 元の位置に戻る動作が完了したに実行されるアクション
    func returnToOriginalPosition(_ cardView: FoodCardSetView)
}

class FoodCardSetView: CustomViewBase {
    @IBOutlet private weak var storeNameLabel: UILabel!
    @IBOutlet private weak var foodNameLabel: UILabel!
    @IBOutlet private weak var remarkLabel: UILabel!
    // @IBOutlet private weak var foodImageView: UIImageView!
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
        setupReadMoreButton()
        setupPanGestureRecognizer()
        setupSlopeAndIntercept()
    }
    
    func setData() {
        storeNameLabel.text = "Sample"
        foodNameLabel.text = "SampleSample"
        remarkLabel.text = "New"
        // foodImageView.image = UIImage.init()
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
    
    @objc private func readMoreButtonTapped() {
        readMoreButtonAction?()
    }
    
    // ドラッグが開始された際に実行される処理
    @objc private func startDragging(_ sender: UIPanGestureRecognizer) {
        // 中心位置からのX軸＆Y軸方向の位置の値を更新する
        xPositionFromCenter = sender.translation(in: self).x
        yPositionFromCenter = sender.translation(in: self).y
        
        switch sender.state {
        case .began:
            // ドラッグ処理開始時のViewがある位置を取得
            originalPoint = CGPoint(
                x: center.x - xPositionFromCenter,
                y: center.y - yPositionFromCenter
            )
            delegate?.beganDragging(self)
            // Debug.
            debugPrint("beganCenterX:", originalPoint.x)
            debugPrint("beganCenterY:", originalPoint.y)
            
            UIView.animate(withDuration: durationOfStartDragging, delay: 0.0, options: [.curveEaseInOut], animations: {
                self.alpha = self.startDraggingAlpha
            }, completion: nil)
            
        case .changed:
            let newCenterX = originalPoint.x + xPositionFromCenter
            let newCenterY = originalPoint.y + yPositionFromCenter
            center = CGPoint(x: newCenterX, y: newCenterY)
            
            delegate?.updatePosition(self, centerX: newCenterX, centerY: newCenterY)
            
            currentMoveXPercentFromCenter = min(xPositionFromCenter / UIScreen.main.bounds.size.width, 1)
            currentMoveYPercentFromCenter = min(yPositionFromCenter / UIScreen.main.bounds.size.height, 1)
            
            // Debug.
            debugPrint("currentMoveXPercentFromCenter:", currentMoveXPercentFromCenter)
            debugPrint("currentMoveYPercentFromCenter:", currentMoveYPercentFromCenter)
            
            let initialRotationAngle = atan2(initialTransform.b, initialTransform.a)
            let whenDraggingRotationAngel = initialRotationAngle + CGFloat.pi / 10 * currentMoveXPercentFromCenter
            let transforms = CGAffineTransform(rotationAngle: whenDraggingRotationAngel)
            
            let scaleTransform: CGAffineTransform = transforms.scaledBy(x: maxScaleOfDragging, y: maxScaleOfDragging)
            transform = scaleTransform
            
        case .ended, .cancelled:
            let whenEndedVelocity = sender.velocity(in: self)
            // Debug.
            debugPrint("whenEndedVelocity:", whenEndedVelocity)
            
            let shouldMoveToLeft = (currentMoveXPercentFromCenter < -swipeXPosLimitRatio && abs(currentMoveYPercentFromCenter) > swipeYPosLimitRatio)
            let shouldMoveToRight = (currentMoveXPercentFromCenter > swipeXPosLimitRatio && abs(currentMoveYPercentFromCenter) > swipeYPosLimitRatio)
            
            if shouldMoveToLeft {} else if shouldMoveToRight {} else {}
            
            originalPoint = CGPoint.zero
            xPositionFromCenter = 0.0
            yPositionFromCenter = 0.0
            currentMoveXPercentFromCenter = 0.0
            currentMoveYPercentFromCenter = 0.0
            
        default:
            break
        }
    }
    
    // Viewのボタンに対する初期設定
    private func setupReadMoreButton() {
        readmoreButton.addTarget(self, action: #selector(readMoreButtonTapped), for: .touchUpInside)
    }
    
    // UIPanGestureRecognizerの付与
    private func setupPanGestureRecognizer() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(startDragging))
        addGestureRecognizer(panGestureRecognizer)
    }
    
    // Viewの初期状態での傾きと切片の付与を行う
    private func setupSlopeAndIntercept() {
        // 中心位置のゆらぎを表現する値を設定
        let fluctuationsPosX: CGFloat = CGFloat(Int.createRandom(range: Range(-8 ... 8)))
        let fluctuationsPosY: CGFloat = CGFloat(Int.createRandom(range: Range(-8 ... 8)))
        
        let initialCenterPosX: CGFloat = UIScreen.main.bounds.size.width / 2
        let initialCenterPosY: CGFloat = UIScreen.main.bounds.size.height / 2
        
        // 配置したViewに関する中心位置を算出する
        initialCenter = CGPoint(
            x: initialCenterPosX + fluctuationsPosX,
            y: initialCenterPosY + fluctuationsPosY
        )
        
        // 傾きのゆらぎを表現する値を設定する
        let fluctuationsRotateAngle: CGFloat = CGFloat(Int.createRandom(range: Range(-6 ... 6)))
        let angle = fluctuationsRotateAngle * .pi / 180.0 * 0.25
        
        initialTransform = CGAffineTransform(rotationAngle: angle)
        initialTransform.scaledBy(x: afterInitializeScale, y: afterInitializeScale)
        
        moveInitialPosition()
    }
    
    // カードを初期配置する位置へ戻す
    private func moveInitialPosition() {
        let beforeInitializePosX: CGFloat = CGFloat(Int.createRandom(range: Range(-300 ... 300)))
        let beforeInitializePosY: CGFloat = CGFloat(-Int.createRandom(range: Range(300 ... 600)))
        let beforeInitializeCenter = CGPoint(x: beforeInitializePosX, y: beforeInitializePosY)
        
        let beforeInitializeRotateAngle: CGFloat = CGFloat(Int.createRandom(range: Range(-90 ... 90)))
        let angle = beforeInitializeRotateAngle * .pi / 180.0
        let beforeInitializeTransform = CGAffineTransform(rotationAngle: angle)
        beforeInitializeTransform.scaledBy(x: beforeInitializeScale, y: beforeInitializeScale)
        
        alpha = 0
        center = beforeInitializeCenter
        transform = beforeInitializeTransform
        
        UIView.animate(withDuration: durationOfInitialize, animations: {
            self.alpha = 1
            self.center = self.initialCenter
            self.transform = self.initialTransform
        })
    }
    
    // カードを元の位置へ戻す
    private func moveOriginalPosition() {
        UIView.animate(withDuration: durationOfReturnOriginal, delay: 0.0, usingSpringWithDamping: 0.68, initialSpringVelocity: 0.0, options: [.curveEaseInOut], animations: {
            self.alpha = self.stopDraggingAlpha
            self.center = self.initialCenter
            self.transform = self.initialTransform
        }, completion: nil)
        
        delegate?.returnToOriginalPosition(self)
    }
    
    // カードを左側の領域外へ動かす
    private func moveInvisiblePosition(velocity: CGPoint, isLeft: Bool = true) {
        // 変化後の予定位置を算出（Y軸方向の位置はvelocityに基づいた値を採用）
        let absPosX = UIScreen.main.bounds.size.width * 1.6
        let endCenterPosX = isLeft ? -absPosX : absPosX
        let endCenterPosY = velocity.y
        let endCenterPosition = CGPoint(x: endCenterPosX, y: endCenterPosY)
        
        UIView.animate(withDuration: durationOfSwipeOut, delay: 0.0, usingSpringWithDamping: 0.68, initialSpringVelocity: 0.0, options: [.curveEaseInOut], animations: {
            self.alpha = self.stopDraggingAlpha
            self.center = endCenterPosition
        }, completion: { _ in
            _ = isLeft ? self.delegate?.swipedLeftPosition(self) : self.delegate?.swipedRightPosition(self)
            
            self.removeFromSuperview()
        })
    }
}
