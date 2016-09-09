//
//  Helper+ViewController.swift
//  ios-codepath-smarttip
//
//  Created by gongzhen on 9/2/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

import UIKit

class UIHelper {

    class func createLabel(labelAttributes attrbutes: [String: Any]) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = (attrbutes["translatesAutoresizingMaskIntoConstraints"] as! Bool)
        label.text = (attrbutes["text"] as! String)
        label.backgroundColor = (attrbutes["backgroundColor"] as! UIColor)
        label.font = (attrbutes["font"] as! UIFont)
        label.textAlignment = (attrbutes["textAlignment"] as! NSTextAlignment)
        label.adjustsFontSizeToFitWidth = (attrbutes["adjustsFontSizeToFitWidth"] as! Bool)
        
        return label
    }
    
    class func createTextField(textFieldAttributes attrbutes: [String: Any]) -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = (attrbutes["translatesAutoresizingMaskIntoConstraints"] as! Bool)
        textField.placeholder = (attrbutes["placeholder"] as! String)
        textField.font = (attrbutes["font"] as! UIFont)
        textField.textAlignment = (attrbutes["textAlignment"] as! NSTextAlignment)
        textField.adjustsFontSizeToFitWidth = (attrbutes["adjustsFontSizeToFitWidth"] as! Bool)
        textField.keyboardType = (attrbutes["keyboardType"] as! UIKeyboardType)
        textField.backgroundColor = (attrbutes["backgroundColor"] as! UIColor)
        return textField
    }
    

}
