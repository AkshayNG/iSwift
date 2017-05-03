//
//  ANGModalViewController.swift
//  iSwift
//
//  Created by Akshay Gajarlawar on 01/05/17.
//  Copyright © 2017 yantrana. All rights reserved.
//

import UIKit



class ANGModalViewController: UIViewController
{
    
    var animate = true
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func switchChanged(_ sender: UISwitch)
    {
        animate = sender.isOn
    }
    
    
    @IBAction func showModal(_ sender: UIButton)
    {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
