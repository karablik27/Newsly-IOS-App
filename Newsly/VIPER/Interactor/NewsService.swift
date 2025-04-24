import Foundation

protocol NewsServiceProtocol {
    func fetchArticles(completion: @escaping (Result<[ArticleModel], Error>) -> Void)
}

class NewsService: NewsServiceProtocol {
    func fetchArticles(completion: @escaping (Result<[ArticleModel], Error>) -> Void) {
        let urlString = "https://news.myseldon.com/api/Section?rubricId=4&pageSize=8&pageIndex=1"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Bad URL", code: -1, userInfo: nil)))
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let e = error {
                DispatchQueue.main.async { completion(.failure(e)) }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "No data", code: -2, userInfo: nil)))
                }
                return
            }
            do {
                var page = try JSONDecoder().decode(NewsPage.self, from: data)
                page.passTheRequestId()
                let items = page.news ?? []
                DispatchQueue.main.async { completion(.success(items)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }.resume()
    }
}
