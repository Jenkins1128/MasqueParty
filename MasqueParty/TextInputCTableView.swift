//
//  TextInputCTableView.swift
//  MasqueParty
//
//  Created by Isaiah Jenkins on 8/15/16.
//  Copyright © 2016 MasqueParty. All rights reserved.
//


import UIKit
public class TextInputCTableView: UITableViewCell {
    
    
    
   
    
    @IBOutlet var myTextCField: UITextField!
    
func configure(text:String?,placeholder:String?){
        if(text == "test"){
            myTextCField.text = ""
        }else{
            myTextCField.text = text
        }
        
        myTextCField.placeholder = placeholder
        
    }
    
    
    
}
