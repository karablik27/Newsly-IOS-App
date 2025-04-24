import Foundation

// MARK: - Presenter Input / Output
protocol NewsViewInput: AnyObject {
    func displayNews(_ viewModels: [NewsViewModel])
    func displayError(_ message: String)
}

protocol NewsPresentationLogic: AnyObject {
    func presentFetched(_ articles: [ArticleModel])
    func presentError(_ error: Error)
}

struct NewsViewModel {
    let title: String
    let description: String
    let imageURL: URL?
    let articleURL: URL?
}

class NewsPresenter: NewsPresentationLogic, NewsInteractorOutput {
    weak var view: NewsViewInput?

    // MARK: - NewsPresentationLogic
    func presentFetched(_ articles: [ArticleModel]) {
        let vms = articles.map {
            NewsViewModel(
                title: $0.title ?? "",
                description: $0.announce ?? "",
                imageURL: $0.imageURL,
                articleURL: $0.articleURL 
            )
        }
        view?.displayNews(vms)
    }

    func presentError(_ error: Error) {
        view?.displayError(error.localizedDescription)
    }

    // MARK: - NewsInteractorOutput
    func newsFetched(_ articles: [ArticleModel]) {
        presentFetched(articles)
    }

    func newsFetchFailed(_ error: Error) {
        presentError(error)
    }
}
