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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(ViewController.addItem))
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
    
    func addItem(){
        let alert = UIAlertController(title: "Add Item", message: "Please add item", preferredStyle: .Alert)
        let confirm = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:({
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
        let  cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addTextFieldWithConfigurationHandler({
            (textField) in
            textField.placeholder = "Your data"
        })
        
        alert.addAction(cancelAction)
        alert.addAction(confirm)

        self.presentViewController(alert, animated: true, completion: nil)
        
    
    }
    
    func saveItem(itemToSave : String){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("PersonEntity", inManagedObjectContext: managedContext)
        let item = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        item.setValue(itemToSave, forKey: "firstname")
        do{
            try managedContext.save()
            person.append(item)
        }catch{
            print("error")
        }

    }
    override func viewWillAppear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetch = NSFetchRequest(entityName: "PersonEntity")

        do{
            let result = try managedContext.executeFetchRequest(fetch)
            person = result as! [NSManagedObject]
        }catch{
            print("error")
        }
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Right)
        managedContext.deleteObject(person[indexPath.row])
        person.removeAtIndex(indexPath.row)
        self.tableView.reloadData()
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return person.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        let item = person[indexPath.row]
        cell.textLabel?.text = item.valueForKey("firstname") as? String
        
        return cell
    }
}

