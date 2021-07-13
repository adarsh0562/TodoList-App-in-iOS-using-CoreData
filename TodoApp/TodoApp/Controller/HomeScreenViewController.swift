//
//  HomeScreenViewController.swift
//  TodoApp
//
//  Created by Adarsh Raj on 08/07/21.
//

import UIKit
import CoreData


@available(iOS 13.0, *)
class HomeScreenViewController: UIViewController{

    @IBOutlet weak var notesCollectionView: UICollectionView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var notesCountLabel: UILabel!
    
    @IBOutlet weak var folderSectionView: UIView!
    @IBOutlet weak var navbarSection: UIView!
    @IBOutlet weak var folderViewHeight: NSLayoutConstraint!
    @IBOutlet weak var notesCollectionViewHeight: NSLayoutConstraint!
    var userListArray: [[String:Any]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        notesCollectionView.delegate = self
        notesCollectionView.dataSource = self
//        notesCountLabel.text! = "\(userListArray.count) notes"
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ProgressHud.show()
        navigationController?.navigationBar.isHidden = true
        userListArray.removeAll()
        fetchData()
    }
    
    //Add new Todo
    @IBAction func addNewTodo(_ sender: Any) {
        let cartVC = storyboard?.instantiateViewController(withIdentifier: "addTodoListViewController") as! addTodoListViewController
        
        navigationController?.pushViewController(cartVC, animated: true)
    }
    
     //MARK:- Delete All Records
    @IBAction func deleteAllNotes(_ sender: Any) {
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to Delete?", preferredStyle: .alert)

                // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { [self] (action) -> Void in
                print("Ok button click...")
            ProgressHud.show()

            manageObjectContext = appDelegate.persistentContainer.viewContext

            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoList")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                   do {
                    try manageObjectContext.execute(batchDeleteRequest)
                    userListArray.removeAll()
                    fetchData()
                    ProgressHud.hide()
                    

                      } catch {
            // Error Handling
                        ProgressHud.hide()
                }
                })
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button click...")
        }

        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)

        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
    
    
}

// MARK:- Collection View Code

@available(iOS 13.0, *)
extension HomeScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userListArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = notesCollectionView.dequeueReusableCell(withReuseIdentifier: "NotesCollectionViewCell", for: indexPath) as! NotesCollectionViewCell
        cell.notesView.dropShadow()
       
        let cellData = userListArray[indexPath.row]
        cell.notesTitle!.text! = "\(cellData["title"] as! String)"
        cell.notesDate!.text! = "\(cellData["date"] as! String)"
        cell.notesContent!.text! = "\(cellData["content"] as! String)"
        cell.delButton.tag = indexPath.row
        cell.delButton.addTarget(self, action: #selector(delButtonAction), for: .touchUpInside)
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                
        let data = userListArray[indexPath.row]
        let nextController = storyboard?.instantiateViewController(identifier: "addTodoListViewController") as! addTodoListViewController
        nextController.arraylist = data
        nextController.notesId = indexPath.row
        self.navigationController?.pushViewController(nextController, animated: true)
        
    }
     // delete when click
    @objc func delButtonAction(_ sender: UIButton)
    {
        
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to Delete?", preferredStyle: .alert)

                // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Ok button click...")
                if self.deleteData(index:sender.tag) == true
                    {
                        self.userListArray.removeAll()
                        self.fetchData()
                    }
                })

                // Create Cancel button with action handlder
                let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                    print("Cancel button click...")
                }

                //Add OK and Cancel button to dialog message
                dialogMessage.addAction(ok)
                dialogMessage.addAction(cancel)

                // Present dialog message to user
                self.present(dialogMessage, animated: true, completion: nil)
    }
}
    


// MARK:- Adding Scroll Animation
@available(iOS 13.0, *)
extension HomeScreenViewController
{
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
       if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
          //navigationController?.setNavigationBarHidden(true, animated: true)
        folderSectionView.isHidden = true
        folderViewHeight.constant = 0
        notesCollectionViewHeight.constant = 800
        

       } else {
          //navigationController?.setNavigationBarHidden(false, animated: true)
        folderSectionView.isHidden = false
        folderViewHeight.constant = 220
        notesCollectionViewHeight.constant = 569

       }
    }
}

// MARK:- Fetching Data from CoreData
@available(iOS 13.0, *)
extension HomeScreenViewController
{
    func fetchData()
    {
        ProgressHud.show()
        manageObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoList")
        request.returnsObjectsAsFaults = false
        do {
                let result = try manageObjectContext.fetch(request)
                for data in result as! [NSManagedObject]
                {
                    if result.count > 0
                    {
                        let title = data.value(forKey: "title") as! String
                        let date = data.value(forKey: "date") as! String
                        let content = data.value(forKey: "content") as! String
                        let dic = ["title":title,"date":date,"content":content]
                        userListArray.append(dic)
                    }
                }
                    notesCountLabel.text! = "\(userListArray.count) notes"
                    
            }
        catch
        {
            ProgressHud.hide()

            print("Fetching data Failed")
        }
        DispatchQueue.main.async
        {
            self.notesCollectionView.reloadData()
            ProgressHud.hide()

        }
        
    }
}

//MARK:- Delete Notes here
@available(iOS 13.0, *)
extension HomeScreenViewController
{
    
    func deleteData(index:Int) -> Bool
    {
        manageObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoList")
        request.returnsObjectsAsFaults = false
        do {
                let result = try manageObjectContext.fetch(request)
                manageObjectContext.delete(result[index] as! NSManagedObject)
                    do
                    {
                        try manageObjectContext.save()
                        return true
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
        return false
    }
}

