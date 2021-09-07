//
//  TextInputDTableView.swift
//  MasqueParty
//
//  Created by Isaiah Jenkins on 8/15/16.
//  Copyright © 2016 MasqueParty. All rights reserved.
//
import UIKit
public class TextInputDTableView: UITableViewCell {
    
    
    
    
    
  
    @IBOutlet var myTextDField: UITextField!
  
    
    func configure(text:String?,placeholder:String?){
        
        if(text == "test"){
            myTextDField.text = ""
        }else{
            myTextDField.text = text
        }
        
        myTextDField.placeholder = placeholder
        
    }
    
    
    
}
