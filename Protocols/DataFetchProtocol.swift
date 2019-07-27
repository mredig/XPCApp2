//
//  ImageFetchProtocol.swift
//  XPCApp2
//
//  Created by Michael Redig on 7/27/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Foundation

@objc protocol DataFetchProtocol {
	func downloadData(at url: URL, completion: @escaping (Data?) -> Void)
}
