//
//  addTodoListViewController.swift
//  TodoApp
//
//  Created by Satyam Kumar on 08/07/21.
//

import UIKit
import CoreData
@available(iOS 13.0, *)
class addTodoListViewController: UIViewController {

    @IBOutlet weak var todoTitleField: UITextField!
    @IBOutlet weak var todoNotesTextView: UITextView!
    
    var notesId: Int? = nil
    var arraylist :[String:Any] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        todoTitleField.text! = "\(arraylist["title"] ?? "")"
        todoNotesTextView.text! = "\(arraylist["content"] ?? "Enter Text here")"
        // Do any additional setup after loading the view.
    }
    
    

    @IBAction func saveButton(_ sender: Any) {
        validationOnText()
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: Alert
    func alert(title:String,mess:String){
        let alert = UIAlertController(title: title, message: mess, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertAction(title:String,mess:String){
        let alert = UIAlertController(title: title, message: mess, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Validation
    func validationOnText()
    {
        if  todoTitleField.text! == ""{
            alert(title: "Error", mess: "Title is required")
        }
        else if todoNotesTextView!.text! == ""{
            alert(title: "Error", mess: "Please enter some notes")
        }
        
        else{
            saveCoreData()
       }
    }
   
    
    
}
//MARK: Save data in CoreData
@available(iOS 13.0, *)
extension addTodoListViewController
{
    func saveCoreData()
    {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)

        if notesId == nil
        {
            openDatabse(title: todoTitleField!.text!, date: result, content: todoNotesTextView!.text!)
            alertAction(title: "Success", mess: "Notes Added Successfully successfully")
       // alert(title: "Success", mess: "Register successfully")
        }else{
            updateData()
            alertAction(title: "Success", mess: "Notes Updated Successfully successfully")
        }
    
    }
}

//MARK:- Updating Notes here
@available(iOS 13.0, *)
extension addTodoListViewController
{
    func updateData()
    {
        manageObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoList")
        request.returnsObjectsAsFaults = false
        do {
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            let todayDate = formatter.string(from: date)

                let result = try manageObjectContext.fetch(request)
                let objectUpdate = result[notesId!] as! NSManagedObject
                objectUpdate.setValue(todoTitleField.text!, forKey: "title")
                objectUpdate.setValue(todoNotesTextView.text!, forKey: "content")
                objectUpdate.setValue(todayDate, forKey: "date")
                    do
                    {
                        try manageObjectContext.save()
                    }
                    catch let error as NSError
                    {
                        print("hello",error)
                    }

            }
        catch
        {
            ProgressHud.hide()

            print("Fetching data Failed")
        }
    }
}
