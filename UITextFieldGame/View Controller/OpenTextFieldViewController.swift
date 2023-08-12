import UIKit


// 這是一個 UIViewController 子類，用於顯示和處理與玩家名稱相關的功能。
class OpenTextFieldViewController: UIViewController {

    // 這是一個 IBOutlet，它連接到 storyboard 中的 UITextField，用於輸入玩家名稱。
    @IBOutlet weak var playerName: UITextField!
    
    // viewDidLoad 是 UIViewController 的生命週期方法，當視圖加載到內存時會被調用。
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 創建一個 UITapGestureRecognizer 來檢測用戶在視圖上的點擊。
        // 當用戶點擊視圖時，它將調用 dismissKeyboard 方法。
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        // 將手勢識別器添加到視圖中，這樣它就可以檢測到視圖上的點擊。
        view.addGestureRecognizer(tap)
    }
    
    // 這是一個 @objc 方法，當用戶點擊視圖時會被調用。
    // 它的主要功能是隱藏鍵盤。
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // 這是一個 IBSegueAction，當從這個控制器進行 segue 轉換時會被調用。
    // 它將玩家名稱從這個控制器傳遞到 RandomSelectViewController。
    @IBSegueAction func prepareForRandomSelectSegue(_ coder: NSCoder) -> RandomSelectViewController? {
        
        // 從 playerName UITextField 中獲取文本。
        let textFieldPlayerName = playerName.text
        
        
        // 創建一個新的 RandomSelectViewController 實例。
        let controller = RandomSelectViewController(coder: coder)
        
        
        // 將玩家名稱設置為新控制器的 playerName 屬性。
        controller?.playerName = textFieldPlayerName
        
        
        // 返回新的控制器，這樣它就可以被推送到導航堆棧中。
        return controller
    }
}
