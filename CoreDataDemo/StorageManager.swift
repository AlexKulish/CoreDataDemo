//
//  StorageManager.swift
//  CoreDataDemo
//
//  Created by Alex Kulish on 25.01.2022.
//

import Foundation
import CoreData
import UIKit

enum DataError: Error {
    case noData
    case dontSaveData
    case dontEditData
    case dontDeleteData
}

class StorageManager {
    
    static let shared = StorageManager()
    private init() {}
    
    lazy private var context = persistentContainer.viewContext
    
    // MARK: - Core Data stack
    
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
            let context = persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    
    func fetchData(completion: @escaping(Result<[Task], DataError>) -> Void) {
        
        let fetchRequest = Task.fetchRequest()
        
        do {
            let taskList = try context.fetch(fetchRequest)
            completion(.success(taskList))
        } catch {
           print("Faild to fetch data", error)
            completion(.failure(.noData))
        }
    }
    
    func save(_ taskName: String) {
        let task = Task(context: context)
        task.name = taskName
        saveContext()
    }
    
    func delete(with task: Task) {
        context.delete(task)
        saveContext()
    }
    
    func edit(_ taskName: Task, _ newTask: String) {
        taskName.name = newTask
        saveContext()
    }
}
