
import Foundation

protocol RootViewModelProtocol: ViewModelProtocol {
    func receiveBooksList()
    var booksArray: [Works] { get }
}
