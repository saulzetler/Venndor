//
//  CategoriesMenuController.swift
//  venndor
//
//  Created by Saul Zetler on 2016-06-15.
//  Copyright © 2016 Venndor. All rights reserved.
//

import Foundation


class CategoriesMenuController: UITableViewController {
    
    
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
    }
    
    func setupButtons() {
        let buttonSize = CGRect(x: 80, y: 0, width: 50, height: 50)
        
        allButton = makeImageButton("Home-50", frame: buttonSize, target: "toggleSelected:", tinted: true, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
        allCell.addSubview(allButton)
        
        furnitureButton = makeImageButton("Chair-50", frame: buttonSize, target: "toggleSelected:", tinted: true, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
        furnitureCell.addSubview(furnitureButton)
        
        householdButton = makeImageButton("Lamp-50", frame: buttonSize, target: "toggleSelected:", tinted: true, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
        householdCell.addSubview(householdButton)
        
        kitchenButton = makeImageButton("Kitchen-50", frame: buttonSize, target: "toggleSelected:", tinted: true, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
        kitchenCell.addSubview(kitchenButton)
        
        electronicsButton = makeImageButton("Multiple Devices-50", frame: buttonSize, target: "toggleSelected:", tinted: true, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
        electronicsCell.addSubview(electronicsButton)
        
        booksButton = makeImageButton("Generic Book File Type-50", frame: buttonSize, target: "toggleSelected:", tinted: true, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
        booksCell.addSubview(booksButton)
        
        clothingButton = makeImageButton("Clothes-50", frame: buttonSize, target: "toggleSelected:", tinted: true, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
        clothingCell.addSubview(clothingButton)
        
        otherButton = makeImageButton("More-50", frame: buttonSize, target: "toggleSelected:", tinted: true, circle: false, backgroundColor: 0x000000, backgroundAlpha: 0)
        otherCell.addSubview(otherButton)
        
    }
    
    func toggleSelected(sender: UIButton) {
        allButton.selected = false
        furnitureButton.selected = false
        householdButton.selected = false
        kitchenButton.selected = false
        electronicsButton.selected = false
        booksButton.selected = false
        clothingButton.selected = false
        otherButton.selected = false
        
        sender.selected = true
    }
    
}