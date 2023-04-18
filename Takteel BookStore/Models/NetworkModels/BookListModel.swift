
import Foundation

struct BookListModel: Decodable {
    let works: [Works]
    
    enum SubjectCodingKeys: String, CodingKey {
        case works
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SubjectCodingKeys.self)
        self.works = try container.decode([Works].self, forKey: .works)
    }
}
struct Works: Decodable {
    let key: String
    let title: String
    let editionCount: Int
    let coverID: Int
    let coverEditionKey: String
    let subject: [String]
    let firstPublishYear: Int
    let availability: Availability

    enum WorksCodingKeys: String, CodingKey {
        case key
        case title
        case editionCount = "edition_count"
        case coverID = "cover_id"
        case coverEditionKey = "cover_edition_key"
        case subject
        case firstPublishYear = "first_publish_year"
        case availability
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: WorksCodingKeys.self)
        self.key = try container.decode(String.self, forKey: .key)
        self.title = try container.decode(String.self, forKey: .title)
        self.editionCount = try container.decode(Int.self, forKey: .editionCount)
        self.coverID = try container.decode(Int.self, forKey: .coverID)
        self.coverEditionKey = try container.decode(String.self, forKey: .coverEditionKey)
        self.subject = try container.decode([String].self, forKey: .subject)
        self.firstPublishYear = try container.decode(Int.self, forKey: .firstPublishYear)
        self.availability = try container.decode(Availability.self, forKey: .availability)
    }
}

struct Availability: Decodable {
    let openLibraryWork: String

    enum AvailabilityCodingKeys: String, CodingKey {
        case openLibraryWork = "openlibrary_work"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AvailabilityCodingKeys.self)
        self.openLibraryWork = try container.decode(String.self, forKey: .openLibraryWork)
    }
}

