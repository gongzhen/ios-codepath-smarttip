//
//  WallpaperWindow.swift
//  ios-codepath-smarttip
//
//  Created by gongzhen on 9/8/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

import UIKit

class WallpaperWindow: UIWindow {
    var wallpaper: UIImage? = UIImage(named: "Settings_vc_bk") {
        didSet {
            // refresh if the image changed
            setNeedsDisplay()
        }
    }
    
    init() {
        super.init(frame: UIScreen.mainScreen().bounds)
        //clear the background color of all table views, so we can see the background
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        // draw the wallper if set, otherwise default behaviour
        if let wallpaper = wallpaper {
            wallpaper.drawInRect(self.bounds);
        } else {
            super.drawRect(rect)
        }
    }
}
