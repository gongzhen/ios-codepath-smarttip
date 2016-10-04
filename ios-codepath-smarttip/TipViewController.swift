//
//  TipViewController.swift
//  ios-codepath-smarttip
//
//  Created by gongzhen on 8/30/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

import UIKit

class TipViewController: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {
    
    // the implicitly unwrapped optional
    let currencyFormatter: NSNumberFormatter!
    
    // First Row [Bill] -- [billTxtField]
    var billLabel: UILabel!
    var billTxtField: UITextField!
    // Second Row [tipLabel] -- [tipAmountLabel]
    var tipLabel: UILabel!
    var tipAmountLabel: UILabel!
    // Third Row: seprate view
    var separateView:UIView!
    
    // Forth Row: Total Label
    var totalLabel: UILabel!
    var totalAmountLabel: UILabel!

    // Five Row: Per Person
    var perPersonLabel: UILabel!
    var costPerPersonLabel: UILabel!
    
    var tipControl: UISegmentedControl!
    
    var numberOfPeopleByTextField: Int?

    // http://blog.scottlogic.com/2014/11/20/swift-initialisation.html
    // https://theswiftdev.com/2015/08/05/swift-init-patterns/
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        self.currencyFormatter = NSNumberFormatter()
        self.currencyFormatter.numberStyle = .CurrencyStyle
        super.init(nibName: nil, bundle: nil)
        let settingsBarButtonItem = UIBarButtonItem(title: NSLocalizedString("SETTING", comment: ""), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(TipViewController.onSettingsButton))
        self.navigationItem.rightBarButtonItem = settingsBarButtonItem
        // set tip percentage.
        let userDefualts = NSUserDefaults.standardUserDefaults()
        
        let tipPercentElements = [18, 20, 25]
        // registerDefaults is safe to check if key is existed.
        userDefualts.registerDefaults(["tipPercentElements" : tipPercentElements])
        userDefualts.synchronize()
        // if userDefualts.valueForKey("tipPercentElements") == nil {
        //  let tipPercentElements = [18, 20, 25]
        //  userDefualts.setObject(tipPercentElements, forKey: "tipPercentElements")
        //  userDefualts.synchronize()
        // }
        
