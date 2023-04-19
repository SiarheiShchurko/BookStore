
import Foundation

final class DetailBookInfoVM: DetailBookInfoVMProtocol {
    
    weak var updateDelegate: ReloadUIProtocol?
  
    var networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol ) {
        self.networkService = networkService
    }
    
    func receiveBookRating(openLibraryWork: String) {
        networkService.getBookRating(openLibraryWork: openLibraryWork) { [ weak self ] (result) in
            // 1
            guard let self else {
                return
            }
            // 2
            switch result {
            case .successBookRating(let rating):
                self.updateDelegate?.reloadText?(data: rating.summary.average)
            case .error(error:):
                self.updateDelegate?.reloadText?(data: 0.0)
            default: break
            }
        }
    }
    
    func receiveCoverData(id: Int, sizeCover: SizeCovers) {
        networkService.getCoverData(id: id, coverSize: sizeCover) { [ weak self ] coverDataResult in
            // 1
            guard let self else {
                return
            }
            // 2
                switch coverDataResult {
                case .successData(let data):
                    self.updateDelegate?.reloadImage?(dataImage: data)
                case .error(error: let error):
                    self.updateDelegate?.sendError?(error: error)
                default: break
                }
            }
        }
    }

