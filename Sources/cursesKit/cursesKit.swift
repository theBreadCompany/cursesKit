//
//  cursesKit.swift
//
//
//  Created by Fabio Mauersberger on 21.01.22.
//


import ncurses
import Foundation

open class TerminalWindow {
    
    private let windowPointer: OpaquePointer
    private var colorPairs: [TerminalTextColorPair: Int16]
    
    public init(show: Bool = false) {
        //if show {}
        windowPointer = initscr()
        colorPairs = [:]
    }
    
    public func getDimensions() -> (Int, Int) {
        return (Int(LINES), Int(COLS))
    }
    
    public func add(text: String, being styles: [TerminalTextStyle] = [], using colors: TerminalTextColorPair? = nil, terminator: String = "\n", applyImmediatly: Bool = false) {
        self.apply(styles: styles, colors: colors, toContent: {
            let buffer = NSString(string: text + terminator).cString(using: String.Encoding.utf8.rawValue)
            addstr(buffer)
        })
        if applyImmediatly {
            self.applyChanges()
        }
    }
    
    public func applyChanges() {
        refresh()
    }
    
    private func apply(styles: [TerminalTextStyle], colors: TerminalTextColorPair?, toContent createContent: () -> ()) {
        var usedColorPair: Int16 = -1
        if let colors = colors {
            if has_colors() && start_color() == OK {
                if let colorPair = self.colorPairs[colors] {
                    usedColorPair = colorPair
                    attron(COLOR_PAIR(Int32(usedColorPair)))
                    
                } else {
                    usedColorPair = Array((colorPairs.values.max() ?? 0)+1..<Int16(COLOR_PAIRS)).min() ?? 0
                    init_pair(usedColorPair, colors.foreground.rawValue, colors.background.rawValue)
                    self.colorPairs.updateValue(usedColorPair, forKey: colors)
                    attron(COLOR_PAIR(Int32(usedColorPair)))
                    #if DEBUG
                    addstr(NSString(string: "registered '\(usedColorPair)' for (b: \(colors.background.rawValue), f: \(colors.foreground.rawValue))\n").cString(using: String.Encoding.utf8.rawValue))
                    #endif
                }
            }
        }
        styles.forEach { style in
            attron(style.rawValue)
        }
        createContent()
        
        if usedColorPair > -1 {
            attroff(COLOR_PAIR(Int32(usedColorPair)))
        }
        styles.forEach { style in
            attroff(style.rawValue)
        }
    }
    
    public func awaitKeyInput() -> Character {
        let intChar = getch()
        if !handle(signal: intChar) {
            return Character(UnicodeScalar(Int(intChar))!)
        }
        
        return Character("")
        
    }
    
    /**
     Handles a signal sent to ncurses via `getch()` (wrapped by `.awaitKeyInput()`
     - Parameter signal: The respective signal
     - returns: whether the input was an actual signal to apply
     */
    public func handle(signal: Int32) -> Bool {
        switch signal {
        case KEY_RESIZE:
            endwin()
            refresh()
            clear()
        default:
            return false
        }
        return true
    }
    
    public func clearScreen() {
        clear()
    }
    
    deinit {
        endwin()
    }
}
