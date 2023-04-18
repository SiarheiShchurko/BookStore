
import Foundation

protocol RootViewModelProtocol: AnyObject {
    func receiveBooksList()
    func receiveCoverData(id: Int, sizeCover: SizeCovers)
    var networkService: NetworkServiceProtocol { get set }
    var booksArray: [Works] { get }
    var updateUIDelegate: ReloadUIProtocol? { get set }
}
