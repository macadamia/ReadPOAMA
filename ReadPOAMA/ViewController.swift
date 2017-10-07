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
    
    

    @IBOutlet weak var ResultsScroll: UITextField!
    
    @IBOutlet weak var siteName: UITextField!
    
    
    @IBOutlet weak var ResultsView: UIScrollView!
    
    @IBOutlet weak var urlEditDisplay: UITextField!
    
    
    // dagc_20151220.nc.ascii.txt
    let useTxt = false
    
    
    
    // a return would need -> return type
    @IBAction func generateURL(_ sender: UIButton) {
        //local constant starts with let
        // generally don't have to use upper case etc to denote constants
        var url = "http://opendap.bom.gov.au:8080/thredds/dodsC/poama/realtime/daily/m24a/emn/dagc_"
        let site = siteName.text!
        
        var startLong: Int
        var startLat: Int
        
        
        let bundle = Bundle.main
        
        
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
        
        if useTxt {
            url = "dagc_20151220.nc.ascii"
        } else  {
            url = url + fDate
            url = url + ".nc.ascii?tsfmax"
            url = "\(url)[0:60][\(startLat):\(startLat)][\(startLong):\(startLong)]"
        }

        print(url)
        urldisplay.text = url
        
        urlEditDisplay.text = url
        var maxTemperatures = [Float] ()
        
        let poamaURL = URL(string: url)
        
        if poamaURL != nil && !useTxt {
            do {
                let contents = try NSString(contentsOf: poamaURL!, usedEncoding: nil)
                print(contents)
                ResultsScroll.text = contents as String

            } catch {
                print("contents could not be loaded from url")
            }
        } else {
            let poamaURL =  bundle.path(forResource: url, ofType: "txt")
            var stringTemps: String = ""
            do {
                let contents = try NSString(contentsOfFile: poamaURL!, usedEncoding: nil)
                print(contents)
                let lines = contents.components(separatedBy: CharacterSet.newlines)
                print("There are \(lines.count) lines in the file")
                //data starts 2 lines after ---------------------------------------------
                let startOfData = lines.index(of: "---------------------------------------------")! + 2
                for i in startOfData...startOfData+60 {
                    // split on comma
                    let temperature = NumberFormatter().number(from: lines[i].components(separatedBy: ",")[1])!.floatValue - 273.15
                    maxTemperatures.append(temperature)
                    stringTemps = stringTemps + "," + "\(temperature)"
                }
                ResultsScroll.text = stringTemps
                
            } catch {
                print("contents could not be loaded from file")
            }
            
        }
    }
}

