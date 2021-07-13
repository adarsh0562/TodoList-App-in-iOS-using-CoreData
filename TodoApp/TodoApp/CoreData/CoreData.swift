//
//  CoreData.swift
//  TodoApp
//
//  Created by Adarsh Raj on 09/07/21.
//

import UIKit
import CoreData
import Foundation
public var manageObjectContext: NSManagedObjectContext!
@available(iOS 13.0, *)
var appDelegate = UIApplication.shared.delegate as! AppDelegate

@available(iOS 13.0, *)
func openDatabse(title: String, date:String,content: String)
    
{
    manageObjectContext = appDelegate.persistentContainer.viewContext
    let entity = NSEntityDescription.entity(forEntityName: "TodoList", in: manageObjectContext)
    let newNotes = NSManagedObject(entity: entity!, insertInto: manageObjectContext)
    saveData(ListData:newNotes, title: title, date:date,content: content)
}

func saveData(ListData:NSManagedObject,title: String, date:String,content: String)
{
    if title != ""
    {
    ListData.setValue(title, forKey: "title")
    ListData.setValue(date, forKey: "date")
    ListData.setValue(content, forKey: "content")
     
    do {
        try manageObjectContext.save()
    } catch {
      
    }
    }
}


