//
//  ViewController.swift
//  JANCodeScannerExample
//
//  Created by Saeed Rahmatolahi on 9/12/2563 BE.
//

import UIKit
import JANCodeScanner

class ViewController: UIViewController , scannerViewProtocol {

    @IBOutlet weak var scanner: ScannerView!
    
    func scanResult(_ text : String) {
        print(text)
    }
    
    func scanFailed() {
        print("failed")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scannerViewDelegate = self
    }


}

