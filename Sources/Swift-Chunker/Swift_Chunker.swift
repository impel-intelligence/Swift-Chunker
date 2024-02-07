// The Swift Programming Language
// https://docs.swift.org/swift-book

public struct TextChunker {
    public static func chunkText(input: String, splits: [Character], targetCharacters: Int, overlap: Int) -> [String] {
        var results: [String] = []
        
        var dirtyResults: [String] = input.split { character in return splits.contains(character) }.compactMap({String($0)})
        
        var builder: String = ""
        while(!dirtyResults.isEmpty) {
            var nextResult = dirtyResults.removeFirst()
            
            if nextResult.count > targetCharacters {
                let maxOffset = nextResult.index(nextResult.startIndex, offsetBy: targetCharacters)
                let hold = String(nextResult[maxOffset..<nextResult.endIndex])
                
                nextResult = String(nextResult[nextResult.startIndex..<maxOffset])
                dirtyResults.insert(hold, at: 0)
            }
            
            if (builder.count + nextResult.count) > targetCharacters {
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
        
    public static func chunkText(input: String, targetWords: Int, wordOverlap: Int) -> [String] {
        var results: [String] = []
        
        var dirtySplits: [[String.SubSequence]] = input.split(separator: "\n").compactMap({String($0).split(separator: " ")})
        
        while !dirtySplits.isEmpty {
            let currentWords = dirtySplits.removeFirst()
            var overlap: String = ""
            if let lastOverlap = results.first?.split(separator: " ").suffix(wordOverlap) {
                overlap = lastOverlap.joined(separator: " ") + " "
            }
            
            let maxWords = targetWords - overlap.split(separator: " ").count
            
            if currentWords.count < maxWords && !dirtySplits.isEmpty {
                dirtySplits[0].insert(contentsOf: currentWords, at: 0)
            } else if currentWords.count > maxWords {
                var chunk = Array(currentWords.prefix(maxWords)).joined(separator: " ")
                chunk.insert(contentsOf: overlap, at: chunk.startIndex)
                results.append(chunk)
                
                let leftovers = Array(currentWords.dropFirst(maxWords))
                dirtySplits.insert(leftovers, at: 0)
            } else {
                var chunk = currentWords.joined(separator: " ")
                chunk.insert(contentsOf: overlap, at: chunk.startIndex)
                results.append(chunk)
            }
        }
        
        return results
    }

    public static func chunkText(input: String, targetTokens: Int, tokenCharacterLength: Int, tokenOverlap: Int) -> [String] {
        guard tokenOverlap < targetTokens else { return [] }
        
        var tokenSets: [[String]] = [[]]
        var mutableInput = input
        
        var tokenBuilder = ""
        var counter: Int = 0
        while !mutableInput.isEmpty {
            let character = mutableInput.removeFirst()
            
            if counter == tokenCharacterLength {
                // Check if we need to create a new tokenSet, if so add the overlap here
                if tokenSets[tokenSets.count - 1].count >= targetTokens {
                    var overlap = tokenSets[tokenSets.count - 1]
                    let numberToDrop = overlap.count - tokenOverlap
                    overlap.removeFirst(numberToDrop)
                    
                    tokenSets.append(overlap)
                }
                
                tokenSets[tokenSets.count - 1].append(tokenBuilder)
                tokenBuilder = ""
                counter = 0
            }
            
            tokenBuilder += String(character)
            counter += 1
        }
        
        return tokenSets.compactMap({$0.joined()})
    }
}
