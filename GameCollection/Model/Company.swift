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

enum Company: Int {
    
    case nintendo
    case sony
    case microsoft
    case sega
    case other
//    case pc
//    case none
    
    static func from(name: String?) -> Company {
        if let company = name {
            switch company {
            case "Nintendo":
                return .nintendo
            case "Sony Interactive Entertainment":
                return .sony
            case "Microsoft Studios":
                return .microsoft
            case "Sega":
                return .sega
            default:
                return .other
            }
        }
        return .other
    }
    
    static func from(platformName: String) -> Company {
        let companyPlatformNames:[String:Company] = [
            "Nintendo"      : .nintendo,
            "Game Boy"      : .nintendo,
            "Wii"           : .nintendo,
            "Virtual Boy"   : .nintendo,
            "GameCube"      : .nintendo,
            "Pokémon"       : .nintendo,
            "Satellaview"   : .nintendo,
            
            "PlayStation"   : .sony,
            
            "Xbox"          : .microsoft,
            
            "Sega"          : .sega,
            "Game Gear"     : .sega,
            "Genesis"       : .sega,
            "Saturn"        : .sega,
            "Dreamcast"     : .sega,
            
        ]
        
        for (name, company) in companyPlatformNames {
            if platformName.contains(name) {
                return company
            }
        }
        
        return .other
    }
    
    var name: String {
        switch self {
        case .nintendo:
            return "Nintendo"
        case .sony:
            return "Sony"
        case .microsoft:
            return "Microsoft"
        case .sega:
            return "Sega"
        case .other:
            return "Other"
        }
    }
    
    // Display platform with color depending on family of systems
    var color: UIColor {
        let alpha:CGFloat = 1.0
        
        switch(self) {
        case .nintendo:
            // red
            return UIColor(red: 0.902, green: 0.000, blue: 0.071, alpha: alpha)
        case .sony:
            // blue
            return UIColor(red: 0.345, green: 0.529, blue: 0.961, alpha: alpha)
        case .microsoft:
            // green
            return UIColor(red: 0.063, green: 0.486, blue: 0.063, alpha: alpha)
        case .sega:
            // other blue
            return UIColor(red: 0.000, green: 0.435, blue: 0.835, alpha: alpha)
        case .other:
            // purple
            return UIColor(red: 0.275, green: 0.063, blue: 0.486, alpha: alpha)
//        case .none:
//            // gray
//            return UIColor(white: 0.0, alpha: 1.0)
//        case .none:
//            return UIColor(white: 0.0, alpha: 1.0)
        }
    }
    
//    let id:Int
//    let name:String
//
//    init(id: Int, name: String) {
//        self.id = id
//        self.name = name
//    }
//
//    init(from managedCompany:CompanyManagedObject) {
//        self.name = managedCompany.name!
//        self.id = Int(managedCompany.id)
//    }
//
//    init(with data:[String:Any]) {
//        if let name = data[Fields.name.rawValue] as? String {
//            self.name = name
//        } else {
//            self.name = ""
//        }
//
//        if let id = data[Fields.id.rawValue] as? Int {
//            self.id = id
//        } else {
//            self.id = 0
//        }
//    }
//
//    func insert() -> CompanyManagedObject {
//
//        let managedCompany = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context) as! CompanyManagedObject
//
//        managedCompany.name = self.name
//        managedCompany.id = Int64(self.id)
//
//        return managedCompany
//
//    }
//
//    class func fetchWith(id:Int) -> Company? {
//        if let managedCompany = Company.fetchManagedWith(id: id) {
//            return Company(from: managedCompany)
//        }
//
//        return nil
//
//    }
//
//    class func fetchManagedWith(id:Int) -> CompanyManagedObject? {
//        let fetchRequest = NSFetchRequest<CompanyManagedObject>(entityName: "Company")
//        let searchFilter = NSPredicate(format: "id = %d", id)
//        fetchRequest.predicate = searchFilter
//
//        let results = try? context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [CompanyManagedObject]
//
//        if let managedCompany = results?.first {
//            return managedCompany
//        }
//
//        return nil
//
//    }
//
//    class func deleteAll() {
//        let fetchRequest = NSFetchRequest<CompanyManagedObject>(entityName: "Company")
//        fetchRequest.returnsObjectsAsFaults = false
//        do
//        {
//            let results = try context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
//            for managedObject in results
//            {
//                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
//                context.delete(managedObjectData)
//            }
//        } catch let error as NSError {
//            print("Error deleting all data in Company : \(error) \(error.userInfo)")
//        }
//    }
}
