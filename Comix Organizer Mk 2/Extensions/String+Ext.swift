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
    
    func deletePrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    
    func deleteSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
}
