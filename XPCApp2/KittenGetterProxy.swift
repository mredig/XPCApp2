//
//  KittenGetterProxy.swift
//  XPCApp2
//
//  Created by Michael Redig on 7/27/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Cocoa

class KittenGetterProxy {

	let urls: [URL]

	let remoteDownloadConnection: NSXPCConnection = {
		let connection = NSXPCConnection(serviceName: "com.redeggproductions.XPCApp2-Downloader")
		connection.remoteObjectInterface = NSXPCInterface(with: DataFetchProtocol.self)
		connection.resume()
		return connection
	}()

	var cachedKittens = [Int: NSImage]()


	init() {
		let random = Int.random(in: 10...20)
		self.urls = (1...random).map { _ in URL(string: "https://placekitten.com/") }
								.compactMap { $0 }
								.map { $0.appendingPathComponent("\(Int.random(in: 300...500))")
										 .appendingPathComponent("\(Int.random(in: 300...500))")}
	}

	func fetchKitten(at index: Int, completion: @escaping (NSImage?) -> Void) {
		if let image = cachedKittens[index] {
			completion(image)
			return
		}

		guard let downloader = remoteDownloadConnection.remoteObjectProxyWithErrorHandler({ error in
			NSLog("remote proxy error: \(error)")
		}) as? DataFetchProtocol else { return }

		for url in urls {
			downloader.downloadData(at: url) { imageData in
				guard let imageData = imageData, let image = NSImage(data: imageData) else {
					completion(nil)
					print("failed download")
					return
				}
				print("got \(imageData.count) bytes")
				completion(image)
			}
		}
	}
}
