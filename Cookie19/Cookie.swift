//
//  cookie.swift
//  cookie
//
//  Created by Bob Wint on 9/1/18.
//  Copyright © 2018 BWInc. All rights reserved.
//

import Foundation

class cookie : NSObject, NSCoding {
    var cookieName = ""
    var cookieDescription = ""
    var cookieDozens = ""
    var like = true
    
    // used to load data from a file (encode and decode forKeys must be identical)
    required init?(coder aDecoder: NSCoder) {
        super.init()
        cookieName = aDecoder.decodeObject(forKey: "cookieName") as! String
        cookieDescription = aDecoder.decodeObject(forKey: "cookieDescription") as! String
        cookieDozens = aDecoder.decodeObject(forKey: "cookieDozens") as! String
        like = aDecoder.decodeBool(forKey: "like")
    }
    
    // describes what a cookie object looks like so coder knows how to save it
    func encode(with aCoder: NSCoder) {
        aCoder.encode(cookieName, forKey: "cookieName")
        aCoder.encode(cookieDescription, forKey: "cookieDescription")
        aCoder.encode(cookieDozens, forKey: "cookieDozens")
        aCoder.encode(like, forKey: "like")
    }
    
    override init() {
        super.init()
    }
}
