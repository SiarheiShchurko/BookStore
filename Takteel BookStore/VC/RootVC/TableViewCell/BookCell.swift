
import UIKit

final class BookCell: UITableViewCell {
    
    static let reusedId = "BookCell"
    
    var viewModel: RootViewModelProtocol = RootViewModel(networkService: NetworkService())
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?) {
        super.init(style: .default,
                   reuseIdentifier: BookCell.reusedId)
        
            viewModel.updateDelegate = self
            
            addSubview(coverImage)
            addSubview(bookName)
            addSubview(firstPublishYear)
            
        constraints()
    }
    required init?(coder: NSCoder) {
        fatalError("fatal Error")
    }
    
    // MARK: - Private properties
   let bookName: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    let firstPublishYear: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .systemGreen
        return label
    }()
    
    let coverImage: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
}

extension BookCell {
    func setBookCell(model: Works) {
        //
        bookName.text = model.title
        //
        viewModel.receiveCoverData(id: model.coverID, sizeCover: SizeCovers.S)
        //
        firstPublishYear.text = "\(model.firstPublishYear)"
    }
}

    private extension BookCell {
        func constraints() {
            NSLayoutConstraint.activate([
                //
                coverImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
                coverImage.widthAnchor.constraint(equalToConstant: 50),
                coverImage.heightAnchor.constraint(equalToConstant: 80),
                coverImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                //
                bookName.leadingAnchor.constraint(equalTo: self.coverImage.trailingAnchor, constant: 8),
                bookName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
                bookName.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                //
                firstPublishYear.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
                firstPublishYear.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4)
            ])
        }
    }

extension BookCell: ReloadUIProtocol {
    
    func reloadTableViewImage(tableViewImage: Data?) {
        if let data = tableViewImage {
            DispatchQueue.main.async {
                self.coverImage.image = UIImage(data: data)
            }
        }
    }
}
