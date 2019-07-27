//
//  main.m
//  XPCApp2-DataDownloader
//
//  Created by Michael Redig on 7/27/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Foundation


class ServiceDelegate: NSObject, NSXPCListenerDelegate {
	func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
		newConnection.exportedInterface = NSXPCInterface(with: DataFetchProtocol.self)
		let exportedObject = DataDownloader()
		newConnection.exportedObject = exportedObject
		newConnection.resume()
		return true
	}
}

let delegate = ServiceDelegate()
let listener = NSXPCListener.service()
listener.delegate = delegate
listener.resume()
