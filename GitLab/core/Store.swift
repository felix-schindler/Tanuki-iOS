//
//  Store.swift
//  GitLab
//
//  Created by Felix Schindler on 18.03.23.
//

import Foundation
import SwiftUI

class Store {
	@AppStorage("showed_info")
	public static var showInfo: Bool = true
}
