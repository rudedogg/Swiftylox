import Foundation

class Scanner  {
  
  private let keywords: [String: TokenType] = [
    "and": .and,
    "class": .class,
    "else": .else,
    "false": .false,
    "for": .for,
    "fun": .fun,
    "if": .if,
    "nil": .nil,
    "or": .or,
    "print": .print,
    "return": .return,
    "super": .super,
    "this": .this,
    "true": .true,
    "var": .var,
    "while": .while,
  ]
  
  private var source: String
  private var tokens: [Token] = []
  
  private var start: String.Index
  private var current: String.Index
  private var line = 1
  
  private var isAtEnd: Bool {
    return current >= source.endIndex
  }
  
  private func advance() -> Character {
    defer {
      // Advance the current index after returning
      current = source.index(after: current)
    }
    
    return source[current]
  }
  
  init(source: String) {
    self.source = source
    self.current = source.startIndex
    self.start = source.startIndex
  }
  
  func scanTokens() -> [Token] {
    while(!isAtEnd) {
      start = current;
      scanToken()
    }
    
    // Finish with the EOF token
    tokens.append(Token(type: .EOF, lexeme: "", literal: nil, line: line))
    return tokens
  }
  
  private func scanToken() {
    let c = advance()
    
    switch(c) {
      case "(":
        addToken(.lParen)
      case ")":
        addToken(.rParen)
      case "{":
        addToken(.lBrace)
      case "}":
        addToken(.rBrace)
      case ",":
        addToken(.comma)
      case ".":
        addToken(.dot)
      case "-":
        addToken(.minus)
      case "+":
        addToken(.plus)
      case ";":
        addToken(.semicolon)
      case "*":
        addToken(.star)
      case "!":
        addToken(match("=") ? .bangEquals : .bang)
      case "=":
        addToken(match("=") ? .equalEqual : .equal)
      case "<":
        addToken(match("=") ? .lessEqual : .less)
      case ">":
        addToken(match("=") ? .greaterEqual : .greater)
      case "/":
        if(match("/")) {
          // Consume the comment but don't add a token
          while(peek() != "\n" && !isAtEnd) {
            _ = advance()
          }
        }
        else {
          addToken(.slash)
        }
      case " ":
        break
      case "\r":
        break
      case "\t":
        break
      case "\n":
        line += 1
      case "\"":
        string()
      default:
        if isDigit(c) {
          number()
        } else if isAlpha(c) {
          identifier()
        } else {
          print("\(line): Unexpected character.")
        }
    }
  }
  
  private func identifier() {
    while peek().isLetter {
      advance()
    }
    
    // Look up the identifier text in the keywords dictionary and if it matches a token, insert a token of that type instead.
    // If not, it's an identifier
    let text = String(source[start..<current])
    if let type = keywords[text] {
      addToken(type)
    } else {
      addToken(.identifier)
    }
  }
  
  private func number() {
    while isDigit(peek()) {
      advance()
      
      if peek() == "." && isDigit(peekNext()) {
        // Consume the "."
        advance()
        
        while isDigit(peek()) {
          advance()
        }
      }
      
    }
    let numberLiteralString = source[start..<current]
    addToken(.number, literal: Double(numberLiteralString))
  }
  
  private func string() {
    while(peek() != "\"" && !isAtEnd) {
      // Support multi-line strings
      if peek() == "\n" {
        line += 1
      }
      advance()
    }
    
    if isAtEnd {
      error(line: line, message: "Unterminated string")
      return
    }
    
    advance() // The closing "
    
    // Calculate indices needed to trim off the surrounding quotes
    let startIndex = source.index(after: source.startIndex) // The index after the opening "
    let endIndex = source.index(before: source.endIndex) // The index before the closing "
    
    let substring = source[startIndex..<endIndex]
    addToken(.string, literal: String(substring))
  }
  
  private func match(_ expected: Character) -> Bool {
    guard !isAtEnd else { return false }
    
    if source[current] == expected {
      // This can be thought of as "consuming" the current character – since we're advancing the current index
      current = source.index(after: current)
      return true
    } else {
      return false
    }
  }
  
  // Lookahead
  private func peek() -> Character {
    guard !isAtEnd else { return "\0" }
    
    return source[current]
  }
  
  private func peekNext() -> Character {
    if source.index(after: current) >= source.endIndex {
      return "\0"
    } else {
      let nextIndex = source.index(after: current)
      return source[nextIndex]
    }
  }
  
  private func isAlpha(_ character: Character) -> Bool {
    return (character >= "a" && character <= "z") ||
    (character >= "A" && character <= "Z") ||
    character == "_"
  }
  
  private func isAlphaNumeric(_ character: Character) -> Bool {
    return isAlpha(character) || isDigit(character)
  }
  
  private func isDigit(_ character: Character) -> Bool {
    return "0123456789".contains(character)
  }
 
  private func addToken(_ type: TokenType) {
    addToken(type, literal: nil)
  }
  
  private func addToken(_ type: TokenType, literal: Any?) {
    let text = String(source[start..<current])
    tokens.append(Token(type: type, lexeme: text, literal: literal, line: line))
  }
  
}
