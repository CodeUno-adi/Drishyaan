//
//  Vehicle.swift
//  Table
//
//  Created by Sadhana on 12/11/15.
//  Copyright © 2015 VinCorp. All rights reserved.
//

import Foundation

class Vehicle
{
    var name:String?
    var type:String?
    
    var controlField:String
    var subField:String
        
    init(name:String,type:String,controlField:String,subField: String)
    {
        self.name = name
        self.type = type
        self.controlField = controlField
        self.subField = subField
    }
    
    
}