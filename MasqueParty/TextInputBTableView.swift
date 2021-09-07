//
//  TextInputBTableView.swift
//  MasqueParty
//
//  Created by Isaiah Jenkins on 8/15/16.
//  Copyright © 2016 MasqueParty. All rights reserved.
//


import UIKit
public class TextInputBTableView: UITableViewCell {
    
    
    
    @IBOutlet var myTextBField: UITextField!

    
    public func configure(text:String?,placeholder:String?){
        
        if(text == "test"){
            myTextBField.text = ""
        }else{
            myTextBField.text = text
        }
        
        myTextBField.placeholder = placeholder
        
    }
    
    
    
}
