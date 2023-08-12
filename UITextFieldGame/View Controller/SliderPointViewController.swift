//
//  SliderPointViewController.swift
//  UITextFieldGame
//
//  Created by Howe on 2023/8/13.
//

import UIKit

class SliderPointViewController: UIViewController {
    
    // 初始的總點數
    var totalPoint = 10
    // 用於存儲上一次每個 stepper 的值，以便於比較和計算點數變化
    var previousStepperValues: [Double] = [0, 0, 0, 0]
    
    // 從前一個控制器傳遞的玩家資訊
    var playerName: String!
    var zongmen: String!
    var race: String!
    var level: String!
    var perception: String!
    
    // 顯示玩家資訊的標籤
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var zongmenLabel: UILabel!
    @IBOutlet weak var raceLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var perceptionLabel: UILabel!
    
    // 顯示總點數的標籤
    @IBOutlet weak var totalPointLabel: UILabel!
    
    // 顯示每個屬性點數的標籤
    @IBOutlet var points: [UILabel]!
    
    // 調整每個屬性點數的 stepper 控件
    @IBOutlet var stepperOutlets: [UIStepper]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化玩家資訊
        playerNameLabel.text = playerName
        zongmenLabel.text = zongmen
        raceLabel.text = race
        levelLabel.text = level
        perceptionLabel.text = perception
        
        // 初始化總點數標籤
        totalPointLabel.textAlignment = .center
        totalPointLabel.center.x = view.center.x
        totalPointLabel.text = String(totalPoint)
        
        // 設定屬性點數標籤和 stepper 控件
        setting()
    }
    
    // 設定屬性點數標籤和 stepper 控件的位置和初始值
    func setting() {
        for (index, label) in points.enumerated() {
            label.text = "0"
            label.textAlignment = .center
            stepperOutlets[index].center.x = label.center.x
        }
    }
    
    // 當 stepper 控件的值改變時調用
    @IBAction func stepper(_ sender: UIStepper) {
        guard let stepperIndex = points.firstIndex(where: { $0.tag == sender.tag}) else {
            return
        }
        
        updatePoints(for: sender, at: stepperIndex)
        
    }
    
    
    func updatePoints(for stepper: UIStepper, at index: Int) {
        // 如果當前值大於上一次的值，表示增加點數
        if stepper.value > previousStepperValues[index] {
            // 如果總點數已經為 0 或當前屬性的點數已達到 10，則重置 stepper 的值
            if totalPoint <= 0 || Int(points[index].text!)! >= 10 {
                stepper.value = previousStepperValues[index]
                return
            }
            totalPoint -= 1
        } else {
            // 如果當前值小於上一次的值，表示減少點數
            totalPoint += 1
        }
        
        // 更新屬性點數標籤和總點數標籤的值
        points[index].text = "\(Int(stepper.value))"
        totalPointLabel.text = "\(totalPoint)"
        
        // 儲存當前 stepper 的值以供下次比較
        previousStepperValues[index] = stepper.value
    }

    
    
    
    
    // 跳轉到下一個控制器並傳遞玩家資訊
    @IBSegueAction func pushPlayerState(_ coder: NSCoder) -> TextFieldViewController? {
        let controller = TextFieldViewController(coder: coder)
        controller?.playerName = playerName
        controller?.level = level
        controller?.race = race
        controller?.zongmen = zongmen
        controller?.perception = perception
        
        return controller
    }
    
}
