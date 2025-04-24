import UIKit

// MARK: - Router Input

protocol NewsRouterInput: AnyObject {
    func navigateToDetail(with url: URL)
}

class NewsRouter: NewsRouterInput {
    weak var viewController: UIViewController?
    
    static func assembleModule() -> UIViewController {
        let view = NewsViewController()
        let interactor = NewsInteractor()
        let presenter = NewsPresenter()
        let router = NewsRouter()
        
        view.presenter = presenter
        view.interactor = interactor
        view.router = router
        
        interactor.output = presenter
        presenter.view = view
        router.viewController = view
        
        return UINavigationController(rootViewController: view)
    }
    
    func navigateToDetail(with url: URL) {
        let detailVC = ArticleDetailViewController(url: url)
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
}
