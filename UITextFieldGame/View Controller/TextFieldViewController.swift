//
//  TextFieldViewController.swift
//  UITextFieldGame
//
//  Created by Howe on 2023/8/13.
//
import UIKit
import AVFAudio

// 這個 ViewController 用於顯示和管理遊戲的問題
class TextFieldViewController: UIViewController {
    
    // 定義玩家的基本屬性
    var playerName: String!
    var zongmen: String!
    var race: String!
    var level: String!
    var perception: String!
    
    // 存儲所有問題的數組
    var chapter: [Question] = []
    
    // 當前問題的索引
    var currentQuestionIndex = 0
    
    // 用於語音合成的對象
    let speechSynthesizer = AVSpeechSynthesizer()
    
    // 用於語音合成的文本數組
    let speechArray = ["兒童時期 父母看你天賦異稟 決定將你送往","少年階段 你在宗門後山發現一顆 風行丹 你選擇","服下丹藥後 修為快速提升 於是你選擇修煉 ","你終於成為了最年輕的拳修 此時你選擇 作為你的主修功法","此後你難有敵手 但你深知仍有不足 於是選擇 ","鯨吞九天引天象異動 五類傾瀉 你難承其重 奄奄一息"]
    
    // 以下是與界面相關的屬性
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var zongmenLabel: UILabel!
    @IBOutlet weak var raceLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var perceptionLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var leftButtonOuelet: UIButton!
    @IBOutlet weak var rightButtonOuelet: UIButton!
    @IBOutlet weak var finalButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化玩家的基本屬性
        playerNameLabel.text = playerName
        zongmenLabel.text = zongmen
        raceLabel.text = race
        levelLabel.text = level
        perceptionLabel.text = perception
        
        // 初始化遊戲界面
        setUp()
        displayQuestionWithTypingEffect()
        finalButtonOutlet.isHidden = true
    }
    
    // 左側按鈕的事件處理
    @IBAction func leftButton(_ sender: UIButton) {
        if let selectedOption = sender.title(for: .normal) {
            updateQuestionWithSelectedOption(selectedOption)
        }
    }
    
    // 右側按鈕的事件處理
    @IBAction func rightButton(_ sender: UIButton) {
        if let selectedOption = sender.title(for: .normal) {
            updateQuestionWithSelectedOption(selectedOption)
        }
    }
    
    // 最終按鈕的事件處理
    @IBAction func finalButton(_ sender: UIButton) {
        // 這裡可以添加最終按鈕的功能，例如結束遊戲或顯示結果
    }
    
    // 初始化遊戲的問題和界面
    func setUp() {
        // 定義所有問題
        chapter = [
            Question(question:"兒童時期，父母看你天賦異稟，\n決定將你送往 \("________") 修煉。",
                     option: ["少林寺", "明教"]),
            Question(question:"少年階段，你在宗門後山發現一顆 “風行丹”，你選擇 \("________") 。",
                     option: ["自己服用", "上交宗門"]),
            Question(question:"服下丹藥後，修為快速提升，\n於是你選擇修煉 \("________") 。",
                     option: ["拳修", "劍修"]),
            Question(question:"你終於成為了最年輕的拳修，此時你選擇\("________") 作為你的主修功法。",
                     option: ["七傷拳", "太極拳"]),
            Question(question:"此後你難有敵手，但你深知仍有不足\n於是選擇 \("________") 。",
                     option: ["穩固根基", "渡劫飛升"]),
            Question(question:"鯨吞九天引天象異動，五類傾瀉，\n你難承其重，奄奄一息。",
                     option: ["逆天改命"])
        ]
        
        // 設置文本的格式
        let customFont = UIFont(name: "jf-jinxuan", size: 20) ?? UIFont.systemFont(ofSize: 16)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        let attributes: [NSAttributedString.Key: Any] = [
            .font: customFont,
            .foregroundColor: UIColor.label,
            .paragraphStyle: paragraphStyle
        ]
        
        let chapterText = NSMutableAttributedString(string: chapter[currentQuestionIndex].question, attributes: attributes)
        textView.attributedText = chapterText
    }
    
    // 顯示問題並使用打字效果
    func displayQuestionWithTypingEffect() {
        guard currentQuestionIndex < chapter.count else { return }
        
        let question = chapter[currentQuestionIndex].question
        textView.text = ""
        
        var charIndex = 0.0
        for char in question {
            Timer.scheduledTimer(withTimeInterval: 0.05 * charIndex, repeats: false) { (timer) in
                self.textView.text?.append(char)
            }
            charIndex += 1
        }
        self.speakText(speechArray[currentQuestionIndex])
        let totalDuration = 0.05 * charIndex
        Timer.scheduledTimer(withTimeInterval: totalDuration, repeats: false) { (timer) in
            self.updateButtonOptions()
        }
    }
    
    // 更新選項按鈕的標題
    func updateButtonOptions() {
        guard currentQuestionIndex < chapter.count else { return }
            
        let options = chapter[currentQuestionIndex].option
        if options.count == 1 {
            leftButtonOuelet.isHidden = true
            rightButtonOuelet.isHidden = true
            finalButtonOutlet.isHidden = false
            finalButtonOutlet.setTitle(options[0], for: .normal)
        } else {
            leftButtonOuelet.setTitle(options[0], for: .normal)
            rightButtonOuelet.setTitle(options[1], for: .normal)
            finalButtonOutlet.isHidden = true
        }
    }
    
    // 更新問題內容並播放選擇的選項的語音
    func updateQuestionWithSelectedOption(_ option: String) {
        guard currentQuestionIndex < chapter.count else { return }
        
        let updatedQuestion = chapter[currentQuestionIndex].question.replacingOccurrences(of: "________", with: option)
        textView.text = updatedQuestion
        speakText(option)
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer) in
            self.goToNextQuestion()
        }
    }
    
    // 使用語音合成播放文本
    func speakText(_ text: String) {
        speechSynthesizer.stopSpeaking(at: .immediate)
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "zh-TW") // 設置為繁體中文
        speechSynthesizer.speak(speechUtterance)
    }
    
    // 轉到下一個問題
    func goToNextQuestion() {
        currentQuestionIndex += 1
        if currentQuestionIndex < chapter.count {
            displayQuestionWithTypingEffect()
        } else {
            // 如果已經是最後一題，你可以選擇做其他事情，例如顯示結果或返回上一頁等
            print("Quiz finished!")
        }
    }
}

