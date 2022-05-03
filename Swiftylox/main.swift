import Foundation

switch CommandLine.arguments.count {
  case 2:
    guard let fileArgument = CommandLine.arguments.first else {
      print("First argument is invalid")
      exit(64)
    }
    
    guard let fileURL = URL(string: fileArgument) else {
      print("Provided file argument is not valid")
      exit(64)
    }
    
    // We have a valid fileURL, call runFile() with it
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
  
var hadError = false

private func error(line: Int, message: String) {
  report(line: line, where: "", message: message)
}

private func report(line: Int, `where`: String, message: String) {
  print("line \(line) Error \(`where`): \(message)")
  hadError = true
}
