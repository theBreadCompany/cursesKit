# cursesKit

This repo is a prototype only.

## current status

This is how the example looks right now:
![current state](https://i.imgur.com/ojlkIH0.png)

## building

To "try" to example, be sure to have `ncurses` installed, `clone` this repo, `cd` and run `swift build`. Then you can execute `.build/debug/Example` to see it in action. 

## TODO

- (done) include dependency for ncurses
- write a `TerminalWindow` class or similiar which enables
	- observation of
  		- (done) terminal (window) size
  		- cursor position (if applicable)
	- (done) (key) input
	- (key) navigation
	- (done) text customization

## use cases

This package will be useful for two repos of mine already:

- swiftbar, my progressbar, which will be able to automatically resize itself
- SwiftTUI, which will be a wrapper around this to enable SwiftUI like syntax
