//
//  TextInputETableView.swift
//  MasqueParty
//
//  Created by Isaiah Jenkins on 8/15/16.
//  Copyright © 2016 MasqueParty. All rights reserved.
//


import UIKit
public class TextInputETableView: UITableViewCell {
    
    
    
    
    
    @IBOutlet var myTextEField: UITextField!

    
    
func configure(text:String?,placeholder:String?){
        
    if(text == "test"){
            myTextEField.text = ""
    }else{
            myTextEField.text = text
    }
        
        myTextEField.placeholder = placeholder
        
}
    
    
    
}
