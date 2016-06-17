//
//  CategoriesMenuController.swift
//  venndor
//
//  Created by Saul Zetler on 2016-06-15.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation


class CategoriesMenuController: UITableViewController {
    
    @IBOutlet weak var allCell: UITableViewCell!
    
    @IBOutlet weak var furnitureCell: UITableViewCell!
    
    @IBOutlet weak var householdCell: UITableViewCell!
    
    @IBOutlet weak var kitchenCell: UITableViewCell!
    
    @IBOutlet weak var electronicsCell: UITableViewCell!
    
    @IBOutlet weak var booksCell: UITableViewCell!
    
    @IBOutlet weak var clothingCell: UITableViewCell!
    
    @IBOutlet weak var otherCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allCell.selectionStyle = UITableViewCellSelectionStyle.None
        furnitureCell.selectionStyle = UITableViewCellSelectionStyle.None
        householdCell.selectionStyle = UITableViewCellSelectionStyle.None
        kitchenCell.selectionStyle = UITableViewCellSelectionStyle.None
        electronicsCell.selectionStyle = UITableViewCellSelectionStyle.None
        booksCell.selectionStyle = UITableViewCellSelectionStyle.None
        clothingCell.selectionStyle = UITableViewCellSelectionStyle.None
        otherCell.selectionStyle = UITableViewCellSelectionStyle.None
        
        let buttonSize = CGRect(x: 80, y: 0, width: 50, height: 50)
        
        let allButton = makeButton("Home-50", frame: buttonSize, target: "toggleSelected:", tinted: true, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
        allCell.addSubview(allButton)
        
        let furnitureButton = makeButton("Chair-50", frame: buttonSize, target: "toggleSelected:", tinted: true, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
        furnitureCell.addSubview(furnitureButton)
        
        let householdButton = makeButton("Lamp-50", frame: buttonSize, target: "toggleSelected:", tinted: true, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
        householdCell.addSubview(householdButton)
        
        let kitchenButton = makeButton("Kitchen-50", frame: buttonSize, target: "toggleSelected:", tinted: true, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
        kitchenCell.addSubview(kitchenButton)
        
        let electronicsButton = makeButton("Multiple Devices-50", frame: buttonSize, target: "toggleSelected:", tinted: true, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
        electronicsCell.addSubview(electronicsButton)
        
        let booksButton = makeButton("Generic Book File Type-50", frame: buttonSize, target: "toggleSelected:", tinted: true, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
        booksCell.addSubview(booksButton)
        
        let clothingButton = makeButton("Clothes-50", frame: buttonSize, target: "toggleSelected:", tinted: true, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
        clothingCell.addSubview(clothingButton)
        
        let otherButton = makeButton("More-50", frame: buttonSize, target: "toggleSelected:", tinted: true, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
        otherCell.addSubview(otherButton)
    
        
    }
    
    func toggleSelected(sender: UIButton) {
        
//        for cell in self.tableView.visibleCells as [UIView] {
//            if let btn = cell.subviews as? UIButton{
//                btn.selected = false
//                print("called")
//            }
//        }
        
        if sender.selected == false {
            sender.selected = true
        }
        else {
            sender.selected = false
        }
        
        
    }
    
}