
import UIKit

final class RootViewController: UIViewController {
    
    // MARK: - Private properties
    private var viewModel: RootViewModelProtocol
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 100
        tableView.register(BookCell.self, forCellReuseIdentifier: BookCell.reusedId)
        return tableView
    }()
    
    // MARK: - Init
    init(viewModel: RootViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil,
                   bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.viewModel = RootViewModel(networkService: NetworkService())
        super.init(coder: coder)
    }
    
    // MARK: - System methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1
        view.addSubview(tableView)
        // 2
        constraints()
        // 3
        title = "Books Library"
        // 4
        viewModel.updateDelegate = self
        // 5
        viewModel.receiveBooksList()
    }
}
// MARK: - Open Detail Info VC
private extension RootViewController {
    func openDetailBookInfoVC(bookProfile: Works) {
        // 1
       let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // 2
        guard let nextVC = storyboard.instantiateViewController(withIdentifier: "\(DetailBookInfoVC.self)") as? DetailBookInfoVC else { return }
        // 3
       nextVC.bookProfile = bookProfile
        // 4
       navigationController?.pushViewController(nextVC, animated: true)
    }
}

// MARK: - TableView delegate and dataSource
 extension RootViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        viewModel.booksArray.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(BookCell.self)", for: indexPath) as? BookCell
        cell?.setBookCell(model: viewModel.booksArray[indexPath.row])
        return cell ?? UITableViewCell()
    }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
         openDetailBookInfoVC(bookProfile: viewModel.booksArray[indexPath.row])
     }
}

// MARK: - Constraints
private extension RootViewController {
    func constraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
// MARK: - Reload TableView
extension RootViewController: ReloadUIProtocol {
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

