
import UIKit

protocol NetworkServiceProtocol: AnyObject {
    func getBooksList(complition: @escaping(NetworkServiceResult) -> Void)
    func getCoverData(id: Int, coverSize: SizeCovers, complition: @escaping(NetworkServiceResult) -> Void)
    func getBookRating(openLibraryWork: String, complition: @escaping(NetworkServiceResult) -> Void)
}
