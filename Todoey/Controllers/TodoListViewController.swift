//
//  ViewController.swift
//  Todoey
//
//  Created by Baran Atmanoglu on 1/22/18.
//  Copyright © 2018 Baran Atmanoglu. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController  {

    let realm = try! Realm()
    var toDoItems :  Results<Item>?
    
    var selectedCategory : Category?{
        didSet{
            
            loadItems()
        }
    }
    
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory!.name
        guard let hexColor = selectedCategory?.backgroundcolor else {fatalError("Category Color Does Not Exist")}
       
       updateNavBar(withHexCode: hexColor)
 
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "0096FF")
    }

    
    //MARK: - NavBar Setup Methods
    func updateNavBar(withHexCode colorHexCode: String){
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller Does Not Exist")}
        guard let navBarColor = UIColor(hexString: colorHexCode) else {fatalError("Not a Valid Hex String")}
        
        
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        searchBar.barTintColor = navBarColor
        
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    
    //cellForRowAt - TableViewi hangi celller ile dolduracagini belirtiyor.
    //tableviewcontollerlar icindeki prototypecelleri olusturup tableview icine atiyorsun.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
            
            if let color = UIColor(hexString : selectedCategory!.backgroundcolor)?.darken(byPercentage:CGFloat(indexPath.row) / CGFloat(toDoItems!.count)){
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
        }
        else{
            cell.textLabel?.text = "No items added."
        }
        
       
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row]{
            do{ try realm.write {
                    item.done = !item.done
                    //realm.delete(item) dersen de silmis olursun
                }
            }
            catch{
                print("Error writing done \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK - ADD new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }
                catch{
                    print("Error adding new item \(error)")
                }
            }
            self.tableView.reloadData()
            
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert,animated: true, completion: nil)
    }
    
    
   
    
    func loadItems(){
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending:true)
        tableView.reloadData()
    }
    
    //MARK: - Delete Dat From Swipe
    override func updateModel(at indexPath : IndexPath){
        if let itemForDeletion = self.toDoItems?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            }
            catch{
                print("Error while deleting category: \(error)")
            }
            
        }
    }
    
    
    
}

//MARK: SearcBar Delegate Methods
extension TodoListViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@",searchBar.text! ).sorted(byKeyPath: "dateCreated",ascending: true)

        tableView.reloadData()

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()

            //Bu kod keyboardin geri gitmesini sagliyor.
            DispatchQueue.main.async {
               searchBar.resignFirstResponder()
            }

        }
    }
}

