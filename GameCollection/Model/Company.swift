//
//  Company.swift
//  GameCollection
//
//  Created by Cinq Technologies on 19/03/18.
//  Copyright © 2018 renangreca. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Company {
    
    let id:Int
    let name:String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    init(from managedCompany:CompanyManagedObject) {
        self.name = managedCompany.name!
        self.id = Int(managedCompany.id)
    }
    
    init(with data:[String:Any]) {
        if let name = data[Fields.name.rawValue] as? String {
            self.name = name
        } else {
            self.name = ""
        }
        
        if let id = data[Fields.id.rawValue] as? Int {
            self.id = id
        } else {
            self.id = 0
        }
    }
    
    func insert() -> CompanyManagedObject {
        
        let managedCompany = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context) as! CompanyManagedObject
        
        managedCompany.name = self.name
        managedCompany.id = Int64(self.id)

        return managedCompany
    
    }
    
    class func fetchWith(id:Int) -> Company? {
        if let managedCompany = Company.fetchManagedWith(id: id) {
            return Company(from: managedCompany)
        }
        
        return nil
        
    }
    
    class func fetchManagedWith(id:Int) -> CompanyManagedObject? {
        let fetchRequest = NSFetchRequest<CompanyManagedObject>(entityName: "Company")
        let searchFilter = NSPredicate(format: "id = %d", id)
        fetchRequest.predicate = searchFilter
        
        let results = try? context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [CompanyManagedObject]
        
        if let managedCompany = results?.first {
            return managedCompany
        }
        
        return nil
        
    }
    
    class func deleteAll() {        
        let fetchRequest = NSFetchRequest<CompanyManagedObject>(entityName: "Company")
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let results = try context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                context.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Error deleting all data in Company : \(error) \(error.userInfo)")
        }
    }
}
