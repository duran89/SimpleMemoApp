//
//  DataManager.swift
//  SimpleMemoApp
//
//  Created by 권정근 on 3/11/24.
//

import Foundation
import CoreData

class DataManager {
    
    // 공유 인스턴스를 저장할 타입 프로퍼티 생성
    static let shared = DataManager()
    
    private init() {
        
    }
    
    // 코어 데이터를 운영하는데 필요한 콘텍스트
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // 메모를 데이터베이스에서 읽어올 배열
    var memoList = [Memo]()
    
    // 데이터를 읽어오는 함수
    func fetchMemo() {
        let request: NSFetchRequest<Memo> = Memo.fetchRequest()
        
        // 배열이 자동으로 안되니까 배열 설정할 것
        let sortByDateDesc = NSSortDescriptor(key: "insertDate", ascending: false)
        request.sortDescriptors = [sortByDateDesc]
        
        do {
            memoList = try mainContext.fetch(request)
        } catch {
            print(error)
        }
    }
    
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "SimpleMemoApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
 
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

