import Foundation

// MARK: - Interactor Input / Output
protocol NewsInteractorInput: AnyObject {
    func fetchNews()
}

protocol NewsInteractorOutput: AnyObject {
    func newsFetched(_ articles: [ArticleModel])
    func newsFetchFailed(_ error: Error)
}

class NewsInteractor: NewsInteractorInput {
    weak var output: NewsInteractorOutput?
    private let service: NewsServiceProtocol
    private let cacheService: CoreDataArticleServiceProtocol
    private(set) var articles: [ArticleModel] = []

    init(service: NewsServiceProtocol = NewsService(),
         cacheService: CoreDataArticleServiceProtocol = CoreDataArticleService()) {
        self.service = service
        self.cacheService = cacheService
    }

    func fetchNews() {
        let cached = cacheService.fetchCachedArticles()
        if !cached.isEmpty {
            articles = cached
            output?.newsFetched(cached)
        }

        service.fetchArticles { [weak self] result in
            switch result {
            case .success(let items):
                self?.articles = items
                self?.cacheService.cacheArticles(items)
                self?.output?.newsFetched(items)
            case .failure(let error):
                if cached.isEmpty {
                    self?.output?.newsFetchFailed(error)
                }
            }
        }
    }
}