        if userDefualts.valueForKey("numberOfPeoples") == nil {
            // set persons for spliting tip
            let numberOfPeoples = [1, 2, 3, 4, 5]
            userDefualts.setObject(numberOfPeoples, forKey: "numberOfPeoples")
            userDefualts.synchronize()
        }
    }
    
    func onSettingsButton() {
        let settingsViewController = SettingsViewController()
        settingsViewController.backClosure = { (number: Int?) -> Void in
            self.numberOfPeopleByTextField = number
            debugPrint("numberOfPeopleByTextField: \(self.numberOfPeopleByTextField)")
        }
        self.navigationController?.pushViewController(settingsViewController, animated: false)
        self.view.endEditing(true)
    }
    
    // per Apple’s documentation, the recommended place to setup the view hierarchy is loadView.
    override func loadView() {
        self.view = UIView()
        
        var labelAttributes: [String: Any] = ["translatesAutoresizingMaskIntoConstraints": false, "text": NSLocalizedString("BILL", comment: ""), "backgroundColor": UIColor.clearColor(), "font": UIFont.systemFontOfSize(15.0), "textAlignment": NSTextAlignment.Left, "adjustsFontSizeToFitWidth": true]
        self.billLabel = UIHelper.createLabel(labelAttributes: labelAttributes)
        self.view.addSubview(self.billLabel)

        labelAttributes = ["translatesAutoresizingMaskIntoConstraints": false, "placeholder": currencyFormatter.currencySymbol, "backgroundColor": UIColor.clearColor(), "font": UIFont.systemFontOfSize(15.0), "textAlignment": NSTextAlignment.Right, "adjustsFontSizeToFitWidth": true, "keyboardType": UIKeyboardType.DecimalPad, "cornerRadius": 1.0, "borderWidth": 0.0, "borderColor": UIColor.clearColor().CGColor]
        self.billTxtField = UIHelper.createTextField(textFieldAttributes: labelAttributes)
        self.billTxtField.delegate = self
        self.billTxtField.addTarget(self, action: #selector(TipViewController.textFieldDidChange), forControlEvents: UIControlEvents.EditingChanged)
        self.view.addSubview(self.billTxtField)
        
        labelAttributes = ["translatesAutoresizingMaskIntoConstraints": false, "text": NSLocalizedString("TIP", comment: ""), "backgroundColor": UIColor.clearColor(), "font": UIFont.systemFontOfSize(15.0), "textAlignment": NSTextAlignment.Left, "adjustsFontSizeToFitWidth": true]
        self.tipLabel = UIHelper.createLabel(labelAttributes: labelAttributes)
        self.view.addSubview(self.tipLabel)
                
        labelAttributes = ["translatesAutoresizingMaskIntoConstraints": false, "text": "0.00", "backgroundColor": UIColor.clearColor(), "font": UIFont.systemFontOfSize(15.0), "textAlignment": NSTextAlignment.Right, "adjustsFontSizeToFitWidth": true]
        self.tipAmountLabel = UIHelper.createLabel(labelAttributes: labelAttributes)
        self.view.addSubview(self.tipAmountLabel)
        
        self.separateView = UIView()
        self.separateView.backgroundColor = UIColor.clearColor()
        self.separateView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.separateView)
        
        labelAttributes = ["translatesAutoresizingMaskIntoConstraints": false, "text":NSLocalizedString("TOTAL", comment: ""), "backgroundColor": UIColor.clearColor(), "font": UIFont.systemFontOfSize(16.0), "textAlignment": NSTextAlignment.Left, "adjustsFontSizeToFitWidth": true]
        self.totalLabel = UIHelper.createLabel(labelAttributes: labelAttributes)
        self.view.addSubview(self.totalLabel)
        
        labelAttributes = ["translatesAutoresizingMaskIntoConstraints": false, "text": "0.00", "backgroundColor": UIColor.clearColor(), "font": UIFont.systemFontOfSize(16.0), "textAlignment": NSTextAlignment.Right, "adjustsFontSizeToFitWidth": true]
        self.totalAmountLabel = UIHelper.createLabel(labelAttributes: labelAttributes)
        self.view.addSubview(self.totalAmountLabel)
        
        labelAttributes = ["translatesAutoresizingMaskIntoConstraints": false, "text": NSLocalizedString("PER PERSON (SPLIT BY 1)", comment: ""), "backgroundColor": UIColor.clearColor(), "font": UIFont.systemFontOfSize(14.0), "textAlignment": NSTextAlignment.Left, "adjustsFontSizeToFitWidth": true]
        self.perPersonLabel = UIHelper.createLabel(labelAttributes: labelAttributes)
        self.view.addSubview(self.perPersonLabel)
        
        self.costPerPersonLabel = UILabel()
        labelAttributes = ["translatesAutoresizingMaskIntoConstraints": false, "text": "0.00", "backgroundColor": UIColor.clearColor(), "font": UIFont.systemFontOfSize(14.0), "textAlignment": NSTextAlignment.Right, "adjustsFontSizeToFitWidth": true]
        self.costPerPersonLabel = UIHelper.createLabel(labelAttributes: labelAttributes)
        self.view.addSubview(self.costPerPersonLabel)
        
        let userDefualts = NSUserDefaults.standardUserDefaults()
        let itemsInt = userDefualts.valueForKey("tipPercentElements") as! [Int]
        let items:[String] = itemsInt.map { (item: Int) -> String in
            return "\(item)%"
        }
        
        self.tipControl = UISegmentedControl(items: items)
        self.tipControl.translatesAutoresizingMaskIntoConstraints = false
        self.tipControl.selectedSegmentIndex = 0
        self.tipControl.addTarget(self, action: #selector(TipViewController.calcTip), forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(self.tipControl)
        
        // user defaults reload
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackgroundImage()
        configureBillLabelAndBillTxtFieldPositions()
        configureTipLabelAndTipAmountLabelPositions()
        configureSeparateViewPosition()
        configureTotalLabelAndTotalAmountLabelPosition()
        configurePerPersonLabelPosition()
        configureTipControlPositions()
    }
    
    // http://stackoverflow.com/questions/28858908/add-uitapgesturerecognizer-to-uitextview-without-blocking-textview-touches   
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func textFieldDidChange() {
        if (self.billTxtField.placeholder == "") {
            self.billTxtField.placeholder = self.currencyFormatter.currencySymbol
            self.calcTip()
        } else {
            self.calcTip()
        }
    }
    
    //todo
    func hideCalculation() {
        
    }
    
    func totalAmount() {
        print("total Amount")
    }
    
    func configureBillLabelAndBillTxtFieldPositions() {
        let views = ["billLabel": self.billLabel, "billTxtField": self.billTxtField]
        let metrics:[String: CGFloat] = ["billTxtFieldHeight": 30.0, "billLabelHeight":21.0, "billTxtFieldWidth": 200.0, "billLabelWidth":50.0, "leftMargin": 10.0, "rightMargin": 10.0, "interitemSpace": 50.0]
        
        // billLabel height
        NSLayoutConstraint(item: self.billLabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: metrics["billLabelHeight"]!).active = true
        
        // billTxtField top distance.
        NSLayoutConstraint(item: self.billTxtField, attribute: .Top, relatedBy: .Equal, toItem: topLayoutGuide, attribute: .Bottom, multiplier: 1, constant: 8).active = true
        // billTxtField Height
        NSLayoutConstraint(item: self.billTxtField, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: metrics["billTxtFieldHeight"]!).active = true
        
        // billTxtField honrizontal positions.
        let billTxtFieldHorizontal = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(leftMargin)-[billLabel(billLabelWidth)]-(interitemSpace)-[billTxtField(>=billTxtFieldWidth)]-(rightMargin)-|",
            options: .AlignAllCenterY, metrics: metrics, views: views)
        self.view.addConstraints(billTxtFieldHorizontal)
    }
    
    func configureTipLabelAndTipAmountLabelPositions() {
        let views = ["tipLabel": self.tipLabel, "tipAmountLabel": self.tipAmountLabel]
        let metrics:[String: CGFloat] = ["labelHeight": 21.0, "tipLabelWidth": 25.0, "tipAmountLabelWidth":200.0, "interitemSpace": 50.0, "topSpace": 20.0]

        // tipLabel leading alignment
        NSLayoutConstraint(item: self.tipLabel, attribute: .Leading, relatedBy: .Equal, toItem: self.billLabel, attribute: .Leading, multiplier: 1.0, constant: 0).active = true
        
        // tipAmountLabel Height
        NSLayoutConstraint(item: self.tipAmountLabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: metrics["labelHeight"]!).active = true
        
        // tipAmountLabel Trailing
        NSLayoutConstraint(item: self.tipAmountLabel, attribute: .Trailing, relatedBy: .Equal, toItem: self.billTxtField, attribute: .Trailing, multiplier: 1.0, constant: 0.0).active = true
        
        // tipAmountLabel top distance.
        NSLayoutConstraint(item: self.tipAmountLabel, attribute: .Top, relatedBy: .Equal, toItem: self.billTxtField, attribute: .Bottom, multiplier: 1, constant: metrics["topSpace"]!).active = true
        
        // tipAmountLabel honrizontal positions.
        let tipAmountLabelHorizontal = NSLayoutConstraint.constraintsWithVisualFormat("H:[tipLabel(tipLabelWidth)]-(interitemSpace)-[tipAmountLabel(>=tipAmountLabelWidth)]",
            options: .AlignAllCenterY, metrics: metrics, views: views)
        self.view.addConstraints(tipAmountLabelHorizontal)
    }
    
    func configureSeparateViewPosition() {
        let views = ["tipLabel": self.tipLabel, "tipAmountLabel": self.tipAmountLabel, "separateView" : self.separateView]
        
        let metrics:[String: CGFloat] = ["viewHeight": 6.0, "topSpace": 40.0]
        
        // view height
        let viewHeight = NSLayoutConstraint.constraintsWithVisualFormat("V:[separateView(viewHeight)]",
            options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views)
        self.view.addConstraints(viewHeight)
        
        // view top space and trailing
        let viewTopAndTrailing = NSLayoutConstraint.constraintsWithVisualFormat("V:[tipAmountLabel]-(topSpace)-[separateView]", options: .AlignAllTrailing, metrics: metrics, views: views)
        self.view.addConstraints(viewTopAndTrailing)
        
        // view leading
        let viewLeading = NSLayoutConstraint.constraintsWithVisualFormat("V:[tipLabel]-(topSpace)-[separateView]", options: .AlignAllLeading, metrics: metrics, views: views)
        self.view.addConstraints(viewLeading)
    }

    func configureTotalLabelAndTotalAmountLabelPosition(){
        let views = ["totalLabel": self.totalLabel, "totalAmountLabel": self.totalAmountLabel, "separateView" : self.separateView]
        let metrics:[String: CGFloat] = ["labelHeight": 30.0, "totalLabelWidth": 50.0, "totalAmountLabelWidth": 200.0, "interitemSpace": 16.0, "topSpace": 10.0]
        
        // totalAmountLabel height
        NSLayoutConstraint(item: self.totalAmountLabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: metrics["labelHeight"]!).active = true
        
        // totalLabel height
        NSLayoutConstraint(item: self.totalLabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: metrics["labelHeight"]!).active = true
        
        // totalAmountLabel top space and trailing
        let totalAmountLabelTopAndTrailing = NSLayoutConstraint.constraintsWithVisualFormat("V:[separateView]-(topSpace)-[totalAmountLabel]", options: .AlignAllTrailing, metrics: metrics, views: views)
        self.view.addConstraints(totalAmountLabelTopAndTrailing)
        
        // totalLabel leading
        let totalLabelLeading = NSLayoutConstraint.constraintsWithVisualFormat("V:[separateView]-(topSpace)-[totalLabel]", options: .AlignAllLeading, metrics: metrics, views: views)
        self.view.addConstraints(totalLabelLeading)
        
        // totalLabel and totalAmountLabel horizontal space
        let horizontalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:[totalLabel(totalLabelWidth)]-(interitemSpace)-[totalAmountLabel(>=totalAmountLabelWidth)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views)
        self.view.addConstraints(horizontalConstraint)
    }
    
    func configurePerPersonLabelPosition(){
        let views = ["totalLabel": self.totalLabel, "totalAmountLabel": self.totalAmountLabel, "perPersonLabel" : self.perPersonLabel, "costPerPersonLabel": self.costPerPersonLabel]
        let metrics:[String: CGFloat] = ["labelHeight": 21.0, "perPersonLabelWidth": 150.0, "costPerPersonLabelWidth": 300.0, "interitemSpace": 16.0, "topSpace": 10.0]
        
        // perPersonLabel height
        NSLayoutConstraint(item: self.perPersonLabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: metrics["labelHeight"]!).active = true
        
        // costPerPersonLabel height
        NSLayoutConstraint(item: self.costPerPersonLabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: metrics["labelHeight"]!).active = true
        
        // costPerPersonLabel top space and trailing
        let costPerPersonLabelTopAndTrailing = NSLayoutConstraint.constraintsWithVisualFormat("V:[totalAmountLabel]-(topSpace)-[costPerPersonLabel]", options: .AlignAllTrailing, metrics: metrics, views: views)
        self.view.addConstraints(costPerPersonLabelTopAndTrailing)
        
        // perPersonLabel leading
        let perPersonLabelLeading = NSLayoutConstraint.constraintsWithVisualFormat("V:[totalLabel]-(topSpace)-[perPersonLabel]", options: .AlignAllLeading, metrics: metrics, views: views)
        self.view.addConstraints(perPersonLabelLeading)
        
        // totalLabel and totalAmountLabel horizontal space
        let horizontalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:[perPersonLabel(>=perPersonLabelWidth)]-(interitemSpace)-[costPerPersonLabel(<=costPerPersonLabelWidth)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views)
        self.view.addConstraints(horizontalConstraint)
    }
    
    func configureTipControlPositions() {
        let views = ["tipControl": self.tipControl, "perPersonLabel" : self.perPersonLabel, "costPerPersonLabel": self.costPerPersonLabel]
        let metrics:[String: CGFloat] = ["controlHeight": 30.0, "topSpace": 20.0]
        
        // control height
        NSLayoutConstraint(item: self.tipControl, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: metrics["controlHeight"]!).active = true
        
        // view top space and trailing
        let tipControlTopAndTrailing = NSLayoutConstraint.constraintsWithVisualFormat("V:[costPerPersonLabel]-(topSpace)-[tipControl]", options: .AlignAllTrailing, metrics: metrics, views: views)
        self.view.addConstraints(tipControlTopAndTrailing)
        
        // view leading
        let tipControlLeading = NSLayoutConstraint.constraintsWithVisualFormat("V:[perPersonLabel]-(topSpace)-[tipControl]", options: .AlignAllLeading, metrics: metrics, views: views)
        self.view.addConstraints(tipControlLeading)
    }
    
    func calcTip() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let tipPercentageInt = userDefaults.valueForKey("tipPercentElements") as! [Int]
        let tipPercentage:[Double] = tipPercentageInt.map { Double($0)/100.0}
        let billAmount = Double(self.billTxtField.text!) ?? 0
        let tipAmount = billAmount * tipPercentage[self.tipControl.selectedSegmentIndex]
        let totalAmount = billAmount + tipAmount
        
        self.tipAmountLabel.text = String(currencyFormatter.stringFromNumber(tipAmount)!)
        self.totalAmountLabel.text = String(currencyFormatter.stringFromNumber(totalAmount)!)
        if let numberOfPeople = userDefaults.objectForKey("numberOfPeople") as? Int {
            var tipPerPerson: Double
            if let numberOfPeopleByTextField = self.numberOfPeopleByTextField {
                tipPerPerson = totalAmount / Double(numberOfPeopleByTextField)
            } else {
                tipPerPerson = totalAmount / Double(numberOfPeople)
            }
            

            self.costPerPersonLabel.text = String(currencyFormatter.stringFromNumber(tipPerPerson)!)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let selectedSegmentIndex = userDefaults.valueForKey("selectedSegmentIndex")
        if let selectedSegmentIndex = selectedSegmentIndex as? Int {
            self.tipControl.selectedSegmentIndex = selectedSegmentIndex
        } else {
            self.tipControl.selectedSegmentIndex = 0
        }
        
        if let tipPercentElements = userDefaults.objectForKey("tipPercentElements") as? [Int] {
            let items:[String] = tipPercentElements.map {"\($0)%"}
            for (index, item) in items.enumerate() {
                self.tipControl.setTitle(item, forSegmentAtIndex: index)
            }
        }

        
        if let numberOfPeopleByTextField = self.numberOfPeopleByTextField {
            self.perPersonLabel.text = String(format: NSLocalizedString("PER PERSON (SPLIT BY %d)", comment: ""), numberOfPeopleByTextField)
        } else if let numberOfPeople = userDefaults.objectForKey("numberOfPeople") as? Int {
            self.perPersonLabel.text = String(format: NSLocalizedString("PER PERSON (SPLIT BY %d)", comment: ""), numberOfPeople)
        }
        calcTip()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
