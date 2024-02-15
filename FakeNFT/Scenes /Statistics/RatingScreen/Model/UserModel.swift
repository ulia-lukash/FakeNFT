import UIKit

final class UserModel {
    // swiftlint:disable force_unwrapping
    private var mockUsersDB = [
        User(rating: "1", username: "Alex", nftAmount: "112", avatar: UIImage(named: "UserpickAlex")!),
        User(rating: "2", username: "Bill", nftAmount: "98", avatar: UIImage(named: "noAvatar")!),
        User(rating: "3", username: "Alla", nftAmount: "72", avatar: UIImage(named: "noAvatar")!),
        User(rating: "4", username: "Mads", nftAmount: "71", avatar: UIImage(named: "UserpickMads")!),
        User(rating: "5", username: "Timothèe", nftAmount: "51", avatar: UIImage(named: "UserpickTimon")!),
        User(rating: "6", username: "Lea", nftAmount: "23", avatar: UIImage(named: "UserpickLea")!),
        User(rating: "7", username: "Eric", nftAmount: "11", avatar: UIImage(named: "UserpickEric")!),
        User(rating: "8", username: "Somebody", nftAmount: "0", avatar: UIImage(named: "noAvatar")!)
    ]
    // swiftlint:enable force_unwrapping


    func getUsers() -> [User] {
        mockUsersDB
    }

    func sortUsersByName() -> [User] {
        let sortedUsersList = mockUsersDB.sorted {
            $0.username < $1.username
        }
        return sortedUsersList
    }

    func sortUsersByRating() -> [User] {
        let sortedUsersList = mockUsersDB.sorted {
            $0.rating < $1.rating
        }
        return sortedUsersList
    }
}
