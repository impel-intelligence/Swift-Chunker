// The Swift Programming Language
// https://docs.swift.org/swift-book

public struct TextChunker {
    public static func splitTextByCharacter(input: String, splits: [Character], maxCharacters: Int, overlap: Int) -> [String] {
        var results: [String] = []
        
        var dirtyResults: [String] = input.split { character in return splits.contains(character) }.compactMap({String($0)})
        
        var builder: String = ""
        while(!dirtyResults.isEmpty) {
            var nextResult = dirtyResults.removeFirst()
            
            if nextResult.count > maxCharacters {
                let maxOffset = nextResult.index(nextResult.startIndex, offsetBy: maxCharacters)
                let hold = String(nextResult[maxOffset..<nextResult.endIndex])
                
                nextResult = String(nextResult[nextResult.startIndex..<maxOffset])
                dirtyResults.insert(hold, at: 0)
            }
            
            if (builder.count + nextResult.count) > maxCharacters {
                // Reset the string builder and then append the overlap into the next one.
                results.append(builder)
                
                let overlapOffset = builder.index(builder.endIndex, offsetBy: -overlap)
                builder = String(builder[overlapOffset...])
            }
            
            builder += nextResult
        }
        
        if !builder.isEmpty {
            results.append(builder)
        }

        results.removeAll(where: {$0.isEmpty})
        return results
    }
    
    public static func splitTextByWord(input: String, splits: [Character], maxWords: Int, overlap: Int) -> [String] {
        var results: [String] = []
        
        var dirtyResults: [String] = input.split { character in return splits.contains(character) }.compactMap({String($0)})
        
        var builder: String = ""
        while(!dirtyResults.isEmpty) {
            var nextResult = dirtyResults.removeFirst()
            
            let splitResult = nextResult.split(separator: " ")

            if splitResult.count > maxWords {
                let maxResultCharacterCount = splitResult.prefix(maxWords).joined(separator: " ").count
                let maxOffset = nextResult.index(nextResult.startIndex, offsetBy: maxResultCharacterCount)
                let hold = String(nextResult[maxOffset..<nextResult.endIndex])
                
                nextResult = String(nextResult[nextResult.startIndex..<maxOffset])
                dirtyResults.insert(hold, at: 0)
            }
            
            if (builder.count + nextResult.split(separator: " ").count) > maxWords {
                // Reset the string builder and then append the overlap into the next one.
                results.append(builder)
                
                let overlapOffset = builder.index(builder.endIndex, offsetBy: -overlap)
                builder = String(builder[overlapOffset...])
            }
            
            builder += nextResult
        }
        
        if !builder.isEmpty {
            results.append(builder)
        }

        results.removeAll(where: {$0.isEmpty})
        return results
    }

}

