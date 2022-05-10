import Foundation

switch CommandLine.arguments.count {
  case 2:
    // Get the file path argument, it's argument #2
    let fileArgument = CommandLine.arguments[CommandLine.arguments.index(after: CommandLine.arguments.startIndex)]
    
    let fileURL = URL(fileURLWithPath: fileArgument)
    
    // We have a fileURL, call runFile() with it
    do {
      try runFile(fileURL)
    } catch(let error) {
      print(error.localizedDescription)
      exit(64)
    }
  case 1:
    // No file path provided, open an interactive interpreter
    runPrompt()
  default:
  // Invalid number of arguments
  print("Usage: swiftylox [script]")
  exit(64)
}

func runFile(_ url: URL) throws {
  print("Attempting to run file: \(url)")
  let sourceCode = try String(contentsOf: url)
  run(sourceCode)
  
  if hadError {
    exit(65)
  }
}

// REPL
func runPrompt() {
  print("Enter your lox code:")
  while let line = readLine() {
    run(line)
    hadError = false
  }
}

private func run(_ source: String) {
 let scanner = Scanner(source: source)
  let tokens: [Token] = scanner.scanTokens()
  
  for token in tokens {
    print(token)
  }
}

var hadError = false

private func error(line: Int, message: String) {
  report(line: line, where: "", message: message)
}

private func report(line: Int, `where`: String, message: String) {
  print("line \(line) Error \(`where`): \(message)")
  hadError = true
}
