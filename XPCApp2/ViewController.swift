//
//  ViewController.swift
//  XPCApp2
//
//  Created by Michael Redig on 7/26/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
	@IBOutlet var tableView: NSTableView!

	let kittensGetter = KittenGetterProxy()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		kittensGetter.delegate = self

		// Do any additional setup after loading the view.
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}

extension ViewController: NSTableViewDataSource, NSTableViewDelegate {
	func numberOfRows(in tableView: NSTableView) -> Int {
		return kittensGetter.kittens.count
	}

	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "KittenImage"), owner: self) as? NSTableCellView
//		cell
		cell?.imageView?.image = kittensGetter.kittens[row]
		return cell
	}

	func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return kittensGetter.kittens[row].size.height
	}
}

extension ViewController: KittenViewable {
	func kittenLoaded() {
		print("got kitten!")
		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}
}
