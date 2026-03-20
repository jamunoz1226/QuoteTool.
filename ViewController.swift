//
//  ViewController.swift
//  Quote Tool
//
//  Created by Jorge Munoz on 2/11/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //CD S1 - create a relation with the container file to have access in the viewController
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    //assigning TVC
    @IBOutlet weak var monthlyCostTVC: UITableView!
    @IBOutlet weak var upfrontCostTVC: UITableView!
     
    //CD S2 - creating private variable to store items from core data properties file into an array
    private var models = [QuoteInfo]()
    // CD S2 - only if you have multiple views that you need to create another one
    private var modelss = [QuoteInfo]()
    
    //using these examples to show UITableView
     var nameArray = [ "Ethan", "Oliver", "Leo", "Caleb", "Jackson" ]
     var name1Array = [ "Ava", "Isabella", "Sophia", "Mia", "Amelia" ]
     

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //setting display for top TVC
        monthlyCostTVC.dataSource = self
        monthlyCostTVC.delegate = self
        
        // setting display for bottom TVC - must create separate pairs so that numOfRows & cellforRow display properly
        upfrontCostTVC.dataSource = self
        upfrontCostTVC.delegate = self
        
        //Adjusting display
        display()
        calculations()
        
    }
    
    //MARK: Display Design
    func display() {
        
        title = "Quote Tool"
        
        // roundung corners for UITableView
        monthlyCostTVC.layer.cornerRadius = 20
        upfrontCostTVC.layer.cornerRadius = 20
        
    }
    
    //MARK: Button Actions / TODO
    
    func showAlert(title: String, message: String, completion: Bool)
    {
        
        // creating constants to store the alert Controller
        //create constant to store the alert Controller
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // add textfield for product description
        alert.addTextField{ textField in
            
            // textfield inside the placeholder = whatever you want it to say
            textField.placeholder = "Enter product description"
            
        }
        
        // add textfield for product cost
        alert.addTextField{ textField in
            // textfield.placeholder = "whatever you want it to say"
            textField.placeholder = "Enter product cost"
            //turn keyboard into a num pad keyboard
            textField.keyboardType = .numbersAndPunctuation
            
        }
        
        // TODO: start storing in data and saving to data.
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { _ in
            //let productName = alert.textFields?[0].text ?? ""
            let productCost = alert.textFields?[1].text ?? ""
            
            guard let field = alert.textFields?[0], let text = field.text, !text.isEmpty else {
                return
            }
            
            guard let subField = alert.textFields?[1], let monthlyCost = subField.text, !monthlyCost.isEmpty else {
                return
            }
            
            self.createData(productName: text, monthlyCost: 0, upfrontCost: 0)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        DispatchQueue.main.async {
            
            self.present(alert, animated: true)
        }
    }
 
    @IBAction func addCostTapped(_ sender: UIButton) {
        
        if sender.tag == 0 {
            showAlert(title: "Monthly Cost", message: "", completion: true)
        } else {
            showAlert(title: "Upfront Cost", message: "", completion: true)
        }
    }
    
    //MARK: TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 0 {
            
            return models.count
        } else {
            return modelss.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if tableView.tag == 0 {
            
            cell.textLabel?.text = model.productName?.capitalized
            cell.detailTextLabel?.text = "World!"
            
            return cell
        } else {
 
           // let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            cell.textLabel?.text = model.productName?.capitalized
            cell.detailTextLabel?.text = "Doc?!"
            
            return cell
        }
    }
    
    func tableView(_ tablewView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        // item constant made to keep track of cell selected in the row
        let item = models[indexPath.row]
    }
    
    //MARK: CoreData
    
    //CD S3 - using FUCD[fetch, update, create and delete data methods for the core data]
    func fetchData() {
        
        //use do catch loops to protect errors
        do {
            
            //using the private var to get the info for the properties file
            let models = try context.fetch(QuoteInfo.fetchRequest())
           
            // monthlyCost = models.filer {$0.monthlyPrice != nil}
            // upfrontCost = models.filer {$0.upfrontPrice != nil}
            //DispatchQueue to protect data from errors
            DispatchQueue.main.async {
                self.upfrontCostTVC.reloadData() // self.[name of tableView or UIView].reloadData()
                self.monthlyCostTVC.reloadData()
            }
        } catch {
            
            print("Error at fetchData()")
        }
        
    }
    
    // parameters must contain the item constant
    func updateData(item:QuoteInfo, newName: String, newMonthly: Double, newUpfront: Double ) {
        
        item.productName = newName
        item.monthlyCost = newMonthly
        item.upfrontCost = newUpfront
        
        do {
            
            try context.save()
            fetchData()
        } catch {
            
            print("error at updateData")
        }
        
    }
    
    // parameters are each object inside the core data properties class
    func createData(productName: String, monthlyCost: Double, upfrontCost: Double) {
        
        // create a constant to store user input
        let newItem = QuoteInfo(context: context)
        newItem.productName = productName // constant.core data obj = new variable name
        newItem.monthlyCost = monthlyCost
        newItem.upfrontCost = upfrontCost 
        
        do {
            try context.save()
            fetchData()
        } catch {
            
            print("error at createData()")
        }
    }
    
    // parameters must have "item" constant created at didSelect TVC func : CoreData class name
    func deleteData(item: QuoteInfo) {
        
        context.delete(item) // item is the constant created to store variable in the private var [models] at didSelect func
        
        do {
            
            try context.save()
            fetchData()
        } catch {
            print("error at deleteData")
        }
    }
    
    
    //MARK: Calculations
    func calculations() {
        
        print("hello world!")
    }


}

