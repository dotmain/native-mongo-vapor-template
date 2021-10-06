{{#mongo_native}}import MongoDBVapor{{/mongo_native}}
import Vapor

{{#mongo_native}}
/// A type matching the structure of documents in the corresponding MongoDB collection.
struct Kitten: Content {
    let _id: BSONObjectID?
    let name: String
    let color: String
    var createdAt: Date?
}

extension Request {
    /// Convenience accessor for the home.kittens collection.
    var kittenCollection: MongoCollection<Kitten> {
        self.mongoDB.client.db("home").collection("kittens", withType: Kitten.self)
    }
}{{/mongo_native}}

func routes(_ app: Application) throws {
    {{#mongo_native}}
    // A GET request will return a list of all kittens in the database.
    app.get { req -> EventLoopFuture<View> in
        req.kittenCollection.find().flatMap { cursor in
            cursor.toArray()
        }.flatMap { kittens in
            req.view.render("index.leaf", ["kittens": kittens])
        }
    }

    // A POST request will create a new kitten in the database.
    app.post { req -> EventLoopFuture<Response> in
        var newKitten = try req.content.decode(Kitten.self)
        newKitten.createdAt = Date()
        return req.kittenCollection.insertOne(newKitten)
            .map { _ in Response(status: .created) }
    }{{/mongo_native}}

    app.get("hello") { req -> String in
        return "Hello, world!"
    }
}
