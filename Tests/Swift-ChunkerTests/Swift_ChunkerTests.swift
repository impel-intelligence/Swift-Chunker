import XCTest
@testable import Swift_Chunker

final class Swift_ChunkerTests: XCTestCase {
    func testSplitNewlineCharacters() throws {
        let text = """
        Et magnam illum consectetur tenetur ratione. Harum magnam voluptas eaque aut odit cumque nam eveniet. Neque quo est aperiam at. Nostrum unde sint rem. Dolor repellendus excepturi dolores.

        Laborum velit natus sed vel. Ea earum ut aut dolore. Vel dolorem in nihil et tenetur aspernatur ut. Dicta non culpa natus est nesciunt. Molestiae fugit aspernatur ullam numquam.

        Enim est repellendus sit harum iste. Officia natus quibusdam dolores consectetur nobis ullam. Omnis atque ut labore rerum sit neque perspiciatis est. Rem et vero iure quod asperiores dolore. Quam officiis aperiam non aut aperiam occaecati aspernatur quam.

        Autem tempora rem necessitatibus tempora repellendus deleniti itaque. Sit voluptatem laboriosam neque. Vitae saepe iste quibusdam eum culpa.

        Qui rem adipisci eveniet recusandae eum impedit quisquam. Reprehenderit soluta molestiae nisi atque. Repellat delectus ipsum et iste vel. Excepturi voluptate quidem nulla blanditiis excepturi. Deleniti laudantium eveniet non occaecati.
        """
        
        let split = TextChunker.chunkText(input: text, splits: ["\n"], targetCharacters: 512, overlap: 0)

        XCTAssertEqual([
            "Et magnam illum consectetur tenetur ratione. Harum magnam voluptas eaque aut odit cumque nam eveniet. Neque quo est aperiam at. Nostrum unde sint rem. Dolor repellendus excepturi dolores.Laborum velit natus sed vel. Ea earum ut aut dolore. Vel dolorem in nihil et tenetur aspernatur ut. Dicta non culpa natus est nesciunt. Molestiae fugit aspernatur ullam numquam.",
            "Enim est repellendus sit harum iste. Officia natus quibusdam dolores consectetur nobis ullam. Omnis atque ut labore rerum sit neque perspiciatis est. Rem et vero iure quod asperiores dolore. Quam officiis aperiam non aut aperiam occaecati aspernatur quam.Autem tempora rem necessitatibus tempora repellendus deleniti itaque. Sit voluptatem laboriosam neque. Vitae saepe iste quibusdam eum culpa.",
            "Qui rem adipisci eveniet recusandae eum impedit quisquam. Reprehenderit soluta molestiae nisi atque. Repellat delectus ipsum et iste vel. Excepturi voluptate quidem nulla blanditiis excepturi. Deleniti laudantium eveniet non occaecati."
        ], split)
    }

    func testSplitWord() throws {
        let content = """
        Et magnam illum consectetur tenetur ratione. Harum magnam voluptas eaque aut odit cumque nam eveniet. Neque quo est aperiam at. Nostrum unde sint rem. Dolor repellendus excepturi dolores.
        
        Laborum velit natus sed vel. Ea earum ut aut dolore. Vel dolorem in nihil et tenetur aspernatur ut. Dicta non culpa natus est nesciunt. Molestiae fugit aspernatur ullam numquam.
        
        Enim est repellendus sit harum iste. Officia natus quibusdam dolores consectetur nobis ullam. Omnis atque ut labore rerum sit neque perspiciatis est. Rem et vero iure quod asperiores dolore. Quam officiis aperiam non aut aperiam occaecati aspernatur quam.
        
        Autem tempora rem necessitatibus tempora repellendus deleniti itaque. Sit voluptatem laboriosam neque. Vitae saepe iste quibusdam eum culpa.
        
        Qui rem adipisci eveniet recusandae eum impedit quisquam. Reprehenderit soluta molestiae nisi atque. Repellat delectus ipsum et iste vel. Excepturi voluptate quidem nulla blanditiis excepturi. Deleniti laudantium eveniet non occaecati.
        """
        
        let overlap = 15
        let wordCount = content.replacingOccurrences(of: "\n", with: " ").split(separator: " ").count

        let maxLength: Int = Int(ceil(Double(wordCount + overlap) / 2.0))
        
        let chunks = TextChunker.chunkText(input: content, targetWords: maxLength, wordOverlap: overlap)

        XCTAssert(chunks.count == 2)
        XCTAssert(chunks[0].split(separator: " ").count <= maxLength)
        XCTAssert(chunks[1].split(separator: " ").count <= maxLength)
    }
    
