import App
{{#mongo_native}}import MongoDBVapor{{/mongo_native}}
import Vapor

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)

let app = Application(env)
try configure(app)

defer {
    {{#mongo_native}}
    // Cleanup the application's MongoDB data.
    app.mongoDB.cleanup()
    // Clean up the driver's global state. The driver will no longer be usable from this program after this method is
    // called.
    cleanupMongoSwift()
    {{/mongo_native}}
    app.shutdown()
}

try app.run()
