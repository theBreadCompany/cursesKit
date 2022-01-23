//
//  File.swift
//  
//
//  Created by Fabio Mauersberger on 22.01.22.
//

import Foundation
import ncurses
import CoreData

/**
 Text style manipulation options.
 Each option is represented by an `Int32` value.
 */
public enum TerminalTextStyle: Int32, CaseIterable {
    case normal = 0
    case blink = 524288
    case bold = 2097152
    case dim = 1048576
    case invisible = 8388608
    case protected = 16777216
    case reversed = 262144
    case standout = 65536
    case underlined = 131072
    case low = 134217728
}

/**
 Colors predefined by ncurses.
 Each color is identified by an `Int32` value.
 */
public enum Colors: Int16, TerminalTextColor {

    /**
        Store an ordinary `Int32` as a color constant.
     */
    public init?(rawValue: Int32) {
        switch rawValue {
        case COLOR_BLACK: self = .black
        case COLOR_RED: self = .red
        case COLOR_GREEN: self = .green
        case COLOR_YELLOW: self = .yellow
        case COLOR_BLUE: self = .blue
        case COLOR_MAGENTA: self = .magenta
        case COLOR_CYAN: self = .cyan
        case COLOR_WHITE: self = .white
        default:
            return nil
        }
    }
    
    case black = 0
    case red = 1
    case green = 2
    case yellow = 3
    case blue = 4
    case magenta = 5
    case cyan = 6
    case white = 7
}

/**
 Store custom colors.
 */
public struct CustomColor: TerminalTextColor {
    
    public let rawValue: Int16
    
    init?(colorNr: Int, r: Int, g: Int, b: Int) {
        guard (0..<Int16(COLORS)-1) ~= Int16(colorNr) &&
                (0...1000) ~= r && (0...1000) ~= g && (0...1000) ~= b
        else { return nil }
        self.rawValue = Int16(init_color(Int16(colorNr), Int16(r), Int16(g), Int16(b)))
    }
}

public struct TerminalTextColorPair: Hashable {
    public let background: TerminalTextColor
    public let foreground: TerminalTextColor
    
    public init(background: TerminalTextColor, foreground: TerminalTextColor) {
        self.background = background
        self.foreground = foreground
    }
    
    public static func == (lhs: TerminalTextColorPair, rhs: TerminalTextColorPair) -> Bool {
        return {
            lhs.foreground.rawValue == rhs.foreground.rawValue &&
            lhs.background.rawValue == rhs.background.rawValue
        }()
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.foreground.rawValue)
        hasher.combine(self.background.rawValue)
    }
}

public protocol TerminalTextColor {
    var rawValue: Int16 { get }
}
