//
//  ComposeViewController.swift
//  SimpleMemoApp
//
//  Created by 권정근 on 3/11/24.
//

import UIKit

class ComposeViewController: UIViewController {
    
    // 네비게이션컨트롤러를 지나서 전달하기 위한 변수 
    var editTraget: Memo?
    
    // 편집 취소 관련된 변수
    var originalMemoContent: String?
    
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
        
        // 새 메모 화면을 공유함에 따라 코드 수정
        if let target = editTraget {
            target.content = memo
            DataManager.shared.saveContext()
            NotificationCenter.default.post(name: ComposeViewController.memodidChange, object: nil)
            
        } else {
            // 코어데이터를 이용해 저장하는 함수 호출
            DataManager.shared.addNewMemo(memo)
            NotificationCenter.default.post(name: ComposeViewController.newMemoDidInsert, object: nil)
        }
        // 방송 시작
       
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let memo = editTraget {
            navigationItem.title = "메모 편집"
            memoTextView.text = memo.content
            originalMemoContent = memo.content
        } else {
            navigationItem.title = "새 메모"
            memoTextView.text = ""
        }
        
        memoTextView.delegate = self
    }
    
    /*
     화면이 나타나기 직전에 delegate 가 되었다가, 화면이 꺼지기 전에 사라진다.
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.presentationController?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.presentationController?.delegate = nil
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

extension ComposeViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let original = originalMemoContent, let edited = textView.text {
            if #available(iOS 13.0, *) {
                isModalInPresentation = original != edited
            } else {
                
            }
        }
    }
}

// 내용을 저장하지 않고 그냥 내리면 아래 메소드가 호출된다.
// 내용을 편집만 하고 시트를 그냥 내리려고 하면 시트가 내려가지 않는다.
extension ComposeViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        let alert = UIAlertController(title: "알림", message: "편집한 내용을 저장할까요?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] (action) in  self?.save(action)}
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) {
            [weak self] (action) in self?.close(action)
        }
        
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}


extension ComposeViewController {
    static let newMemoDidInsert = Notification.Name(rawValue: "newMemoDidInsert")
    static let memodidChange = Notification.Name(rawValue: "memoDidChange")
}
