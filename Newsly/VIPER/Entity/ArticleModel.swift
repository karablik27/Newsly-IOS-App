import Foundation

struct ArticleModel: Decodable {
    let newsId: Int?
    let title: String?
    let announce: String?
    let img: ImageContainer?
    var requestId: String?
    
    var imageURL: URL? { img?.url }
    var articleURL: URL? {
        guard let id = newsId else { return nil }
        let req = requestId ?? ""
        return URL(string: "https://news.myseldon.com/ru/news/index/\(id)?requestId=\(req)")
    }
}
