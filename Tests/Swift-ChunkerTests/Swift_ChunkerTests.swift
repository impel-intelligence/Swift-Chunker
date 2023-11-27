import XCTest
@testable import Swift_Chunker

final class Swift_ChunkerTests: XCTestCase {
    func testSplitNewline() throws {
        let text = """
        Et magnam illum consectetur tenetur ratione. Harum magnam voluptas eaque aut odit cumque nam eveniet. Neque quo est aperiam at. Nostrum unde sint rem. Dolor repellendus excepturi dolores.

        Laborum velit natus sed vel. Ea earum ut aut dolore. Vel dolorem in nihil et tenetur aspernatur ut. Dicta non culpa natus est nesciunt. Molestiae fugit aspernatur ullam numquam.

        Enim est repellendus sit harum iste. Officia natus quibusdam dolores consectetur nobis ullam. Omnis atque ut labore rerum sit neque perspiciatis est. Rem et vero iure quod asperiores dolore. Quam officiis aperiam non aut aperiam occaecati aspernatur quam.

        Autem tempora rem necessitatibus tempora repellendus deleniti itaque. Sit voluptatem laboriosam neque. Vitae saepe iste quibusdam eum culpa.

        Qui rem adipisci eveniet recusandae eum impedit quisquam. Reprehenderit soluta molestiae nisi atque. Repellat delectus ipsum et iste vel. Excepturi voluptate quidem nulla blanditiis excepturi. Deleniti laudantium eveniet non occaecati.
        """
        
        let split = TextChunker.splitText(input: text, splits: ["\n"], maxLength: 512, overlap: 0)

        XCTAssertEqual([
            "Et magnam illum consectetur tenetur ratione. Harum magnam voluptas eaque aut odit cumque nam eveniet. Neque quo est aperiam at. Nostrum unde sint rem. Dolor repellendus excepturi dolores.Laborum velit natus sed vel. Ea earum ut aut dolore. Vel dolorem in nihil et tenetur aspernatur ut. Dicta non culpa natus est nesciunt. Molestiae fugit aspernatur ullam numquam.",
            "Enim est repellendus sit harum iste. Officia natus quibusdam dolores consectetur nobis ullam. Omnis atque ut labore rerum sit neque perspiciatis est. Rem et vero iure quod asperiores dolore. Quam officiis aperiam non aut aperiam occaecati aspernatur quam.Autem tempora rem necessitatibus tempora repellendus deleniti itaque. Sit voluptatem laboriosam neque. Vitae saepe iste quibusdam eum culpa.",
            "Qui rem adipisci eveniet recusandae eum impedit quisquam. Reprehenderit soluta molestiae nisi atque. Repellat delectus ipsum et iste vel. Excepturi voluptate quidem nulla blanditiis excepturi. Deleniti laudantium eveniet non occaecati."
        ], split)
    }
    
    func testSplitPeriod() throws {
        let text = """
        Et magnam illum consectetur tenetur ratione. Harum magnam voluptas eaque aut odit cumque nam eveniet. Neque quo est aperiam at. Nostrum unde sint rem. Dolor repellendus excepturi dolores.

        Laborum velit natus sed vel. Ea earum ut aut dolore. Vel dolorem in nihil et tenetur aspernatur ut. Dicta non culpa natus est nesciunt. Molestiae fugit aspernatur ullam numquam.

        Enim est repellendus sit harum iste. Officia natus quibusdam dolores consectetur nobis ullam. Omnis atque ut labore rerum sit neque perspiciatis est. Rem et vero iure quod asperiores dolore. Quam officiis aperiam non aut aperiam occaecati aspernatur quam.

        Autem tempora rem necessitatibus tempora repellendus deleniti itaque. Sit voluptatem laboriosam neque. Vitae saepe iste quibusdam eum culpa.

        Qui rem adipisci eveniet recusandae eum impedit quisquam. Reprehenderit soluta molestiae nisi atque. Repellat delectus ipsum et iste vel. Excepturi voluptate quidem nulla blanditiis excepturi. Deleniti laudantium eveniet non occaecati.
        """
        
        let split = TextChunker.splitText(input: text, splits: ["."], maxLength: 512, overlap: 0)

        XCTAssertEqual([
            "Et magnam illum consectetur tenetur ratione Harum magnam voluptas eaque aut odit cumque nam eveniet Neque quo est aperiam at Nostrum unde sint rem Dolor repellendus excepturi dolores\n\nLaborum velit natus sed vel Ea earum ut aut dolore Vel dolorem in nihil et tenetur aspernatur ut Dicta non culpa natus est nesciunt Molestiae fugit aspernatur ullam numquam\n\nEnim est repellendus sit harum iste Officia natus quibusdam dolores consectetur nobis ullam Omnis atque ut labore rerum sit neque perspiciatis est",
            " Rem et vero iure quod asperiores dolore Quam officiis aperiam non aut aperiam occaecati aspernatur quam\n\nAutem tempora rem necessitatibus tempora repellendus deleniti itaque Sit voluptatem laboriosam neque Vitae saepe iste quibusdam eum culpa\n\nQui rem adipisci eveniet recusandae eum impedit quisquam Reprehenderit soluta molestiae nisi atque Repellat delectus ipsum et iste vel Excepturi voluptate quidem nulla blanditiis excepturi Deleniti laudantium eveniet non occaecati"
        ], split)
    }

}
