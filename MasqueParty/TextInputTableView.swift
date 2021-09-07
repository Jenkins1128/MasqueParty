//
//  TextInputTableView.swift
//  MasqueParty
//
//  Created by Isaiah Jenkins on 8/7/16.
//  Copyright © 2016 MasqueParty. All rights reserved.
//

import UIKit
public class TextInputTableView: UITableViewCell {
    
    
   
    @IBOutlet var myTextField: UITextField!

    public func configure(text:String?,placeholder:String?){
        if(text == "test"){
            myTextField.text = ""
        }else{
            myTextField.text = text
        }
        
        myTextField.placeholder = placeholder
        
    }
    
    

}
