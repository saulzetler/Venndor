//
//  CategoriesMenuController.swift
//  venndor
//
//  Created by Saul Zetler on 2016-06-15.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation


class CategoriesMenuController: UITableViewController {
    //declare screensize for future reference
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    //link the table and buttons
    @IBOutlet var table: UITableView!
    
    @IBOutlet weak var titleCell: UIView!
    
    @IBOutlet weak var allCell: UITableViewCell!
    
    @IBOutlet weak var furnitureCell: UITableViewCell!
    
    @IBOutlet weak var householdCell: UITableViewCell!
    
    @IBOutlet weak var kitchenCell: UITableViewCell!
    
    @IBOutlet weak var electronicsCell: UITableViewCell!
    
    @IBOutlet weak var booksCell: UITableViewCell!
    
    @IBOutlet weak var clothingCell: UITableViewCell!
    
    @IBOutlet weak var otherCell: UITableViewCell!
    //declare the buttons
    var allButton: UIButton!
    var furnitureButton: UIButton!
    var householdButton: UIButton!
    var kitchenButton: UIButton!
    var electronicsButton: UIButton!
    var booksButton: UIButton!
    var clothingButton: UIButton!
    var otherButton: UIButton!
    //declare the category string to pass to other pages as the current category selected
    var categorySelection: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.view.backgroundColor = UIColorFromHex(0x2c3e50, alpha: 1)
        
