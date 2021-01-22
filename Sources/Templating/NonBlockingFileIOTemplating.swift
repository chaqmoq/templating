import NIO
import Yaproq

public final class NonBlockingFileIOTemplating: Templating {
    public let eventLoopGroup: EventLoopGroup
    let threadPool: NIOThreadPool = {
        let threadPool = NIOThreadPool(numberOfThreads: 1)
        threadPool.start()
        return threadPool
    }()
    let fileIO: NonBlockingFileIO
    private let templating: Yaproq

    public init(configuration: Yaproq.Configuration, eventLoopGroup: EventLoopGroup) throws {
        templating = Yaproq(configuration: configuration)
        self.eventLoopGroup = eventLoopGroup
        fileIO = NonBlockingFileIO(threadPool: threadPool)
    }

    public func loadTemplate(named name: String, on eventLoop: EventLoop) throws -> EventLoopFuture<Template> {
        try loadTemplate(at: templating.configuration.directoryPath + name, on: eventLoop)
    }

    public func loadTemplate(at filePath: String, on eventLoop: EventLoop) throws -> EventLoopFuture<Template> {
        threadPool.runIfActive(eventLoop: eventLoop) { () -> Template in
            let fileHandle: NIOFileHandle
            do { fileHandle = try NIOFileHandle(path: filePath) }
            catch { return "" }

            let result = try self.fileIO.read(
                fileRegion: try FileRegion(fileHandle: fileHandle),
                allocator: ByteBufferAllocator(),
                eventLoop: eventLoop
            ).map { (byteBuffer) -> Template in
                if let bytes = byteBuffer.getBytes(at: 0, length: byteBuffer.readableBytes) {
                    return Template(String(bytes: bytes, encoding: .utf8) ?? "", filePath: filePath)
                }

                return ""
            }.wait()

            try fileHandle.close()

            return result
        }
    }

    public func renderTemplate(
        named name: String,
        in context: [String: Encodable],
        on eventLoop: EventLoop
    ) throws -> EventLoopFuture<String> {
        try renderTemplate(at: templating.configuration.directoryPath + name, in: context, on: eventLoop)
    }

    public func renderTemplate(
        at path: String,
        in context: [String: Encodable],
        on eventLoop: EventLoop
    ) throws -> EventLoopFuture<String> {
        try loadTemplate(at: path, on: eventLoop).flatMapThrowing { (template) -> String in
            try self.renderTemplate(template, in: context, on: eventLoop)
        }
    }

    public func renderTemplate(
        _ template: Template,
        in context: [String: Encodable],
        on eventLoop: EventLoop
    ) throws -> String {
        try templating.renderTemplate(template, in: context)
    }
}
