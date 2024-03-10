import UIKit

final class RatingModel {

    static let shared = RatingModel()

    private var usersDB: [User] = []
    private var storage: [String: UserData] = [:]

    private let defaults = UserDefaults.standard

    func saveUsers(users: [UserData]) {
        usersDB = users.map {
            convert(userData: $0)
        }
    }

    func getUsers() -> [User] {
        if let sortType = defaults.string(forKey: "SortType") {
            switch sortType {
            case "byName":
                return sortUsersByName()
            case "byRating":
                return sortUsersByRating()
            default:
                return usersDB
            }
        }
        return usersDB
    }

    func sortUsersByName() -> [User] {
        defaults.set("byName", forKey: "SortType")
        let sortedUsersList = usersDB.sorted {
            $0.username < $1.username
        }
        return sortedUsersList
    }

    func sortUsersByRating() -> [User] {
        defaults.set("byRating", forKey: "SortType")
        let sortedUsersList = usersDB.sorted {
            $0.rating < $1.rating
        }
        return sortedUsersList
    }
}

extension RatingModel {
    func convert(userData: UserData) -> User {
        return User(
            rating: Int(userData.rating) ?? 0,
            username: userData.name,
            nfts: userData.nfts,
            avatar: userData.avatar,
            description: userData.description,
            website: userData.website
        )
    }
}
