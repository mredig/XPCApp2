//
//  KittenGetterProxy.swift
//  XPCApp2
//
//  Created by Michael Redig on 7/27/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Cocoa

protocol KittenViewable: AnyObject {
	func kittenLoaded()
}

class KittenGetterProxy {

	var urls: [URL] = []
	var delegate: KittenViewable?

	let remoteDownloadConnection: NSXPCConnection = {
		let connection = NSXPCConnection(serviceName: "com.redeggproductions.XPCApp2-DataDownloader")
		connection.remoteObjectInterface = NSXPCInterface(with: DataFetchProtocol.self)
		connection.resume()
		return connection
	}()

	var kittens = [NSImage]()

	var timer: Timer?


	init() {

		timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true, block: { _ in
			self.getANewKitten()
		})

	}

	func getANewKitten() {
		urls.append(randomKittenURL())
		fetchKitten(at: urls.count - 1)
	}

	func randomKittenURL() -> URL {
		let url = URL(string: "https://placekitten.com/")!
		return url
			.appendingPathComponent("\(Int.random(in: 300...500))")
			.appendingPathComponent("\(Int.random(in: 300...500))")
	}

	func fetchKitten(at index: Int) {
		guard let downloader = remoteDownloadConnection.remoteObjectProxyWithErrorHandler({ error in
			NSLog("remote proxy error: \(error)")
		}) as? DataFetchProtocol else { return }

		let url = urls[index]

		downloader.downloadData(at: url) { imageData in
			guard let imageData = imageData, let image = NSImage(data: imageData) else {
				print("failed download \(url)")
				return
			}
			print("got \(imageData.count) bytes")

			self.kittens.append(image)
			self.delegate?.kittenLoaded()
		}
	}
}
