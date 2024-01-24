// The Swift Programming Language
// https://docs.swift.org/swift-book

public struct TextChunker {
    public static func splitText(input: String, splits: [Character], maxLength: Int, overlap: Int) -> [String] {
        var results: [String] = []
        
        var dirtyResults: [String] = input.split { character in return splits.contains(character) }.compactMap({String($0)})
        
        var builder: String = ""
        while(!dirtyResults.isEmpty) {
            // Append a period because we just removed all of them
            var nextResult = dirtyResults.removeFirst()
            
            if nextResult.count > maxLength {
                let maxOffset = nextResult.index(nextResult.startIndex, offsetBy: maxLength)
                let hold = String(nextResult[maxOffset..<nextResult.endIndex])
                
                nextResult = String(nextResult[nextResult.startIndex..<maxOffset])
                dirtyResults.insert(hold, at: 0)
            }
            
            if (builder.count + nextResult.count) > maxLength {
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

