//
//  ViewController.swift
//  iOSCoreData
//
//  Created by Chotipat on 9/17/2559 BE.
//  Copyright © 2559 Chotipat. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UITableViewController {
    
    var person = [NSManagedObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(ViewController.addItem))
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
    
    func addItem(){
        let alert = UIAlertController(title: "Add Item", message: "Please add item", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:({
            (_)in
            if let field = alert.textFields![0] as? UITextField{
                if field.text != ""{
                   print("Save Text")
                   self.saveItem(field.text!)
                }
                self.tableView.reloadData()
            }
        }
    ))
        let  cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addTextField(configurationHandler: {
            (textField) in
            textField.placeholder = "Your data"
        })
        
        alert.addAction(cancelAction)
        alert.addAction(confirm)

        self.present(alert, animated: true, completion: nil)
        
    
    }
    
    func saveItem(_ itemToSave : String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "PersonEntity", in: managedContext)
        let item = NSManagedObject(entity: entity!, insertInto: managedContext)
        item.setValue(itemToSave, forKey: "firstname")
        do{
            try managedContext.save()
            person.append(item)
        }catch{
            print("error")
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
      //  let fetch = NSFetchRequest(entityName: "PersonEntity")
        let fetch:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "PersonEntity")
        do{
            let result = try managedContext.fetch(fetch)
            person = result as! [NSManagedObject]
        }catch{
            print("error")
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.right)
        managedContext.delete(person[(indexPath as NSIndexPath).row])
        person.remove(at: (indexPath as NSIndexPath).row)
        self.tableView.reloadData()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return person.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")! as UITableViewCell
        let item = person[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = item.value(forKey: "firstname") as? String
        return cell
    }
}

