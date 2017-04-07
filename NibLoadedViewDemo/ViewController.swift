//
//  ViewController.swift
//  NibLoadedViewDemo
//
//  Created by lieyunye on 2017/4/6.
//  Copyright © 2017年 lieyunye. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var colorView1: ColorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        colorView1.color = UIColor(red:0.3, green:0.5, blue:0.7,alpha:1.0)
        
        let colorView2:ColorView = ColorView(frame:CGRect(x:20,y:120,width:self.view.bounds.size.width - 40,height:280))
        colorView2.backgroundColor = UIColor.darkGray
        colorView2.color = UIColor(red:0.7, green:0.3, blue:0.5,alpha:1.0)
        self.view.addSubview(colorView2)
        
        let colorView3 = ColorView()
        colorView3.frame = colorView1.frame.offsetBy(dx: 0, dy: colorView2.frame.maxY)
        colorView3.backgroundColor = UIColor.white
        colorView3.color = UIColor(red:0.5, green:0.7, blue:0.3,alpha:1.0)
        self.view.addSubview(colorView3)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

