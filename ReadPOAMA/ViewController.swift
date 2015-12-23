//
//  ViewController.swift
//  ReadPOAMA
//
//  Created by Neil White on 22/12/2015.
//  Copyright © 2015 Neil White. All rights reserved.
//

import UIKit
// UIViewController is the superclass with all the gubbins to UI Views
class ViewController: UIViewController {
// all the instance variables and methods between the {}
//instance variable also called a property

//@IBOutlet is an xcode thing to allow the little grey circle in the gutter
    //weak is nearly always used, for reference counting
    // var is mutable
    // UILabel is the type
    @IBOutlet weak var urldisplay: UILabel!
    
    @IBOutlet weak var fYear: UITextField!
    @IBOutlet weak var fMth: UITextField!
    @IBOutlet weak var fDay: UITextField!
    

    @IBOutlet weak var siteName: UITextField!
    
    
    @IBOutlet weak var urlEditDisplay: UITextField!
    
    @IBOutlet weak var resultsDisplay: UILabel!
    // a return would need -> return type
    @IBAction func generateURL(sender: UIButton) {
        //local constant starts with let
        // generally don't have to use upper case etc to denote constants
        var url = "http://opendap.bom.gov.au:8080/thredds/dodsC/poama/realtime/daily/m24a/emn/dagc_"
        let site = siteName.text!
        
        var startLong: Int
        var startLat: Int

        
        switch site {
        case "Twba":
            startLong = 61
            startLat = 46
        case "Athorpe":
            startLong = 61
            startLat = 47
        default:
            // same as Twba
            startLong = 61
            startLat = 46
        }
        
        var fDate = fYear.text!
        let mth = Int(fMth.text!)
        let day = Int(fDay.text!)
        fDate = fDate + String(format: "%02d", arguments: [mth!])
        fDate = fDate + String(format: "%02d", arguments: [day!])
        
        url = url + fDate
        url = url + ".nc.ascii?tsfmax"
        url = "\(url)[0:60][\(startLat):\(startLat)][\(startLong):\(startLong)]"
        

        print(url)
        urldisplay.text = url
        
        urlEditDisplay.text = url
        
        let poamaURL = NSURL(string: url)
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithURL(poamaURL!){
            (data,response,error) -> Void in
            
            if error != nil {
                print("An Error Occured")
            } else {
                print(response!.description)
            }
            
            
        }
        dataTask.resume()
    }
}

