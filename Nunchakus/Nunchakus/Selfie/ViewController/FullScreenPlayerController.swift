//
//  FullScreenPlayerController.swift
//  Nunchakus
//
//  Created by sungrow on 2017/4/14.
//  Copyright © 2017年 sungrow. All rights reserved.
//

import UIKit

class FullScreenPlayerController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        emptyDataView.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.landscapeRight, .landscapeLeft]
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
