//
//  SettingsViewController.swift
//  ios-codepath-smarttip
//
//  Created by gongzhen on 9/2/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    var percentageSettingLabel: UILabel!
    var percentageSettingView: UIView!
    var plusButton:UIButton!
    var minusButton:UIButton!
    var defaultNumOfPeopleLabel: UILabel!
    var percentageSettingControl: UISegmentedControl!    
    var defaultNumOfPeopleControl: UISegmentedControl!
    
    override func loadView() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        self.view = UIView()

        var labelAttributes: [String: Any] = ["translatesAutoresizingMaskIntoConstraints": false, "text": "Default Tip Percentage", "backgroundColor": UIColor.clearColor(), "font": UIFont.systemFontOfSize(15.0), "textAlignment": NSTextAlignment.Left, "adjustsFontSizeToFitWidth": true]
        self.percentageSettingLabel = UIHelper.createLabel(labelAttributes: labelAttributes)
        self.view.addSubview(self.percentageSettingLabel)
        
        // percentageSettingControlView
        
        self.plusButton = UIButton()
        self.plusButton.setTitle("+", forState: UIControlState.Normal)
        self.plusButton.backgroundColor = UIColor.clearColor()
        self.plusButton.translatesAutoresizingMaskIntoConstraints = false
        self.plusButton.addTarget(self, action: #selector(SettingsViewController.plusButtonAction(_:)), forControlEvents: .TouchUpInside)
        
        let tipPercentElements = userDefaults.objectForKey("tipPercentElements") as! [Int]
        let items:[String] = tipPercentElements.map {"\($0)%"}
        self.percentageSettingControl = UISegmentedControl(items: items)
        self.percentageSettingControl.translatesAutoresizingMaskIntoConstraints = false
        if let selectedSegmentIndex = userDefaults.valueForKey("selectedSegmentIndex") as? Int {
            self.percentageSettingControl.selectedSegmentIndex = selectedSegmentIndex
        } else {
            self.percentageSettingControl.selectedSegmentIndex = 0
        }
        self.percentageSettingControl.addTarget(self, action: #selector(SettingsViewController.defaultPercentChange(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.minusButton = UIButton()
        self.minusButton.backgroundColor = UIColor.clearColor()
        self.minusButton.setTitle("-", forState: UIControlState.Normal)
        self.minusButton.backgroundColor = UIColor.clearColor()
        self.minusButton.translatesAutoresizingMaskIntoConstraints = false
        self.minusButton.addTarget(self, action: #selector(SettingsViewController.minusButtonAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.percentageSettingView = UIView()
        self.percentageSettingView.backgroundColor = UIColor.clearColor()
        self.percentageSettingView.translatesAutoresizingMaskIntoConstraints = false
        self.percentageSettingView.addSubview(self.plusButton)
        self.percentageSettingView.addSubview(self.percentageSettingControl)
        self.percentageSettingView.addSubview(self.minusButton)
        self.view.addSubview(self.percentageSettingView)
        
        // percentageSettingControl end
        labelAttributes = ["translatesAutoresizingMaskIntoConstraints": false, "text": "Default Tip Percentage", "backgroundColor": UIColor.clearColor(), "font": UIFont.systemFontOfSize(15.0), "textAlignment": NSTextAlignment.Left, "adjustsFontSizeToFitWidth": true]
        self.defaultNumOfPeopleLabel = UIHelper.createLabel(labelAttributes: labelAttributes)
        self.view.addSubview(self.defaultNumOfPeopleLabel)
        
        let numberOfPeoplesInt = userDefaults.objectForKey("numberOfPeoples") as! [Int]
        let numberOfPeoples: [String] = numberOfPeoplesInt.map {"\($0)"}
        self.defaultNumOfPeopleControl = UISegmentedControl(items: numberOfPeoples)
        self.defaultNumOfPeopleControl.translatesAutoresizingMaskIntoConstraints = false
        
        if let numberOfPeopleIndex = userDefaults.valueForKey("numberOfPeopleIndex") as? Int {
            self.defaultNumOfPeopleControl.selectedSegmentIndex = numberOfPeopleIndex
        } else {
            self.defaultNumOfPeopleControl.selectedSegmentIndex = 0
        }
        
        self.defaultNumOfPeopleControl.addTarget(self, action: #selector(SettingsViewController.defaultNumOfPeopleChange(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(self.defaultNumOfPeopleControl)
    }
    
    func defaultPercentChange(sender: UISegmentedControl) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(self.percentageSettingControl.selectedSegmentIndex, forKey: "selectedSegmentIndex")
        defaults.synchronize()
    }
    
    func defaultNumOfPeopleChange(sender: UISegmentedControl) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let numOfPeopleString = sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)
        if let numOfPeopleString = numOfPeopleString, numOfPeopleInt = Int(numOfPeopleString) {
            defaults.setInteger(numOfPeopleInt, forKey: "numberOfPeople")
            defaults.setInteger(sender.selectedSegmentIndex, forKey: "numberOfPeopleIndex")
            defaults.synchronize()
        } else {
            defaults.setInteger(1, forKey: "numberOfPeopleIndex")
            defaults.synchronize()
        }
        
    }
    
    func plusButtonAction(sender: UIButton) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let selectedSegmentIndex: Int = userDefaults.integerForKey("selectedSegmentIndex")
        let defaultPercentTitle: String? = self.percentageSettingControl.titleForSegmentAtIndex(selectedSegmentIndex)
        if let defaultPercentTitle = defaultPercentTitle {
            let newPercentValue: Int = Int(defaultPercentTitle.substringToIndex(defaultPercentTitle.endIndex.predecessor()))!
            if newPercentValue < 100 {
                self.percentageSettingControl.setTitle(String(newPercentValue + 1) + "%", forSegmentAtIndex: selectedSegmentIndex)
            }
        }
    }
    
    func minusButtonAction(sender:UIButton) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let selectedSegmentIndex: Int = userDefaults.integerForKey("selectedSegmentIndex")
        let defaultPercentTitle: String? = self.percentageSettingControl.titleForSegmentAtIndex(selectedSegmentIndex)
        if let defaultPercentTitle = defaultPercentTitle {
            let newPercentValue: Int = Int(defaultPercentTitle.substringToIndex(defaultPercentTitle.endIndex.predecessor()))!
            if newPercentValue < 100 {
                self.percentageSettingControl.setTitle(String(newPercentValue - 1) + "%", forSegmentAtIndex: selectedSegmentIndex)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SettingsViewController.deviceDidRotate), name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    func deviceDidRotate() {
        // https://happyteamlabs.com/blog/ios-using-uideviceorientation-to-determine-orientation/
        print(UIDevice.currentDevice().orientation)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackgroundImage()
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let selectedSegmentIndex = userDefaults.integerForKey("selectedSegmentIndex")
        let numberOfPeopleIndex = userDefaults.integerForKey("numberOfPeopleIndex")
        self.percentageSettingControl.selectedSegmentIndex = selectedSegmentIndex
        self.defaultNumOfPeopleControl.selectedSegmentIndex = numberOfPeopleIndex
        
        configurePercentageSettingLabelPositions()
        configurePercentageSettingViewPositions()
        configureDefaultNumOfPeopleLabelPosition()
        configureDefaultNumOfPeopleControlPosition()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        let userDefualts = NSUserDefaults.standardUserDefaults()
        var itemsInt = [Int]()
        for index in 0...2 {
            if let title = self.percentageSettingControl.titleForSegmentAtIndex(index) {
                if let endIndex = title.characters.indexOf("%") {
                    let subString = title.substringToIndex(endIndex)
                    if let itemInt = Int(subString){
                        itemsInt.append(itemInt)
                    }
                }
            }
        }
        if itemsInt.count > 0 {
            userDefualts.setObject(itemsInt, forKey: "tipPercentElements")
            userDefualts.synchronize()
        }
    }

    func configurePercentageSettingLabelPositions() {
        let views = ["percentageSettingLabel": self.percentageSettingLabel]
        let metrics:[String: CGFloat] = ["percentageSettingLabelHeight": 30.0, "leftMargin": 10.0, "rightMargin": 10.0, "interitemSpace": 50.0]
        
        // percentageSettingLabel height
        NSLayoutConstraint(item: self.percentageSettingLabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: metrics["percentageSettingLabelHeight"]!).active = true
        
        // percentageSettingLabel top distance.
        NSLayoutConstraint(item: self.percentageSettingLabel, attribute: .Top, relatedBy: .Equal, toItem: topLayoutGuide, attribute: .Bottom, multiplier: 1, constant: 8).active = true
        
        // percentageSettingLabel honrizontal positions.
        let labelHorizontal = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(leftMargin)-[percentageSettingLabel]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views)
        self.view.addConstraints(labelHorizontal)
    }
    
    func configurePercentageSettingViewPositions() {
        let views = ["percentageSettingView": self.percentageSettingView, "percentageSettingLabel": self.percentageSettingLabel, "percentageSettingControl": self.percentageSettingControl, "plusButton": self.plusButton, "minusButton": self.minusButton]
        let metrics:[String: CGFloat] = ["viewHeight": 100.0, "controlHeight": 21.0, "topSpace": 10.0, "rightMargin": 10.0]
        
        // view height
        NSLayoutConstraint(item: self.percentageSettingView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: metrics["viewHeight"]!).active = true
        
        // view top space and leading
        let percentageSettingViewVerticalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("V:[percentageSettingLabel]-(topSpace)-[percentageSettingView]", options: [.AlignAllLeading], metrics: metrics, views: views)
        self.view.addConstraints(percentageSettingViewVerticalConstraint)
        
        // view horizontal constraint
        let percentageSettingViewHorizontalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:[percentageSettingView]-(rightMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views)
        self.view.addConstraints(percentageSettingViewHorizontalConstraint)
        
//        // Inside the view, set constraint for control, plusButton and minusButton
        NSLayoutConstraint(item: self.percentageSettingControl, attribute: .CenterY, relatedBy: .Equal, toItem: self.percentageSettingView, attribute: .CenterY, multiplier: 1.0, constant: 0).active = true

        NSLayoutConstraint(item: self.percentageSettingControl, attribute: .CenterX, relatedBy: .Equal, toItem: self.percentageSettingView, attribute: .CenterX, multiplier: 1.0, constant: 0).active = true

        NSLayoutConstraint(item: self.percentageSettingControl, attribute: .Leading, relatedBy: .Equal, toItem: self.percentageSettingView, attribute: .Leading, multiplier: 1.0, constant: 8.0).active = true

        NSLayoutConstraint(item: self.percentageSettingView, attribute: .Trailing, relatedBy: .Equal, toItem: self.percentageSettingControl, attribute: .Trailing, multiplier: 1.0, constant: 8.0).active = true
        
        let leftSpace: CGFloat = UIScreen.mainScreen().bounds.width / 6.0
        
        NSLayoutConstraint(item: self.plusButton, attribute: .Top, relatedBy: .Equal, toItem: self.percentageSettingView, attribute: .Top, multiplier: 1.0, constant: 0).active = true
        NSLayoutConstraint(item: self.percentageSettingView, attribute: .Trailing, relatedBy: .Equal, toItem: self.plusButton, attribute: .Trailing, multiplier: 1.0, constant: leftSpace).active = true
        NSLayoutConstraint(item: self.minusButton, attribute: .Bottom, relatedBy: .Equal, toItem: self.percentageSettingView, attribute: .Bottom, multiplier: 1.0, constant: 0).active = true
        NSLayoutConstraint(item: self.percentageSettingView, attribute: .Trailing, relatedBy: .Equal, toItem: self.minusButton, attribute: .Trailing, multiplier: 1.0, constant: leftSpace).active = true
    }
    
    func configureDefaultNumOfPeopleLabelPosition() {
        let views = ["defaultNumOfPeopleLabel": self.defaultNumOfPeopleLabel, "percentageSettingView": self.percentageSettingView]
        
        let metrics:[String: CGFloat] = ["labelHeight": 30.0, "topSpace": 10.0]
        
        // defaultNumOfPeopleLabel top distance.
        NSLayoutConstraint(item: self.percentageSettingLabel, attribute: .Top, relatedBy: .Equal, toItem: topLayoutGuide, attribute: .Bottom, multiplier: 1, constant: 8).active = true
        
        // defaultNumOfPeopleLabel honrizontal positions.
        let labelVertical = NSLayoutConstraint.constraintsWithVisualFormat("V:[percentageSettingView]-(topSpace)-[defaultNumOfPeopleLabel(labelHeight)]", options: .AlignAllLeading, metrics: metrics, views: views)
        self.view.addConstraints(labelVertical)
    }
    
    func configureDefaultNumOfPeopleControlPosition() {
        let views = ["defaultNumOfPeopleControl": self.defaultNumOfPeopleControl, "defaultNumOfPeopleLabel" : self.defaultNumOfPeopleLabel, "percentageSettingControl": self.percentageSettingControl]
        let metrics:[String: CGFloat] = ["controlHeight": 21.0, "topSpace": 20.0]
        
        // control height
        NSLayoutConstraint(item: self.defaultNumOfPeopleControl, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: metrics["controlHeight"]!).active = true
        
        // control top space and trailing
        let controlTop = NSLayoutConstraint.constraintsWithVisualFormat("V:[defaultNumOfPeopleLabel]-(topSpace)-[defaultNumOfPeopleControl]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views)
        self.view.addConstraints(controlTop)
        
        NSLayoutConstraint(item: self.defaultNumOfPeopleControl, attribute: .Leading, relatedBy: .Equal, toItem: self.percentageSettingControl, attribute: .Leading, multiplier: 1.0, constant: 0.0).active = true
        NSLayoutConstraint(item: self.defaultNumOfPeopleControl, attribute: .Trailing, relatedBy: .Equal, toItem: self.percentageSettingControl, attribute: .Trailing, multiplier: 1.0, constant: 0.0).active = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
