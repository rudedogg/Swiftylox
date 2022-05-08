import Foundation

class Scanner  {
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
      default:
        print("\(line): Unexpected character.")
    }
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
 
  private func addToken(_ type: TokenType) {
    addToken(type: type, literal: nil)
  }
  
  private func addToken(type: TokenType, literal: Any?) {
    let text = String(source[start..<current])
    tokens.append(Token(type: type, lexeme: text, literal: literal, line: line))
  }
  
}
