//
//  RandomSelectViewController.swift
//  UITextFieldGame
//
//  Created by Howe on 2023/8/13.
//

import UIKit

// 這是一個 UIViewController 子類，用於隨機選擇玩家的角色屬性。
class RandomSelectViewController: UIViewController {
    
    // 這個屬性存儲玩家的名稱。
    var playerName: String!
    
    // 這個屬性是一個計時器，用於定期更新標籤的文本。
    var timer: Timer?
    
    // 這個屬性是一個布爾值的數組，用於確定哪些標籤已被鎖定。
    var isLocked: [Bool] = [false, false, false, false, false, false]

    // 這個屬性是一個 CharacterRandom 的實例，它包含了所有的隨機選項。
    var randomArray = CharacterRandom()
    
    // 以下是一些 IBOutlet，它們連接到 storyboard 中的 UI 元素。
    @IBOutlet weak var introduceUpSide: UITextView!
    @IBOutlet weak var introduceDownSide: UITextView!
    
    @IBOutlet weak var raceLabel: UILabel!
    @IBOutlet weak var zongmenLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var appearanceLabel: UILabel!
    @IBOutlet weak var giftLabel: UILabel!
    @IBOutlet weak var perceptionLabel: UILabel!
    
    // viewDidLoad 是 UIViewController 的生命週期方法，當視圖加載到內存時會被調用。
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 設置自定義字體和段落樣式。
        let customFont = UIFont(name: "jf-jinxuan", size: 16) ?? UIFont.systemFont(ofSize: 16)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5  // 這裡的5是行距，你可以根據需要調整這個值
        let attributes: [NSAttributedString.Key: Any] = [
            .font: customFont,
            .foregroundColor: UIColor.label,
            .paragraphStyle: paragraphStyle
        ]

        
        // 設置 introduceUpSide 的富文本。
        let introduceUpSideText = NSMutableAttributedString(string: "你叫 ", attributes: attributes)
        introduceUpSideText.append(NSAttributedString(string: playerName!, attributes: [.foregroundColor: UIColor.red, .font: customFont]))
        introduceUpSideText.append(NSAttributedString(string: " ，\n從小父母雙亡，一心追求長生不死。\n15 歲那年，被李青侯帶入靈溪宗，\n入火灶房任伙計，排名老九，被稱為白九胖。", attributes: attributes))
        introduceUpSide.attributedText = introduceUpSideText
        
        
        
        // 設置 introduceDownSide 的富文本。
        let introduceDownSideText = NSMutableAttributedString(string: "一念斬千魔，一念誅萬仙，為我念永恆。\n我 ", attributes: attributes)
        introduceDownSideText.append(NSAttributedString(string: playerName!, attributes: [.foregroundColor: UIColor.red, .font: customFont]))
        introduceDownSideText.append(NSAttributedString(string: " 彈指間，萬物灰飛煙滅", attributes: attributes))
        introduceDownSide.attributedText = introduceDownSideText

        

        // 將 introduceUpSide 的中心點設置為視圖的中心點。
        introduceUpSide.center.x = view.center.x
        
        // 開始旋轉動畫。
        startRandomizingLabels()
        
    }
    
    // 這個方法啟動一個計時器，每隔0.1秒調用 updateLabel 方法。
    func startRandomizingLabels() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateLabel), userInfo: nil, repeats: true)
    }
    
    
    // 這個方法更新所有的標籤，除非它們已被鎖定。
    @objc func updateLabel() {
        if !isLocked[0] {
            raceLabel.text = randomArray.races[Int(arc4random_uniform(UInt32(randomArray.races.count)))]
        }
        if !isLocked[1] {
            zongmenLabel.text = randomArray.zongmens[Int(arc4random_uniform(UInt32(randomArray.zongmens.count)))]
        }
        if !isLocked[2] {
            levelLabel.text = randomArray.levels[Int(arc4random_uniform(UInt32(randomArray.levels.count)))]
        }
        if !isLocked[3] {
            appearanceLabel.text = randomArray.appearance[Int(arc4random_uniform(UInt32(randomArray.appearance.count)))]
        }
        if !isLocked[4] {
            giftLabel.text = randomArray.gifts[Int(arc4random_uniform(UInt32(randomArray.gifts.count)))]
        }
        if !isLocked[5] {
            perceptionLabel.text = randomArray.perception[Int(arc4random_uniform(UInt32(randomArray.perception.count)))]
        }
    }

    // 這個方法是一個 IBAction，當用戶點擊確認按鈕時會被調用。
    @IBAction func confirmButton(_ sender: UIButton) {
        switch sender.tag {
            case 0:
                isLocked[0] = true
            case 1:
                isLocked[1] = true
            case 2:
                isLocked[2] = true
            case 3:
                isLocked[3] = true
            case 4:
                isLocked[4] = true
            case 5:
                isLocked[5] = true
            default:
                break
            }
        }
    
    // 這個方法是一個 IBSegueAction，當從這個控制器進行 segue 轉換時會被調用。
    // 它將玩家的名稱和其他屬性從這個控制器傳遞到 SliderPointViewController。
    @IBSegueAction func pushPlayerState(_ coder: NSCoder) -> SliderPointViewController? {
        let raceLabelString = raceLabel.text
        let zongmenLabelString = zongmenLabel.text
        let levelLabelString = levelLabel.text
        let perceptionLabelString = perceptionLabel.text
        let controller = SliderPointViewController(coder: coder)
        controller?.playerName = playerName
        controller?.race = raceLabelString
        controller?.zongmen = zongmenLabelString
        controller?.level = levelLabelString
        controller?.perception = perceptionLabelString
        
        return controller
    }
    
    
    
    
    // 在視圖消失時停止計時器
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }

    
    
    
}
