
import Foundation
struct BookRatings: Decodable {
      let summary: Summary
  }
struct Summary: Decodable {
    let average: Double
}
