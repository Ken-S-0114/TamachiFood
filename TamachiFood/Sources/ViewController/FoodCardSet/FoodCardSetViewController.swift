//
//  FoodCardSetViewController.swift
//  TamachiFood
//
//  Created by sato.ken on 2019/06/13.
//  Copyright © 2019 佐藤賢. All rights reserved.
//

import AudioToolbox
import UIKit

class FoodCardSetViewController: UIViewController {
    fileprivate var foodCardSetViewList: [FoodCardSetView] = []
    fileprivate var presenter: MockFoodPresenter!
    fileprivate let foodCardSetViewCountLimit: Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFoodPresenter()
    }
    
    private func setupFoodPresenter() {
        presenter = MockFoodPresenter(presenter: self)
    }
    
    @IBAction func addCardButtonTapped(_ sender: UIBarButtonItem) {
        presenter.getFoods()
    }
    
    @IBAction func dismissButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func addFoodCardSetViews(foods: [FoodModel]) {
        for index in 0 ..< foods.count {
            let foodCardSetView = FoodCardSetView()
            foodCardSetView.delegate = self
            foodCardSetView.setViewData(foods[index])
            // URL
            
            foodCardSetView.isUserInteractionEnabled = false
            foodCardSetView.tag = foods[index].foodId
            foodCardSetViewList.append(foodCardSetView)
            
            // 現在表示されているカードの背面へ新たに作成したカードを追加する
            view.addSubview(foodCardSetView)
            view.sendSubviewToBack(foodCardSetView)
        }
        
        enableUserInteractionToFirstCardSetView()
        changeScaleToCardSetViews(skipSelectedView: false)
    }
    
    // 画面上にあるカードの山のうち、一番上にあるViewのみを操作できるようにする
    fileprivate func enableUserInteractionToFirstCardSetView() {
        if !foodCardSetViewList.isEmpty {
            if let firstFoodCardSetView = foodCardSetViewList.first {
                firstFoodCardSetView.isUserInteractionEnabled = true
            }
        }
    }
    
    // 現在配列に格納されている(画面上にカードの山として表示されている)Viewの拡大縮小を調節する
    fileprivate func changeScaleToCardSetViews(skipSelectedView: Bool = false) {
        let duration: TimeInterval = 0.26
        let reduceRatio: CGFloat = 0.018
        
        var targetCount: CGFloat = 0
        
        for (targetIndex, foodCardSetView) in foodCardSetViewList.enumerated() {
            // 現在操作中のViewの縮小比を変更しない場合は、以降の処理をスキップ
            if skipSelectedView, targetIndex == 0 { continue }
            
            // 後ろに配置されているViewほど小さく見えるように縮小比を調節する
            let targetScale: CGFloat = 1 - reduceRatio * targetCount
            UIView.animate(withDuration: duration, animations: {
                foodCardSetView.transform = CGAffineTransform(scaleX: targetScale, y: targetScale)
            })
            targetCount += 1
        }
    }
}

extension FoodCardSetViewController: MockFoodPresenterProtocol {
    func bindFoods(_ foods: [FoodModel]) {
        addFoodCardSetViews(foods: foods)
    }
}

extension FoodCardSetViewController: FoodCardSetViewProtocol {
    func beganDragging(_ cardView: FoodCardSetView) {
        debugPrint("ドラッグを開始")
        changeScaleToCardSetViews(skipSelectedView: true)
    }
    
    func updatePosition(_ cardView: FoodCardSetView, centerX: CGFloat, centerY: CGFloat) {
        debugPrint("移動した座標点 X軸:\(centerX) Y軸:\(centerY)")
    }
    
    func swipedLeftPosition(_ cardView: FoodCardSetView) {
        debugPrint("左方向へのスワイプ完了しました。")
        AudioServicesPlaySystemSound(1520)
        foodCardSetViewList.removeFirst()
        enableUserInteractionToFirstCardSetView()
        changeScaleToCardSetViews(skipSelectedView: false)
        presenter.addDataFirebase(presenter.getFood(at: cardView.tag), isLeft: true)
    }
    
    func swipedRightPosition(_ cardView: FoodCardSetView) {
        debugPrint("右方向へのスワイプ完了しました。")
        AudioServicesPlaySystemSound(1102)
        foodCardSetViewList.removeFirst()
        enableUserInteractionToFirstCardSetView()
        changeScaleToCardSetViews(skipSelectedView: false)
        presenter.addDataFirebase(presenter.getFood(at: cardView.tag), isLeft: false)
    }
    
    func returnToOriginalPosition(_ cardView: FoodCardSetView) {
        debugPrint("元の位置へ戻りました。")
        changeScaleToCardSetViews(skipSelectedView: false)
    }
}
