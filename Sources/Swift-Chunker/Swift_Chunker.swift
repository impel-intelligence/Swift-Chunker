// The Swift Programming Language
// https://docs.swift.org/swift-book

public struct TextChunker {
    public static func splitText(input: String, splits: [Character], maxLength: Int, overlap: Int) -> [String] {
        var results: [String] = []
        
        var dirtyResults: [String] = input.split { character in return splits.contains(character) }.compactMap({String($0)})
        
        var builder: String = ""
        while(!dirtyResults.isEmpty) {
            // Append a period because we just removed all of them
            let nextResult = dirtyResults.removeFirst()
            
            if (builder.count + nextResult.count) > maxLength {
                // Reset the string builder and then append the overlap into the next one.
                results.append(builder)
                
                guard builder.count - overlap >= 0 else { break }
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

