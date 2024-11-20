//
//  String+Ext.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 11/19/24.
//

import Foundation

extension String
{
    subscript(i: Int) -> String { return String(self[index(startIndex, offsetBy: i)]) }
    
    var capitalizedFirst: String {
        guard let firstLetter   = self.first else { return "" }
        return firstLetter.uppercased() + self.dropFirst()
    }
    
    func deletePrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    
    func deleteSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
    
    
    // use languages.contains(where: input.contains) to find instances of an input string in an array
}
