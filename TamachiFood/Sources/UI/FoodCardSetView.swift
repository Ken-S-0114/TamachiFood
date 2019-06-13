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
    func swipedLeftPosition()
    // 右側へのスワイプ動作が完了した場合に実行されるアクション
    func swipedRightPosition()
    // 元の位置に戻る動作が完了したに実行されるアクション
    func returnToOriginalPosition()
}

class FoodCardSetView: CustomViewBase {
    
    @IBOutlet weak private var storeNameLabel: UILabel!
    @IBOutlet weak private var foodNameLabel: UILabel!
    @IBOutlet weak private var remarkLabel: UILabel!
    @IBOutlet weak private var foodImageView: UIImageView!
    @IBOutlet weak private var readmoreButton: UIButton!
    
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
                x: self.center.x - xPositionFromCenter,
                y: self.center.y - yPositionFromCenter
            )
            self.delegate?.beganDragging(self)
            // Debug.
            debugPrint("beganCenterX:", originalPoint.x)
            debugPrint("beganCenterY:", originalPoint.y)

            UIView.animate(withDuration: durationOfStartDragging, delay: 0.0, options: [.curveEaseInOut], animations: {
                self.alpha = self.startDraggingAlpha
                }, completion: nil)
            break
            
        case .changed:
            let newCenterX = originalPoint.x + xPositionFromCenter
            let newCenterY = originalPoint.y + yPositionFromCenter
            self.center = CGPoint(x: newCenterX, y: newCenterY)
            
            self.delegate?.updatePosition(self, centerX: newCenterX, centerY: newCenterY)
            
            currentMoveXPercentFromCenter = min(xPositionFromCenter / UIScreen.main.bounds.size.width, 1)
            currentMoveYPercentFromCenter = min(yPositionFromCenter / UIScreen.main.bounds.size.height, 1)
            
            // Debug.
            debugPrint("currentMoveXPercentFromCenter:", currentMoveXPercentFromCenter)
            debugPrint("currentMoveYPercentFromCenter:", currentMoveYPercentFromCenter)
            
            let initialRotationAngle = atan2(initialTransform.b, initialTransform.a)
            let whenDraggingRotationAngel = initialRotationAngle + CGFloat.pi / 10 * currentMoveXPercentFromCenter
            let transforms = CGAffineTransform(rotationAngle: whenDraggingRotationAngel)
            
            let scaleTransform: CGAffineTransform = transforms.scaledBy(x: maxScaleOfDragging, y: maxScaleOfDragging)
            self.transform = scaleTransform
            
            break
            
        case .ended, .cancelled:
            let whenEndedVelocity = sender.velocity(in: self)
            // Debug.
            debugPrint("whenEndedVelocity:", whenEndedVelocity)
            
            let shouldMoveToLeft = (currentMoveXPercentFromCenter < -swipeXPosLimitRatio && abs(currentMoveYPercentFromCenter) > swipeYPosLimitRatio)
            let shouldMoveToRight = (currentMoveXPercentFromCenter > swipeXPosLimitRatio && abs(currentMoveYPercentFromCenter) > swipeYPosLimitRatio)
            
            if shouldMoveToLeft {
                
            } else if shouldMoveToRight {
                
            } else {
                
            }
            
            originalPoint = CGPoint.zero
            xPositionFromCenter = 0.0
            yPositionFromCenter = 0.0
            currentMoveXPercentFromCenter = 0.0
            currentMoveYPercentFromCenter = 0.0
            
            break
            
        default:
            break
        }
    }
    
    // Viewのボタンに対する初期設定
    private func setupReadMoreButton() {
        readmoreButton.addTarget(self, action: #selector(self.readMoreButtonTapped), for: .touchUpInside)
    }
    
    private func setupPanGestureRecognizer() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.startDragging))
        self.addGestureRecognizer(panGestureRecognizer)
    }
}
