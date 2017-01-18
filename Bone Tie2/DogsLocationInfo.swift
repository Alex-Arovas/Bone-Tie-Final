//
//  DogsLocationInfo.swift
//  Bone Tie 3
//
//  Created by Alex Arovas on 4/26/16.
//  Copyright © 2016 Alex Arovas. All rights reserved.
//

import UIKit
import CoreLocation
import Contacts
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class DogsLocationInfo: UIViewController {
    var dogs: dog?
    var TypeofDirections: String?
    var traveltimes: String?
    @IBOutlet weak var Latitude: UILabel!
    @IBOutlet weak var Longtitude: UILabel!
    @IBOutlet weak var AreaofInterest: UILabel!
    @IBOutlet weak var Address: UILabel!
    @IBOutlet weak var TravelTime: UILabel!
    @IBOutlet weak var DirectionsType: UILabel!
    @IBOutlet weak var DirectionsTypeLabel: UILabel!
    @IBOutlet weak var TravelTimeLabel: UILabel!
    
    override func viewDidLoad() {
        if TypeofDirections == "None" {
            TravelTime.isHidden = true
            DirectionsType.isHidden = true
            TravelTimeLabel.isHidden = true
            DirectionsTypeLabel.isHidden = true
        } else {
            TravelTime.isHidden = false
            DirectionsType.isHidden = false
            TravelTimeLabel.isHidden = false
            DirectionsTypeLabel.isHidden = false
            TravelTime.text = traveltimes
            DirectionsType.text = TypeofDirections
        }
        self.navigationItem.title = dogs?.name
        self.reverseGeocoding(CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        Address.frame = CGRect(x: Address.frame.minX, y: Address.frame.minY, width: Address.frame.width, height: 0)
        Address.numberOfLines = 0
        TravelTime.numberOfLines = 0
        TravelTime.sizeToFit()
        }
    func postalAddressFromAddressDictionary(_ addressdictionary: Dictionary<String,AnyObject>) -> CNMutablePostalAddress {
        
        let address = CNMutablePostalAddress()
        
        address.street = addressdictionary["Street"] as? String ?? ""
        address.state = addressdictionary["State"] as? String ?? ""
        address.city = addressdictionary["City"] as? String ?? ""
        address.country = addressdictionary["Country"] as? String ?? ""
        address.postalCode = addressdictionary["ZIP"] as? String ?? ""
        
        return address
    }
    func reverseGeocoding(_ latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        Latitude.text = String(latitude)
        Longtitude.text = String(longitude)
        let location = CLLocation(latitude: latitude, longitude: longitude)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                print(error)
                return
            }
            else if placemarks?.count > 0 {
                let pm = placemarks![0]
                let address = CNPostalAddressFormatter.string(from: self.postalAddressFromAddressDictionary(pm.addressDictionary! as! Dictionary<String, AnyObject>), style: .mailingAddress)
                self.Address.text = address
                self.Address.sizeToFit()
                if pm.areasOfInterest?.count > 0 {
                    let areaOfInterest = pm.areasOfInterest?[0]
                    self.AreaofInterest.text = areaOfInterest
                } else {
                    print("No area of interest found.")
                }
            }
        })
    }
}
