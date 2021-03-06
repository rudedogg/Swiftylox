import Foundation

enum TokenType {
  // Single character tokens
  case lParen
  case rParen
  case lBrace
  case rBrace
  case comma
  case dot
  case minus
  case plus
  case semicolon
  case slash
  case star
  
  // One or two character tokens
  case bang
  case bangEquals
  case equal
  case equalEqual
  case greater
  case greaterEqual
  case less
  case lessEqual
  
  // Literals
  case identifier
  case string
  case number
  
  // Keywords
  case and
  case `class`
  case `else`
  case `false`
  case fun
  case `for`
  case `if`
  case `nil`
  case `or`
  case print
  case `return`
  case `super`
  case this
  case `true`
  case `var`
  case `while`
  
  case EOF
}
