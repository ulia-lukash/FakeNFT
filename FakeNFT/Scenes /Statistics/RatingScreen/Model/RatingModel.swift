import UIKit

final class RatingModel {
    // swiftlint:disable all
    private var mockUsersDB = [
        User(
            rating: "1",
            username: "Alex",
            nftAmount: "112",
            avatar: UIImage(named: "UserpickAlex")!,
            description: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям."),
        User(
            rating: "2",
            username: "Bill",
            nftAmount: "98",
            avatar: UIImage(named: "noAvatar")!,
            description: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям."),
        User(
            rating: "3",
            username: "Alla",
            nftAmount: "72",
            avatar: UIImage(named: "noAvatar")!,
            description: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям."),
        User(
            rating: "4",
            username: "Mads",
            nftAmount: "71",
            avatar: UIImage(named: "UserpickMads")!,
            description: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям."),
        User(
            rating: "5",
            username: "Timothèe",
            nftAmount: "51",
            avatar: UIImage(named: "UserpickTimon")!,
            description: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям."),
        User(rating: "6", username: "Lea", nftAmount: "23", avatar: UIImage(named: "UserpickLea")!, description: "Не дизайнер"),
        User(rating: "7", username: "Eric", nftAmount: "11", avatar: UIImage(named: "UserpickEric")!, description: "Я NFT"),
        User(rating: "8", username: "Somebody", nftAmount: "0", avatar: UIImage(named: "noAvatar")!, description: "Что происходит?")
    ]
    // swiftlint:enable all

    private let defaults = UserDefaults.standard

    func getUsers() -> [User] {
        if let sortType = defaults.string(forKey: "SortType") {
            switch sortType {
            case "byName":
                return sortUsersByName()
            case "byRating":
                return sortUsersByRating()
            default:
                return mockUsersDB
            }
        }
        return mockUsersDB
    }

    func sortUsersByName() -> [User] {
        defaults.set("byName", forKey: "SortType")
        let sortedUsersList = mockUsersDB.sorted {
            $0.username < $1.username
        }
        return sortedUsersList
    }

    func sortUsersByRating() -> [User] {
        defaults.set("byRating", forKey: "SortType")
        let sortedUsersList = mockUsersDB.sorted {
            $0.rating < $1.rating
        }
        return sortedUsersList
    }
}
