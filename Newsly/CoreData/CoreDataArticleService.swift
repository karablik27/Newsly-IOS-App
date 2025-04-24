import CoreData

protocol CoreDataArticleServiceProtocol {
    func fetchCachedArticles() -> [ArticleModel]
    func cacheArticles(_ articles: [ArticleModel])
}

class CoreDataArticleService: CoreDataArticleServiceProtocol {
    private let ctx = CoreDataStack.shared.context

    func fetchCachedArticles() -> [ArticleModel] {
        let req: NSFetchRequest<CDArticle> = CDArticle.fetchRequest()
        do {
            let cdItems = try ctx.fetch(req)
            return cdItems.map { cd in
                var model = ArticleModel(
                    newsId: Int(cd.newsId),
                    title: cd.title,
                    announce: cd.announce,
                    img: ImageContainer(url: URL(string: cd.imageURL ?? "")),
                    requestId: nil
                )
                if let urlString = cd.articleURL {
                    model.requestId = URLComponents(string: urlString)?
                        .queryItems?.first(where: { $0.name == "requestId" })?.value
                }
                return model
            }
        } catch {
            print("CoreData fetch error:", error)
            return []
        }
    }

    func cacheArticles(_ articles: [ArticleModel]) {
        let req: NSFetchRequest<NSFetchRequestResult> = CDArticle.fetchRequest()
        let del = NSBatchDeleteRequest(fetchRequest: req)
        do {
            try ctx.execute(del)
        } catch {
            print("CoreData delete error:", error)
        }
        for art in articles {
            let cd = CDArticle(context: ctx)
            cd.newsId     = Int64(art.newsId ?? 0)
            cd.title      = art.title
            cd.announce   = art.announce
            cd.imageURL   = art.imageURL?.absoluteString
            cd.articleURL = art.articleURL?.absoluteString
        }
        CoreDataStack.shared.saveContext()
    }
}
