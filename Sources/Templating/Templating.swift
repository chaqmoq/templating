import NIO
import struct Yaproq.Template

public protocol Templating {
    func loadTemplate(named name: String, on eventLoop: EventLoop) throws -> EventLoopFuture<Template>

    func loadTemplate(at path: String, on eventLoop: EventLoop) throws -> EventLoopFuture<Template>

    func renderTemplate(
        named name: String,
        in context: [String: Encodable],
        on eventLoop: EventLoop
    ) throws -> EventLoopFuture<String>

    func renderTemplate(
        at path: String,
        in context: [String: Encodable],
        on eventLoop: EventLoop
    ) throws -> EventLoopFuture<String>

    func renderTemplate(
        _ template: Template,
        in context: [String: Encodable],
        on eventLoop: EventLoop
    ) throws -> String
}

extension Templating {
    public func renderTemplate(named name: String, on eventLoop: EventLoop) throws -> EventLoopFuture<String> {
        try renderTemplate(named: name, in: .init(), on: eventLoop)
    }

    public func renderTemplate(at path: String, on eventLoop: EventLoop) throws -> EventLoopFuture<String> {
        try renderTemplate(at: path, in: .init(), on: eventLoop)
    }

    public func renderTemplate(_ template: Template, on eventLoop: EventLoop) throws -> String {
        try renderTemplate(template, in: .init(), on: eventLoop)
    }
}
