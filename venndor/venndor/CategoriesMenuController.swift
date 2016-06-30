//
//  CategoriesMenuController.swift
//  venndor
//
//  Created by Saul Zetler on 2016-06-15.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation


class CategoriesMenuController: UITableViewController {
    
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    @IBOutlet var table: UITableView!
    
    @IBOutlet weak var allCell: UITableViewCell!
    
    @IBOutlet weak var furnitureCell: UITableViewCell!
    
    @IBOutlet weak var householdCell: UITableViewCell!
    
    @IBOutlet weak var kitchenCell: UITableViewCell!
    
    @IBOutlet weak var electronicsCell: UITableViewCell!
    
    @IBOutlet weak var booksCell: UITableViewCell!
    
    @IBOutlet weak var clothingCell: UITableViewCell!
    
    @IBOutlet weak var otherCell: UITableViewCell!
    
    var allButton: UIButton!
    var furnitureButton: UIButton!
    var householdButton: UIButton!
    var kitchenButton: UIButton!
    var electronicsButton: UIButton!
    var booksButton: UIButton!
    var clothingButton: UIButton!
    var otherButton: UIButton!
    
    var categorySelection: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCells()
        setupButtons()
        
    }
    
    func setupCells() {
        allCell.selectionStyle = UITableViewCellSelectionStyle.None
        furnitureCell.selectionStyle = UITableViewCellSelectionStyle.None
        householdCell.selectionStyle = UITableViewCellSelectionStyle.None
        kitchenCell.selectionStyle = UITableViewCellSelectionStyle.None
        electronicsCell.selectionStyle = UITableViewCellSelectionStyle.None
        booksCell.selectionStyle = UITableViewCellSelectionStyle.None
        clothingCell.selectionStyle = UITableViewCellSelectionStyle.None
        otherCell.selectionStyle = UITableViewCellSelectionStyle.None
        allCell.selected = true
    }
    
    func setupButtons() {
        let buttonSize = CGRect(x: screenSize.width * 0.25, y: screenSize.height * 0.007, width: screenSize.width * 0.15, height: screenSize.width * 0.15)
        
        allButton = makeImageButton("Home-50", frame: buttonSize, target: "toggleSelected:", tinted: true, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
        allButton.tag = 1
        allCell.addSubview(allButton)
        
        furnitureButton = makeImageButton("Chair-50", frame: buttonSize, target: "toggleSelected:", tinted: true, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
        furnitureButton.tag = 2
        furnitureCell.addSubview(furnitureButton)
        
        householdButton = makeImageButton("Lamp-50", frame: buttonSize, target: "toggleSelected:", tinted: true, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
        householdButton.tag = 3
        householdCell.addSubview(householdButton)
        
        kitchenButton = makeImageButton("Kitchen-50", frame: buttonSize, target: "toggleSelected:", tinted: true, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
        kitchenButton.tag = 4
        kitchenCell.addSubview(kitchenButton)
        
        electronicsButton = makeImageButton("Multiple Devices-50", frame: buttonSize, target: "toggleSelected:", tinted: true, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
        electronicsButton.tag = 5
        electronicsCell.addSubview(electronicsButton)
        
        booksButton = makeImageButton("Generic Book File Type-50", frame: buttonSize, target: "toggleSelected:", tinted: true, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
        booksButton.tag = 6
        booksCell.addSubview(booksButton)
        
        clothingButton = makeImageButton("Clothes-50", frame: buttonSize, target: "toggleSelected:", tinted: true, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
        clothingButton.tag = 7
        clothingCell.addSubview(clothingButton)
        
        otherButton = makeImageButton("More-50", frame: buttonSize, target: "toggleSelected:", tinted: true, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
        otherButton.tag = 8
        otherCell.addSubview(otherButton)
        
    }
    
    func toggleSelected(sender: UIButton) {
        
        switch sender.tag {
        case 1:
            GlobalItems.currentCategory = nil
            break;
        case 2:
            GlobalItems.currentCategory = "category=Furniture"
            break;
        case 3:
            GlobalItems.currentCategory = "category=Kitchen"
            break;
        case 4:
            GlobalItems.currentCategory = "category=Household"
            break;
        case 5:
            GlobalItems.currentCategory = "category=Electronics"
            break;
        case 6:
            GlobalItems.currentCategory = "category=Clothing"
            break;
        case 7:
            GlobalItems.currentCategory = "category=Books"
            break;
        case 8:
            GlobalItems.currentCategory = "category=Other"
            break;
        default: ()
            break;
        }
        
        
        allButton.selected = false
        furnitureButton.selected = false
        householdButton.selected = false
        kitchenButton.selected = false
        electronicsButton.selected = false
        booksButton.selected = false
        clothingButton.selected = false
        otherButton.selected = false
        
        sender.selected = true
        
        self.performSegueWithIdentifier("newCat", sender: self)
    }
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
//        if (segue.identifier == "newCat") {
//            let svc = segue.destinationViewController as! SplashViewController;
//            
//            svc.categorySelected = self.categorySelection
//            
//        }
//    }
    
}