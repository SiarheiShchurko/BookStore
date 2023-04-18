
import UIKit

final class DetailBookInfoVC: UIViewController {
    
    var bookProfile: Works?
    var viewModel: DetailBookInfoVMProtocol
    
    // MARK: - Private properties
    
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private lazy var titlePage: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .black)
        label.numberOfLines = 0
        return label
    }()
    private lazy var loadIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        indicator.isHidden = false
        return indicator
    }()
    private lazy var firstYearPublished: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    private lazy var bookDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Description"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    private lazy var bookDescription: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.showsVerticalScrollIndicator = false
        textView.isEditable = false
        textView.isScrollEnabled = true
        return textView
    }()
    private lazy var bookRating: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        label.numberOfLines = 0
        return label
    }()
    // MARK: - Init
    init(viewModel: DetailBookInfoVMProtocol) {
        self.viewModel = viewModel
     super.init(nibName: nil,
                bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = DetailBookInfoVM(networkService: NetworkService())
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1
        addViewToSuperView()
        // 2
        loadData()
        // 3
        constraints()
    }
}
// MARK: - Custom methods
private extension DetailBookInfoVC {
    //
    func addViewToSuperView() {
        view.addSubview(coverImageView)
        view.addSubview(titlePage)
        view.addSubview(firstYearPublished)
        view.addSubview(bookDescriptionLabel)
        view.addSubview(bookDescription)
        view.addSubview(bookRating)
        coverImageView.addSubview(loadIndicator)
       
    }
    func loadData() {
        // TitlePage
        titlePage.text = bookProfile?.title
        if bookProfile?.firstPublishYear != nil {
            firstYearPublished.text = "First published year: \(bookProfile!.firstPublishYear)"
        }
        // Description
        if bookProfile?.subject != nil {
            bookDescription.text = bookProfile!.subject.joined(separator: " ")
        }
        // Cover
        viewModel.networkService.getCoverData(id: bookProfile?.coverID ?? 0, coverSize: .L) { [ weak self ] (result) in
            guard let self else {
                return
            }
            switch result {
            case .successData(let data):
                DispatchQueue.main.async {
                    self.coverImageView.image = UIImage(data: data)
                    self.loadIndicator.stopAnimating()
                    self.loadIndicator.isHidden = true
                }
            case .error(error:):
                DispatchQueue.main.async {
                    self.coverImageView.image = UIImage(systemName: "Book.fill")
                    self.loadIndicator.stopAnimating()
                    self.loadIndicator.isHidden = true
                }
            default: break
            }
        }
        // Load rating
        viewModel.networkService.getBookRating(openLibraryWork: bookProfile?.availability.openLibraryWork ?? String()) { [ weak self ] (result) in
            guard let self else {
                return
            }
            switch result {
            case .successBookRating(let rating):
                DispatchQueue.main.async {
                    self.bookRating.text = "Rating: \(round(rating.summary.average * 100) / 100 )"
                }
            default: DispatchQueue.main.async {
                self.bookRating.text = "Rating: -"
            }
            }
        }
    }
}
// MARK: - Constraints
private extension DetailBookInfoVC {
    func constraints() {
        NSLayoutConstraint.activate([
            // Title Page
            titlePage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titlePage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titlePage.leadingAnchor.constraint(equalTo: coverImageView.leadingAnchor),
            titlePage.trailingAnchor.constraint(equalTo: coverImageView.trailingAnchor),
            
            // Cover ImageView
            coverImageView.topAnchor.constraint(equalTo: titlePage.bottomAnchor, constant: 8),
            coverImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            coverImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            coverImageView.bottomAnchor.constraint(equalTo: view.centerYAnchor),
            
            //
            loadIndicator.centerXAnchor.constraint(equalTo: coverImageView.centerXAnchor),
            loadIndicator.centerYAnchor.constraint(equalTo: coverImageView.centerYAnchor),
            
            // Rating
            bookRating.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 8),
            bookRating.leadingAnchor.constraint(equalTo: coverImageView.leadingAnchor),
            
            // Title
            firstYearPublished.topAnchor.constraint(equalTo: bookRating.bottomAnchor, constant: 4),
            firstYearPublished.leadingAnchor.constraint(equalTo: coverImageView.leadingAnchor),
            firstYearPublished.trailingAnchor.constraint(equalTo: coverImageView.trailingAnchor),
            
            // DescriptionLabel
            bookDescriptionLabel.topAnchor.constraint(equalTo: firstYearPublished.bottomAnchor, constant: 24),
            bookDescriptionLabel.leadingAnchor.constraint(equalTo: coverImageView.leadingAnchor),
            bookDescriptionLabel.trailingAnchor.constraint(equalTo: coverImageView.trailingAnchor),
            
            // Description
            bookDescription.topAnchor.constraint(equalTo: bookDescriptionLabel.bottomAnchor, constant: 8),
            bookDescription.leadingAnchor.constraint(equalTo: coverImageView.leadingAnchor),
            bookDescription.trailingAnchor.constraint(equalTo: coverImageView.trailingAnchor),
            bookDescription.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

