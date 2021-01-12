import NIO

public protocol Templating {
    func loadTemplate(named name: String) throws -> EventLoopFuture<Template>
    func loadTemplate(at path: String) throws -> EventLoopFuture<Template>
    func renderTemplate(named name: String, context: [String: Encodable]) throws -> EventLoopFuture<String>
    func renderTemplate(at path: String, context: [String: Encodable]) throws -> EventLoopFuture<String>
    func renderTemplate(_ template: Template, context: [String: Encodable]) throws -> EventLoopFuture<String>
}

extension Templating {
    public func renderTemplate(named name: String) throws -> EventLoopFuture<String> {
        try renderTemplate(named: name, context: .init())
    }

    public func renderTemplate(at path: String) throws -> EventLoopFuture<String> {
        try renderTemplate(at: path, context: .init())
    }

    public func renderTemplate(_ template: Template) throws -> EventLoopFuture<String> {
        try renderTemplate(template, context: .init())
    }
}
