import Foundation

switch CommandLine.arguments.count {
  case 1:
    guard let fileArgument = CommandLine.arguments.first else {
      print("First argument is invalid")
      exit(64)
    }
    
    guard let fileURL = URL(string: fileArgument) else {
      print("Provided file argument is not valid")
      exit(64)
    }
    
    // We have a valid fileURL, call runFile() with it
    runFile(fileURL)
  case 0:
    // No file path provided, open an interactive interpreter
    runPrompt()
  default:
  // Invalid number of arguments
  print("Usage: swiftylox [script]")
  exit(64)
}

func runFile(_ url: URL) {
  
}

func runPrompt() {
  
}
