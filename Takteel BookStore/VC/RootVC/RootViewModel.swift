
import Foundation

final class RootViewModel: RootViewModelProtocol {
    
    var networkService: NetworkServiceProtocol

    var booksArray: [Works] = [] {
       didSet {
           updateDelegate?.reloadTableView!()
       }
   }
    weak var updateDelegate: ReloadUIProtocol?
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func receiveBooksList() {
        networkService.getBooksList { [ weak self ] (result) in
            guard let self else {
                return
            }
            switch result {
            case .successBookList(let element):
                self.booksArray = element.works
            default: break
            }
        }
    }
    func receiveCoverData(id: Int, sizeCover: SizeCovers) { networkService.getCoverData(id: id, coverSize: sizeCover) { [ weak self ] coverDataResult in
        // 1
        guard let self else {
            return
        }
        // 2
            switch coverDataResult {
            case .successData(let data):
                self.updateDelegate?.reloadTableViewImage?(tableViewImage: data)
            default: break
            }
        }
    }
}

