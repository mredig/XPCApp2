//
//  DataDownloader.swift
//  XPCApp2-DataDownloader
//
//  Created by Michael Redig on 7/27/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Foundation

class DataDownloader: DataFetchProtocol {

	func downloadData(at url: URL, completion: @escaping (Data?) -> Void) {
		URLSession.shared.dataTask(with: url) { data, response, error in
			completion(data)
		}.resume()
	}
}
