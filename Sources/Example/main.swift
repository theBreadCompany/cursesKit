//
//  main.swift
//  
//
//  Created by Fabio Mauersberger on 21.01.22.
//

import Foundation
import cursesKit

func buildMain(on window: TerminalWindow, havingTitle title: String) {
    window.add(text: "This is some random text.")
    window.add(text: "Some underlined text.", being: [.underlined])
    window.add(text: "And some colorized text.", using: .init(background: Colors.green, foreground: Colors.blue))
    window.add(text: "Even combinations of both!", being: [.bold, .underlined], using: .init(background: Colors.cyan, foreground: Colors.magenta))
    let sizes = window.getDimensions()
    window.add(text: "Rows: \(sizes.0)")
    window.add(text: "Columns: \(sizes.1)")
    window.applyChanges()
}

func main() {
    let test = TerminalWindow()
    var k = Character(" ")
    repeat {
        buildMain(on: test, havingTitle: "Random text")
        test.add(text: String(k), applyImmediatly: true)
        k = test.awaitKeyInput()
        clear()
    } while k != "q"
}

main()
