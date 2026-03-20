//
//  AlertManager.swift
//  Quote Tool
//
//  Created by Jorge Munoz on 2/14/24.
//

import Foundation
import UIKit

class AlertManager {
    
    static func showTextAlert(on vc: UIViewController, title: String, message: String, completion: @escaping (String, String) -> Void)
{
        
        // creating constants to store the alert Controller
        //create constant to store the alert Controller
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // add textfield for product description
        alert.addTextField{ textField in
            
            // textfield inside the placeholder = whatever you want it to say
            textField.placeholder = "Enter product description"
            
        }
        
        // add textfield for product cost
        alert.addTextField{ textField in
            // textfield.placeholder = "whatever you want it to say"
            textField.placeholder = "Enter product cost"
            //turn keyboard into a num pad keyboard
            textField.keyboardType = .numbersAndPunctuation
            
        }
        
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { _ in
            let productName = alert.textFields?[0].text ?? ""
            let productCost = alert.textFields?[1].text ?? ""
            
            completion(productName, productCost)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        DispatchQueue.main.async {
            
            vc.present(alert, animated: true)
        }
    }

}
