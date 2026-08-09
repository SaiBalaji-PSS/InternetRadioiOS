//
//  Coordinator.swift
//  TamilInternetRadio
//
//  Created by Sai Balaji on 08/08/26.
//

import Foundation
import CoreData
import Combine

protocol PersistenceProtocol{
    func  fetchAllData<T: NSManagedObject>(from entityName: String)throws -> [T]
    func fetchAllDataWithPredicate<T:NSManagedObject>(from entityName: String,predicate: NSPredicate)throws -> [T]
    func saveData()throws
    
}


class LibraryPersistenceController: PersistenceProtocol{
    func  fetchAllData<T: NSManagedObject>(from entityName: String)throws -> [T] {
        return try PersistenceController.shared.fetchAllData(from: entityName)
    }
    
    func fetchAllDataWithPredicate<T:NSManagedObject>(from entityName: String,predicate: NSPredicate)throws -> [T]  {
        return try PersistenceController.shared.fetchAllDataWithPredicate(from: entityName, predicate: predicate)
    }
    
    func saveData() throws {
        try PersistenceController.shared.saveData()
    }
}

class MockLibraryPeristenceController: PersistenceProtocol{
    
    let controller: PersistenceController
    var errorToThrow: Error?
    init(controller: PersistenceController) {
        self.controller = controller
    }
    
    func  fetchAllData<T: NSManagedObject>(from entityName: String)throws -> [T] {
        if let errorToThrow{
            throw errorToThrow
            
        }
        return try controller.fetchAllData(from: entityName)
    }
    func fetchAllDataWithPredicate<T:NSManagedObject>(from entityName: String,predicate: NSPredicate)throws -> [T]{
        if let errorToThrow{
            throw errorToThrow
            
        }
        return try controller.fetchAllDataWithPredicate(from: entityName, predicate: predicate)
    }
    func saveData()throws{
        if let errorToThrow{
            throw errorToThrow
            
        }
        try controller.saveData()
    }
}




class PersistenceController: ObservableObject{
    static let shared = PersistenceController()
    let container = NSPersistentContainer(name: "RadioStationLibrary")
    lazy var context: NSManagedObjectContext = container.viewContext
    init(inMemory: Bool = false){
        if inMemory{
            container.persistentStoreDescriptions.first?.url =  URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error  in
            
            if let error{
                print(error)
            }
        }
    }
    
    func saveData()throws{
        if context.hasChanges{
            try context.save()
        }
    }
    
    func fetchAllData<T: NSManagedObject>(from entityName: String)throws -> [T]{
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        let result = try context.fetch(fetchRequest)
        return result
    }
    
    func fetchAllDataWithPredicate<T:NSManagedObject>(from entityName: String,predicate: NSPredicate)throws -> [T]{
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        fetchRequest.predicate = predicate
        let result = try context.fetch(fetchRequest)
        return result
    }
    
}
                                
