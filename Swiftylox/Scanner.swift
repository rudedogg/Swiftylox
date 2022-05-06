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
      case "'":
        addToken(.lParen)
        addToken(.rParen)
        addToken(.lBrace)
        addToken(.rBrace)
        addToken(.comma)
        addToken(.dot)
        addToken(.minus)
        addToken(.plus)
        addToken(.semicolon)
        addToken(.star)
      default:
        print("\(line): Unexpected character.")
    }
  }
 
  private func addToken(_ type: TokenType) {
    addToken(type: type, literal: nil)
  }
  
  private func addToken(type: TokenType, literal: Any?) {
    let text = String(source[start...current])
    tokens.append(Token(type: type, lexeme: text, literal: literal, line: line))
  }
  
}
