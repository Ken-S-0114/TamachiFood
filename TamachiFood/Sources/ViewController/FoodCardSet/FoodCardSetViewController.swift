//
//  FoodCardSetViewController.swift
//  TamachiFood
//
//  Created by sato.ken on 2019/06/13.
//  Copyright © 2019 佐藤賢. All rights reserved.
//

import AudioToolbox
import Firebase
import UIKit

class FoodCardSetViewController: UIViewController {
    fileprivate var foodCardSetViewList: [FoodCardSetView] = []
    fileprivate var presenter: MockFoodPresenter!
    fileprivate let foodCardSetViewCountLimit: Int = 16
    
    // インスタンス変数
    private var DBRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFoodPresenter()
        DBRef = Database.database().reference()
    }
    
    private func setupFoodPresenter() {
        presenter = MockFoodPresenter(presenter: self)
    }
    
    // 戻るボタンに関する設定を行う
    private func setupDismissButton() {
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(title: "戻る", style: .done, target: self, action: #selector(dismissButtonTapped))
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
    
    private func addDataFirebase(_ food: FoodModel, isLeft: Bool) {
        let evaluation: String = isLeft ? EvaluationStatus.like.changeStatusToStr() : EvaluationStatus.hate.changeStatusToStr()
        let data = [
            "foodId": String(food.foodId),
            "storeName": food.storeName,
            "foodName": food.foodName,
            "evaluation": evaluation
        ]
        
        DBRef.child("food").setValue(data)
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
        presenter.getFoods()
        addDataFirebase(presenter.getFood(index: 0), isLeft: true)
    }
    
    func swipedRightPosition(_ cardView: FoodCardSetView) {
        debugPrint("右方向へのスワイプ完了しました。")
        AudioServicesPlaySystemSound(1520)
        foodCardSetViewList.removeFirst()
        enableUserInteractionToFirstCardSetView()
        changeScaleToCardSetViews(skipSelectedView: false)
        // addDataFirebase(<#T##food: FoodModel##FoodModel#>, isLeft: false)
    }
    
    func returnToOriginalPosition(_ cardView: FoodCardSetView) {
        debugPrint("元の位置へ戻りました。")
        changeScaleToCardSetViews(skipSelectedView: false)
    }
}
