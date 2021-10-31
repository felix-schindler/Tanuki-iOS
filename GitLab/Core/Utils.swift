//
//  Utils.swift
//  GitLab
//
//  Created by Felix Schindler on 31.10.21.
//

import Foundation

extension String
{
    func trim() -> String
    {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