        setupButtons()
        setupCells()
        
    }
    //setup the cells for the menu
    func setupCells() {
        titleCell.frame = CGRect(x: screenSize.width*0.7, y: 0, width: screenSize.width*0.3, height: screenSize.height*0.1)
        titleCell.backgroundColor = UIColorFromHex(0x2c3e50, alpha: 1)
        let title = UILabel(frame: CGRect(x: screenSize.width*0.27, y: -10, width: titleCell.frame.width, height: screenSize.height*0.1))
        title.text = "Browse By..."
        title.textAlignment = .Center
        title.textColor = UIColor.whiteColor()
        titleCell.addSubview(title)
        
        let whiteLine = UIView(frame: CGRectMake(0, 40, screenSize.width, 1))
        whiteLine.backgroundColor = UIColor.whiteColor()
        titleCell.addSubview(whiteLine)
        
        allCell.selectionStyle = UITableViewCellSelectionStyle.None
        furnitureCell.selectionStyle = UITableViewCellSelectionStyle.None
        householdCell.selectionStyle = UITableViewCellSelectionStyle.None
        kitchenCell.selectionStyle = UITableViewCellSelectionStyle.None
        electronicsCell.selectionStyle = UITableViewCellSelectionStyle.None
        booksCell.selectionStyle = UITableViewCellSelectionStyle.None
        clothingCell.selectionStyle = UITableViewCellSelectionStyle.None
        otherCell.selectionStyle = UITableViewCellSelectionStyle.None
        if GlobalItems.currentCategory == nil {
            allButton.selected = true
        } else if GlobalItems.currentCategory == "Furniture" {
            furnitureButton.selected = true
        } else if GlobalItems.currentCategory == "Household" {
            householdButton.selected = true
        } else if GlobalItems.currentCategory == "Kitchen" {
            kitchenButton.selected = true
        } else if GlobalItems.currentCategory == "Electronics" {
            electronicsButton.selected = true
        } else if GlobalItems.currentCategory == "Books" {
            booksButton.selected = true
        } else if GlobalItems.currentCategory == "Clothing" {
            clothingButton.selected = true
        } else {
            otherButton.selected = true
        }
        allCell.backgroundColor = UIColorFromHex(0x2c3e50, alpha: 0.8)
        furnitureCell.backgroundColor = UIColorFromHex(0x2c3e50, alpha: 0.8)
        householdCell.backgroundColor = UIColorFromHex(0x2c3e50, alpha: 0.8)
        kitchenCell.backgroundColor = UIColorFromHex(0x2c3e50, alpha: 0.8)
        electronicsCell.backgroundColor = UIColorFromHex(0x2c3e50, alpha: 0.8)
        booksCell.backgroundColor = UIColorFromHex(0x2c3e50, alpha: 0.8)
        clothingCell.backgroundColor = UIColorFromHex(0x2c3e50, alpha: 0.8)
        otherCell.backgroundColor = UIColorFromHex(0x2c3e50, alpha: 0.8)
    }
    
    //create the buttons for the menu
    func setupButtons() {
        //declare the button sizes for the refactored methods to create the buttons
        let buttonSize = CGRect(x: allCell.frame.width*0.155, y: screenSize.height * 0.007, width: screenSize.width * 0.3, height: screenSize.width * 0.15)
        let buttonSizeFirst = CGRect(x: allCell.frame.width*0.155, y: screenSize.height * 0.03, width: screenSize.width * 0.3, height: screenSize.width * 0.15)
        
        allButton = makeTextButton("All", frame: buttonSizeFirst, target: #selector(CategoriesMenuController.toggleSelected(_:)), circle: false, textColor: UIColorFromHex(0xFFFFFF), tinted: true, backgroundColor: UIColorFromHex(0x2c3e50, alpha: 0.8))
//        allButton = makeImageButton("Home.png", frame: buttonSize, target: #selector(CategoriesMenuController.toggleSelected(_:)), tinted: true, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
        allButton.tag = 1
        allButton.titleLabel?.font = UIFont(name: "Avenir", size: 18)
        
//        allButton.titleLabel?.textAlignment = .Center
        allCell.addSubview(allButton)
        
        furnitureButton = makeTextButton("Furniture", frame: buttonSize, target: #selector(CategoriesMenuController.toggleSelected(_:)), circle: false, textColor: UIColorFromHex(0xFFFFFF), tinted: true, backgroundColor: UIColorFromHex(0x2c3e50, alpha: 0.8))
//        furnitureButton = makeImageButton("Sofa.png", frame: buttonSize, target: #selector(CategoriesMenuController.toggleSelected(_:)), tinted: true, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
        furnitureButton.tag = 2
        furnitureButton.titleLabel?.font = UIFont(name: "Avenir", size: 18)
        furnitureCell.addSubview(furnitureButton)
        
        householdButton = makeTextButton("Household", frame: buttonSize, target: #selector(CategoriesMenuController.toggleSelected(_:)), circle: false, textColor: UIColorFromHex(0xFFFFFF), tinted: true, backgroundColor: UIColorFromHex(0x2c3e50, alpha: 0.8))
//        householdButton = makeImageButton("Lamp Filled.png", frame: buttonSize, target: #selector(CategoriesMenuController.toggleSelected(_:)), tinted: true, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
        householdButton.tag = 3
        householdButton.titleLabel?.font = UIFont(name: "Avenir", size: 18)
        householdCell.addSubview(householdButton)
        
        kitchenButton = makeTextButton("Kitchen", frame: buttonSize, target: #selector(CategoriesMenuController.toggleSelected(_:)), circle: false, textColor: UIColorFromHex(0xFFFFFF), tinted: true, backgroundColor: UIColorFromHex(0x2c3e50, alpha: 0.8))
//        kitchenButton = makeImageButton("Kitchen Filled.png", frame: buttonSize, target: #selector(CategoriesMenuController.toggleSelected(_:)), tinted: true, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
        kitchenButton.tag = 4
        kitchenButton.titleLabel?.font = UIFont(name: "Avenir", size: 18)
        kitchenCell.addSubview(kitchenButton)
        
        electronicsButton = makeTextButton("Electronics", frame: buttonSize, target: #selector(CategoriesMenuController.toggleSelected(_:)), circle: false, textColor: UIColorFromHex(0xFFFFFF), tinted: true, backgroundColor: UIColorFromHex(0x2c3e50, alpha: 0.8))
//        electronicsButton = makeImageButton("Computer Filled.png", frame: buttonSize, target: #selector(CategoriesMenuController.toggleSelected(_:)), tinted: true, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
        electronicsButton.tag = 5

        electronicsButton.titleLabel?.font = UIFont(name: "Avenir", size: 18)
        electronicsCell.addSubview(electronicsButton)
        
        booksButton = makeTextButton("Books", frame: buttonSize, target: #selector(CategoriesMenuController.toggleSelected(_:)), circle: false, textColor: UIColorFromHex(0xFFFFFF), tinted: true, backgroundColor: UIColorFromHex(0x2c3e50, alpha: 0.8))
//        booksButton = makeImageButton("Generic Book File Type Filled.png", frame: buttonSize, target: #selector(CategoriesMenuController.toggleSelected(_:)), tinted: true, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
        booksButton.tag = 6

        booksButton.titleLabel?.font = UIFont(name: "Avenir", size: 18)
        booksCell.addSubview(booksButton)
        
        clothingButton = makeTextButton("Clothing", frame: buttonSize, target: #selector(CategoriesMenuController.toggleSelected(_:)), circle: false, textColor: UIColorFromHex(0xFFFFFF), tinted: true, backgroundColor: UIColorFromHex(0x2c3e50, alpha: 0.8))
//        clothingButton = makeImageButton("Clothes Filled.png", frame: buttonSize, target: #selector(CategoriesMenuController.toggleSelected(_:)), tinted: true, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
        clothingButton.tag = 7

        clothingButton.titleLabel?.font = UIFont(name: "Avenir", size: 18)
        clothingCell.addSubview(clothingButton)
        
        otherButton = makeTextButton("Other", frame: buttonSize, target: #selector(CategoriesMenuController.toggleSelected(_:)), circle: false, textColor: UIColorFromHex(0xFFFFFF), tinted: true, backgroundColor: UIColorFromHex(0x2c3e50, alpha: 0.8))
//        otherButton = makeImageButton("More Filled.png", frame: buttonSize, target: #selector(CategoriesMenuController.toggleSelected(_:)), tinted: true, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
        otherButton.tag = 8

        otherButton.titleLabel?.font = UIFont(name: "Avenir", size: 18)
        otherCell.addSubview(otherButton)
        
    }
    
    
    /* MAKE THE HIGHLIGHTING OF CATEGORIES PERSISTENT */
    
    
    //function to control the selection of category
    func toggleSelected(sender: UIButton) {
        //switch case to control which category should be selected
        switch sender.tag {
        case 1:
            GlobalItems.currentCategory = nil
            break;
        case 2:
            GlobalItems.currentCategory = "Furniture"
            break;
        case 3:
            GlobalItems.currentCategory = "Household"
            break;
        case 4:
            GlobalItems.currentCategory = "Kitchen"
            break;
        case 5:
            GlobalItems.currentCategory = "Electronics"
            break;
        case 6:
            GlobalItems.currentCategory = "Books"
            break;
        case 7:
            GlobalItems.currentCategory = "Clothing"
            break;
        case 8:
            GlobalItems.currentCategory = "Other"
            break;
        default: ()
            break;
        }
        
        //change the tint/selection of every button to not higlighted
        allButton.selected = false
        furnitureButton.selected = false
        householdButton.selected = false
        kitchenButton.selected = false
        electronicsButton.selected = false
        booksButton.selected = false
        clothingButton.selected = false
        otherButton.selected = false
        //make the sender highlighted
        sender.selected = true
        LocalUser.user.mostRecentAction = "Filtered by category: \(GlobalItems.currentCategory)"
        self.performSegueWithIdentifier("newCat", sender: self)
    }
    
}