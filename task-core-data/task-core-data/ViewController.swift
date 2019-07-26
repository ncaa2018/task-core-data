//
//  ViewController.swift
//  task-core-data
//
//  Created by Mohammed Almaroof on 7/25/19.
//  Copyright © 2019 Mohammed Almaroof. All rights reserved.
//

import UIKit
// TODO: Import CoreData and connect container to this ViewController
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet var personNameTextField: UITextField!
    @IBOutlet var taskNameTextField: UITextField!
    @IBOutlet var taskDeadlinePicker: UIDatePicker!
    @IBOutlet var personNameLabel: UILabel!
    @IBOutlet var numberOfTasksLabel: UILabel!
    @IBOutlet var taskDeadlineLabel: UILabel!
    @IBOutlet var taskNameLabel: UILabel!
    
    var listOfTasks:[Task] = []
    var container: NSPersistentContainer! //interface from model to view controller
    //creating a container that has access to Core Data Model, from App Delegate

    override func viewDidLoad() {
        super.viewDidLoad()
        //making sure container is not empty
        guard container != nil else {
            fatalError("This view needs a persistent container.")
        }         // The persistent container is available.

        taskNameLabel.text = ""
        taskDeadlineLabel.text = ""
        personNameLabel.text = ""
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        // TODO: Save the user input by the user
        // read the user name from the text field
        // and check if it is null before actually saving.
        if let userName = personNameTextField.text {//checking if they actually put in a name
            var user = NSEntityDescription.insertNewObject(forEntityName: "User", into: container.viewContext) as! User
        user.name = userName
            for task in listOfTasks {
                user.addToAssignedTasks(task)
            }
            try! container.viewContext.save() //saving data, try --> keyword to try block of code. If something goes wrong, you can catch the error
        }
    }
        
    @IBAction func loadButtonPressed(_ sender: Any) {
        // TODO: Load the most recent person saved, and render the information
        // of the user and their most recent task in the labels
        // prepares request to get all the user entities that we saved --> return type <NSFetchRequestResult> instead of "Any"
        let itemsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User") //fetch and retain data
        //executes the request and converts the result to a list of users
        let requestResults = try! container.viewContext.fetch(itemsFetchRequest) as! [User]//returns value type of "any" --> must cast as an array of users
       // print("Fetch items: \(requestResults)")
        
        //checking if there are users that we got back
        if requestResults.count > 0 {
            //getting more recent user in the list
            let mostRecentUser = requestResults[requestResults.count - 1]
            //displaying user information
            personNameLabel.text =  mostRecentUser.name
            //
            if let tasklist = mostRecentUser.assignedTasks?.allObjects { //converted from a set of typr "NSSet?" to array of Any
                //allObjects --> array of "Any" --> must cast to get array of type Task
                //converted to array of tasks
                if let taskArray = tasklist as? [Task] {
                    let mostRecentTask = taskArray[taskArray.count - 1]
                    taskNameLabel.text = mostRecentTask.name
                    taskDeadlineLabel.text = mostRecentTask.deadline?.description //.description to save as string
                }
            }
        }
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        personNameTextField.text = ""
        taskNameTextField.text = ""
        numberOfTasksLabel.text = "Number of tasks:"
        listOfTasks = []
    }
    @IBAction func addTaskButtonPressed(_ sender: Any) {
        // TODO: Add a task to the list of tasks array
        // reading from the task text field and the date picker
        // make sure task name is not empty
        if let taskName = taskNameTextField.text {  //checking if user actually put a name in the text field
            var taskDeadline = taskDeadlinePicker.date
            let task = NSEntityDescription.insertNewObject(forEntityName: "Task", into: container.viewContext) as! Task //creating a blank entity from scratch, based on user input, also including the container to read from
            task.name = taskName //setting the attribute of the task "name"
            task.deadline = taskDeadline //
            listOfTasks.append(task)
            numberOfTasksLabel.text = "Number of tasks: \(listOfTasks.count)"
            
        }
    }
    
}

