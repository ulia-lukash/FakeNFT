import Foundation

struct Nft {
    let createdAt: Date
    let name: String
    let images: [URL]
    let rating: Int
    let description: String
    let price: Double
    let author: String
    let id: String

    init(createdAt: String, name: String, id: String, images: [String], rating: Int, description: String, price: Double, author: String) {
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from: createdAt)!
        self.createdAt = date
        self.name = name
        self.id = id
        var imagesUrls: [URL] = []
        images.forEach { link in
            let url = URL(string: link)!
            imagesUrls.append(url)
        }
        self.images = imagesUrls
        self.rating = rating
        self.description = description
        self.price = price
        self.author = author
    }
}
