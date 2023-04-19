
import Foundation

protocol ViewModelProtocol {
    func receiveCoverData(id: Int, sizeCover: SizeCovers)
    var networkService: NetworkServiceProtocol { get set }
    var updateDelegate: ReloadUIProtocol? { get set }
}
