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
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func delete(in index: Int, with completion: @escaping(Result<[Task], DataError>) -> Void) {
        
        let fetchRequest = Task.fetchRequest()
        
        do {
            var taskList = try context.fetch(fetchRequest)
            context.delete(taskList[index])
            taskList.remove(at: index)
            completion(.success(taskList))
        } catch {
            completion(.failure(.noData))
            print(error)
        }
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func edit(in index: Int, _ newTask: String, with completion: @escaping(Result<Task, DataError>) -> Void) {
        
        let fetchRequest = Task.fetchRequest()
        
        do {
            let taskList = try context.fetch(fetchRequest)
            completion(.success(taskList[index]))
            taskList[index].name = newTask
            
        } catch {
            completion(.failure(.noData))
            print(error)
        }
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
}
