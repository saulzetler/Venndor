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
        
        let allButton = UIButton(frame: CGRect(x: 80, y: 0, width: 50, height: 50))
        allButton.addTarget(self, action: "toggleSelected:", forControlEvents: UIControlEvents.TouchUpInside)
        let origAll = UIImage(named: "Home-50")
        let tintedAll = origAll?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        allButton.setImage(tintedAll, forState: .Selected)
        allButton.setImage(origAll, forState: .Normal)
        allCell.addSubview(allButton)
        
        let furnitureButton = UIButton(frame: CGRect(x: 80, y: 0, width: 50, height: 50))
        furnitureButton.addTarget(self, action: "toggleSelected:", forControlEvents: UIControlEvents.TouchUpInside)
        let origFurn = UIImage(named: "Chair-50")
        let tintedFurn = origFurn?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        furnitureButton.setImage(origFurn, forState: .Normal)
        furnitureButton.setImage(tintedFurn, forState: .Selected)
        furnitureCell.addSubview(furnitureButton)
        
        let householdButton = UIButton(frame: CGRect(x: 80, y: 0, width: 50, height: 50))
        householdButton.addTarget(self, action: "toggleSelected:", forControlEvents: UIControlEvents.TouchUpInside)
        let origHouse = UIImage(named: "Lamp-50")
        let tintedHouse = origHouse?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        householdButton.setImage(origHouse, forState: .Normal)
        householdButton.setImage(tintedHouse, forState: .Selected)
        householdCell.addSubview(householdButton)
        
        let kitchenButton = UIButton(frame: CGRect(x: 80, y: 0, width: 50, height: 50))
        kitchenButton.addTarget(self, action: "toggleSelected:", forControlEvents: UIControlEvents.TouchUpInside)
        let origKitchen = UIImage(named: "Kitchen-50")
        let tintedKitchen = origKitchen?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        kitchenButton.setImage(origKitchen, forState: .Normal)
        kitchenButton.setImage(tintedKitchen, forState: .Selected)
        kitchenCell.addSubview(kitchenButton)
        
        let electronicsButton = UIButton(frame: CGRect(x: 80, y: 0, width: 50, height: 50))
        electronicsButton.addTarget(self, action: "toggleSelected:", forControlEvents: UIControlEvents.TouchUpInside)
        let origElec = UIImage(named: "Multiple Devices-50")
        let tintedElec = origElec?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        electronicsButton.setImage(origElec, forState: .Normal)
        electronicsButton.setImage(tintedElec, forState: .Selected)
        electronicsCell.addSubview(electronicsButton)
        
        let booksButton = UIButton(frame: CGRect(x: 80, y: 0, width: 50, height: 50))
        booksButton.addTarget(self, action: "toggleSelected:", forControlEvents: UIControlEvents.TouchUpInside)
        let origBooks = UIImage(named: "Generic Book File Type-50")
        let tintedBooks = origBooks?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        booksButton.setImage(origBooks, forState: .Normal)
        booksButton.setImage(tintedBooks, forState: .Selected)
        booksCell.addSubview(booksButton)
        
        let clothingButton = UIButton(frame: CGRect(x: 80, y: 0, width: 50, height: 50))
        clothingButton.addTarget(self, action: "toggleSelected:", forControlEvents: UIControlEvents.TouchUpInside)
        let origClothes = UIImage(named: "Clothes-50")
        let tintedClothes = origClothes?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        clothingButton.setImage(origClothes, forState: .Normal)
        clothingButton.setImage(tintedClothes, forState: .Selected)
        clothingCell.addSubview(clothingButton)
        
        let otherButton = UIButton(frame: CGRect(x: 80, y: 0, width: 50, height: 50))
        otherButton.addTarget(self, action: "toggleSelected:", forControlEvents: UIControlEvents.TouchUpInside)
        let origOther = UIImage(named: "More-50")
        let tintedOther = origOther?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        otherButton.setImage(origOther, forState: .Normal)
        otherButton.setImage(tintedOther, forState: .Selected)
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