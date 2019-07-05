//  ControllsHelperFunctions.swift
//  Created by Holger Hinzberg on 27.03.19.
//  Copyright © 2019 Holger Hinzberg. All rights reserved.

import Cocoa

public func BoolToCheckboxState(value:Bool) -> NSControl.StateValue
{
    if value == true
    {
        return NSControl.StateValue.on
    }
    return NSControl.StateValue.off
}

public func CheckboxStateToBool(value:NSControl.StateValue) -> Bool
{
    if value == NSControl.StateValue.on
    {
        return true
    }
    return false
}

