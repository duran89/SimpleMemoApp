//
//  ComposeViewController.swift
//  SimpleMemoApp
//
//  Created by 권정근 on 3/11/24.
//

import UIKit

class ComposeViewController: UIViewController {
    
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var memoTextView: UITextView!
    
    @IBAction func save(_ sender: Any) {
        guard let memo = memoTextView.text,
              memo.count > 0 else {
            alert(message: "메모를 입력하세요 ")
            return
        }
        
//        let newMemo = Memo(content: memo)
//        Memo.dummyMemoList.append(newMemo)
        
        // 방송 시작
        NotificationCenter.default.post(name: ComposeViewController.newMemoDidInsert, object: nil)
        
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

/*
 화면 출력 방식이 sheet 인 경우에는 fullscreen과 달리 viewWillAppear 메서드 내에 tableView.reloadData()가 안됨
 이를 해결하고자 notification 기능 사용
 notification 이 호출되는 시점에 테이블 뷰 리로드하고 새 데이터 저장
 */

extension ComposeViewController {
    static let newMemoDidInsert = Notification.Name(rawValue: "newMemoDidInsert")
}
