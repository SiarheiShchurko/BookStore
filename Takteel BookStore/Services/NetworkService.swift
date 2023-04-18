import Foundation

// MARK: - NetworkService result working enum
enum NetworkServiceResult {
    case successBookList(BookListModel)
    case successBookRating(BookRatings)
    case successData(Data)
    case error(error: Error)
}

final class NetworkService: NetworkServiceProtocol {
    private let decoder = JSONDecoder()
    private let requestType = "GET"
    
    
    func getBooksList(complition: @escaping(NetworkServiceResult) -> Void) {
        // 1
        guard let url = URL(string: "https://openlibrary.org/subjects/fantasy.json") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = requestType
        // 2
        URLSession.shared.dataTask(with: request) { [ weak self ] (data, response, error) in
            // 3
            if let error {
                complition(NetworkServiceResult.error(error: error))
                // 4
            } else if let data,
                      let self {
                // 5
                do {
                    let bookList = try self.decoder.decode(BookListModel.self, from: data)
                    DispatchQueue.main.async {
                        complition(NetworkServiceResult.successBookList(bookList))
                    }
                } catch {
                    complition(NetworkServiceResult.error(error: error))
                }
            }
            // 6
        }.resume()
    }
    
    func getCoverData(id: Int, coverSize sizeCover: SizeCovers, complition: @escaping(NetworkServiceResult) -> Void)  {
        // 1
        URLSession.shared.dataTask(with: URL(string: "https://covers.openlibrary.org/b/id/\(id)-\(sizeCover).jpg")!) { data, response, error in
            // 2
            if let error = error  {
                complition(.error(error: error))
            } else if let data {
                complition(NetworkServiceResult.successData(data))
            }
            // 3
        }.resume()
    }
    
    func getBookRating(openLibraryWork: String, complition: @escaping(NetworkServiceResult) -> Void)  {
        URLSession.shared.dataTask(with: URL(string: "https://openlibrary.org/works/\(openLibraryWork)/ratings.json")!) { [ weak self ] (data, response, error) in
            // 2
            if let error = error {
                complition(.error(error: error))
            } else if let data,
                      let self {
                do {
                    let bookRating = try self.decoder.decode(BookRatings.self, from: data)
                    
                    DispatchQueue.main.async {
                        complition(NetworkServiceResult.successBookRating(bookRating))
                    }
                } catch {
                    print(error.localizedDescription)
                    complition(NetworkServiceResult.error(error: error))
                }
            }
            // 3
        }.resume()
    }
}


