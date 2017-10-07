//
//  ViewController.swift
//  Weather
//
//  Created by dly on 10/6/17.
//  Copyright © 2017 dly. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var weatherResult: UILabel!
    @IBAction func submitButtonPressed(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get webpage
        let url = URL(string: "https://www.weather-forecast.com/locations/Los-Angeles/forecasts/latest")
        let request = NSMutableURLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            var message = ""
            
            if let error = error {
                print(error)
            }
            else {
                if let unwrappedData = data {
                    let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                    //print(dataString)
                    
                    //Get the content
                    //View Page Source on the website and grab the bits of text infront of the data that is desired
                    var stringSeperator = "Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">"
                    
                    if let contentArray = dataString?.components(separatedBy: stringSeperator) {
                        //print(contentArray)
                        
                        if contentArray.count > 0 {
                            stringSeperator = "</span>"
                            
                            let newContentArray = contentArray[1].components(separatedBy: stringSeperator)
                                
                            if newContentArray.count > 0 {
                                //Option+Shift+8 will give the degrees symbol ("°")
                                message = newContentArray[0].replacingOccurrences(of: "&deg;", with: "°")
                                //print(newContentArray[0])
                                //print(message)
                            }
                        }
                    }
                }
            }
            
            //Successful or not
            if message == "" {
                message = "The weather there couldn't be found. Please try again."
            }
            //When task above completes, do this
            DispatchQueue.main.sync(execute: {
                self.weatherResult.text = message
                })
        }
        //Run the task
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