    func testSplitTokens() throws {
        let content = """
        Et magnam illum consectetur tenetur ratione. Harum magnam voluptas eaque aut odit cumque nam eveniet. Neque quo est aperiam at. Nostrum unde sint rem. Dolor repellendus excepturi dolores.
        
        Laborum velit natus sed vel. Ea earum ut aut dolore. Vel dolorem in nihil et tenetur aspernatur ut. Dicta non culpa natus est nesciunt. Molestiae fugit aspernatur ullam numquam.
        
        Enim est repellendus sit harum iste. Officia natus quibusdam dolores consectetur nobis ullam. Omnis atque ut labore rerum sit neque perspiciatis est. Rem et vero iure quod asperiores dolore. Quam officiis aperiam non aut aperiam occaecati aspernatur quam.
        
        Autem tempora rem necessitatibus tempora repellendus deleniti itaque. Sit voluptatem laboriosam neque. Vitae saepe iste quibusdam eum culpa.
        
        Qui rem adipisci eveniet recusandae eum impedit quisquam. Reprehenderit soluta molestiae nisi atque. Repellat delectus ipsum et iste vel. Excepturi voluptate quidem nulla blanditiis excepturi. Deleniti laudantium eveniet non occaecati.
        """
        
        let targetTokens = 120
        let tokenCharacterLength = 4
        let tokenOverlap = 20
        
        let chunks = TextChunker.chunkText(input: content, targetTokens: targetTokens, tokenCharacterLength: tokenCharacterLength, tokenOverlap: tokenOverlap)

        assert(chunks.count == 3)
        assert((chunks[0].count / tokenCharacterLength) == targetTokens)
        assert((chunks[1].count / tokenCharacterLength) == targetTokens)
    }

    func testSplitTokensTwoChunks() throws {
        let content = """
        Et magnam illum consectetur tenetur ratione. Harum magnam voluptas eaque aut odit cumque nam eveniet. Neque quo est aperiam at. Nostrum unde sint rem. Dolor repellendus excepturi dolores.
        
        Laborum velit natus sed vel. Ea earum ut aut dolore. Vel dolorem in nihil et tenetur aspernatur ut. Dicta non culpa natus est nesciunt. Molestiae fugit aspernatur ullam numquam.
        
        Enim est repellendus sit harum iste. Officia natus quibusdam dolores consectetur nobis ullam. Omnis atque ut labore rerum sit neque perspiciatis est. Rem et vero iure quod asperiores dolore. Quam officiis aperiam non aut aperiam occaecati aspernatur quam.
        
        Autem tempora rem necessitatibus tempora repellendus deleniti itaque. Sit voluptatem laboriosam neque. Vitae saepe iste quibusdam eum culpa.
        
        Qui rem adipisci eveniet recusandae eum impedit quisquam. Reprehenderit soluta molestiae nisi atque. Repellat delectus ipsum et iste vel. Excepturi voluptate quidem nulla blanditiis excepturi. Deleniti laudantium eveniet non occaecati.
        """
                

        let tokenCharacterLength = 4
        let tokenOverlap = 20
        
        let targetTokens: Int = Int(ceil(Double(content.count / 4 + tokenOverlap) / 2.0))
        
        let chunks = TextChunker.chunkText(input: content, targetTokens: targetTokens, tokenCharacterLength: tokenCharacterLength, tokenOverlap: tokenOverlap)

        assert(chunks.count == 2)
        assert((chunks[0].count / tokenCharacterLength) == targetTokens)
    }
}
