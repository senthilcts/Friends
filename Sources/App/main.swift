import Vapor
import VaporPostgreSQL

let drop = Droplet()
//let drop = Droplet(
//    preparations: [Friend.self],
//    providers: [VaporPostgreSQL.Provider.self]
//)
drop.preparations.append(Friend.self)

do {
    try drop.addProvider(VaporPostgreSQL.Provider.self)
} catch {
    print("Error adding provider: \(error)")
}

drop.get { req in
    return try drop.view.make("welcome", [
        "message": drop.localization[req.lang, "welcome", "title"] ])
}

drop.get("friends") { req in
    let friends = [Friend(name: "Sarah", age: 33, email:"sarah@email.com"),
                   Friend(name: "Steve", age: 31, email:"steve@email.com"),
                   Friend(name: "Drew", age: 35, email:"drew@email.com")]
    let friendsNode = try friends.makeNode()
    let nodeDictionary = ["friends": friendsNode]
    return try JSON(node: nodeDictionary)
}

drop.post("friend") { req in
    var friend = try Friend(node: req.json)
    try friend.save()
    return try friend.makeJSON()
}

drop.resource("posts", PostController())

drop.run()
