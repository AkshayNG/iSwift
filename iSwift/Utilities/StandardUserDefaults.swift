//get and set methods

import Foundation

var VARIABLE_BOOL:Bool
{
    get
    {
        return UserDefaults.standard.bool(forKey: "key1")
    }

    set(val)
    {
        UserDefaults.standard.set(val, forKey: "key1")
    }
}

var VARIABLE_STRING:String?
{
    get
    {
        return UserDefaults.standard.value(forKey: "key2") as! String?
    }

    set(val)
    {
        UserDefaults.standard.set(val, forKey: "key2")
    }
}
