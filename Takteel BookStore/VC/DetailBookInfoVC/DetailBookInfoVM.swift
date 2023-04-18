
import Foundation

final class DetailBookInfoVM: DetailBookInfoVMProtocol {
    
    let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol ) {
        self.networkService = networkService
    }
}
