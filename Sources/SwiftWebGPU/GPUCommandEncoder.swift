import JavaScriptKit

/// A GPU command encoder for recording GPU commands.
///
/// ```swift
/// let encoder = device.createCommandEncoder()
/// let renderPass = encoder.beginRenderPass(descriptor: renderPassDescriptor)
/// renderPass.setPipeline(pipeline)
/// renderPass.draw(vertexCount: 3)
/// renderPass.end()
/// let commandBuffer = encoder.finish()
/// device.queue.submit([commandBuffer])
/// ```
public final class GPUCommandEncoder: @unchecked Sendable {
    /// The underlying JavaScript `GPUCommandEncoder` object.
    let jsObject: JSObject

    init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    /// The label of this command encoder.
    public var label: String? {
        get { jsObject.label.string }
        set {
            if let newValue = newValue {
                jsObject.label = .string(newValue)
            } else {
                jsObject.label = .null
            }
        }
    }

    /// Begins a render pass.
    public func beginRenderPass(descriptor: GPURenderPassDescriptor) -> GPURenderPassEncoder {
        let jsEncoder = jsObject.beginRenderPass!(descriptor.toJSObject()).object!
        return GPURenderPassEncoder(jsObject: jsEncoder)
    }

    /// Begins a compute pass.
    public func beginComputePass(descriptor: GPUComputePassDescriptor? = nil) -> GPUComputePassEncoder {
        let jsEncoder: JSObject
        if let descriptor = descriptor {
            jsEncoder = jsObject.beginComputePass!(descriptor.toJSObject()).object!
        } else {
            jsEncoder = jsObject.beginComputePass!().object!
        }
        return GPUComputePassEncoder(jsObject: jsEncoder)
    }

    /// Copies data between buffers.
    public func copyBufferToBuffer(
        source: GPUBuffer,
        sourceOffset: UInt64,
        destination: GPUBuffer,
        destinationOffset: UInt64,
        size: UInt64
    ) {
        _ = jsObject.copyBufferToBuffer!(
            source.jsObject,
            Double(sourceOffset),
            destination.jsObject,
            Double(destinationOffset),
            Double(size)
        )
    }

    /// Copies data from a buffer to a texture.
    public func copyBufferToTexture(
        source: GPUImageCopyBuffer,
        destination: GPUImageCopyTexture,
        copySize: GPUExtent3D
    ) {
        _ = jsObject.copyBufferToTexture!(
            source.toJSObject(),
            destination.toJSObject(),
            copySize.toJSValue()
        )
    }

    /// Copies data from a texture to a buffer.
    public func copyTextureToBuffer(
        source: GPUImageCopyTexture,
        destination: GPUImageCopyBuffer,
        copySize: GPUExtent3D
    ) {
        _ = jsObject.copyTextureToBuffer!(
            source.toJSObject(),
            destination.toJSObject(),
            copySize.toJSValue()
        )
    }

    /// Copies data between textures.
    public func copyTextureToTexture(
        source: GPUImageCopyTexture,
        destination: GPUImageCopyTexture,
        copySize: GPUExtent3D
    ) {
        _ = jsObject.copyTextureToTexture!(
            source.toJSObject(),
            destination.toJSObject(),
            copySize.toJSValue()
        )
    }

    /// Clears a buffer.
    public func clearBuffer(buffer: GPUBuffer, offset: UInt64 = 0, size: UInt64? = nil) {
        if let size = size {
            _ = jsObject.clearBuffer!(buffer.jsObject, Double(offset), Double(size))
        } else {
            _ = jsObject.clearBuffer!(buffer.jsObject, Double(offset))
        }
    }

    /// Resolves a query set.
    public func resolveQuerySet(
        querySet: GPUQuerySet,
        firstQuery: UInt32,
        queryCount: UInt32,
        destination: GPUBuffer,
        destinationOffset: UInt64
    ) {
        _ = jsObject.resolveQuerySet!(
            querySet.jsObject,
            Double(firstQuery),
            Double(queryCount),
            destination.jsObject,
            Double(destinationOffset)
        )
    }

    /// Inserts a debug marker.
    public func insertDebugMarker(markerLabel: String) {
        _ = jsObject.insertDebugMarker!(markerLabel)
    }

    /// Pushes a debug group.
    public func pushDebugGroup(groupLabel: String) {
        _ = jsObject.pushDebugGroup!(groupLabel)
    }

    /// Pops a debug group.
    public func popDebugGroup() {
        _ = jsObject.popDebugGroup!()
    }

    /// Finishes recording and returns a command buffer.
    public func finish(descriptor: GPUCommandBufferDescriptor? = nil) -> GPUCommandBuffer {
        let jsBuffer: JSObject
        if let descriptor = descriptor {
            jsBuffer = jsObject.finish!(descriptor.toJSObject()).object!
        } else {
            jsBuffer = jsObject.finish!().object!
        }
        return GPUCommandBuffer(jsObject: jsBuffer)
    }
}

// MARK: - GPUCommandEncoderDescriptor

/// Descriptor for creating a command encoder.
public struct GPUCommandEncoderDescriptor: Sendable {
    /// A label for the command encoder.
    public var label: String?

    public init(label: String? = nil) {
        self.label = label
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        if let label = label {
            obj.label = .string(label)
        }
        return obj
    }
}

// MARK: - GPUCommandBuffer

/// A GPU command buffer containing recorded commands.
public final class GPUCommandBuffer: @unchecked Sendable {
    /// The underlying JavaScript `GPUCommandBuffer` object.
    let jsObject: JSObject

    init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    /// The label of this command buffer.
    public var label: String? {
        get { jsObject.label.string }
        set {
            if let newValue = newValue {
                jsObject.label = .string(newValue)
            } else {
                jsObject.label = .null
            }
        }
    }
}

// MARK: - GPUCommandBufferDescriptor

/// Descriptor for finishing a command buffer.
public struct GPUCommandBufferDescriptor: Sendable {
    /// A label for the command buffer.
    public var label: String?

    public init(label: String? = nil) {
        self.label = label
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        if let label = label {
            obj.label = .string(label)
        }
        return obj
    }
}

// MARK: - GPURenderPassDescriptor

/// Descriptor for beginning a render pass.
public struct GPURenderPassDescriptor: Sendable {
    /// The color attachments.
    public var colorAttachments: [GPURenderPassColorAttachment?]

    /// The depth/stencil attachment.
    public var depthStencilAttachment: GPURenderPassDepthStencilAttachment?

    /// The occlusion query set.
    public var occlusionQuerySet: GPUQuerySet?

    /// The timestamp writes.
    public var timestampWrites: GPURenderPassTimestampWrites?

    /// The maximum draw count for indirect draws.
    public var maxDrawCount: UInt64

    /// A label for the render pass.
    public var label: String?

    public init(
        colorAttachments: [GPURenderPassColorAttachment?],
        depthStencilAttachment: GPURenderPassDepthStencilAttachment? = nil,
        occlusionQuerySet: GPUQuerySet? = nil,
        timestampWrites: GPURenderPassTimestampWrites? = nil,
        maxDrawCount: UInt64 = 50_000_000,
        label: String? = nil
    ) {
        self.colorAttachments = colorAttachments
        self.depthStencilAttachment = depthStencilAttachment
        self.occlusionQuerySet = occlusionQuerySet
        self.timestampWrites = timestampWrites
        self.maxDrawCount = maxDrawCount
        self.label = label
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()

        let colorsArray = JSObject.global.Array.function!.new()
        for (index, attachment) in colorAttachments.enumerated() {
            if let attachment = attachment {
                colorsArray[index] = attachment.toJSObject().jsValue
            } else {
                colorsArray[index] = .null
            }
        }
        obj.colorAttachments = colorsArray.jsValue

        if let depthStencilAttachment = depthStencilAttachment {
            obj.depthStencilAttachment = depthStencilAttachment.toJSObject().jsValue
        }
        if let occlusionQuerySet = occlusionQuerySet {
            obj.occlusionQuerySet = occlusionQuerySet.jsObject.jsValue
        }
        if let timestampWrites = timestampWrites {
            obj.timestampWrites = timestampWrites.toJSObject().jsValue
        }
        obj.maxDrawCount = .number(Double(maxDrawCount))
        if let label = label {
            obj.label = .string(label)
        }
        return obj
    }
}

// MARK: - GPURenderPassColorAttachment

/// A color attachment for a render pass.
public struct GPURenderPassColorAttachment: Sendable {
    /// The texture view to render to.
    public var view: GPUTextureView

    /// The texture view to resolve to.
    public var resolveTarget: GPUTextureView?

    /// The clear value.
    public var clearValue: GPUColor?

    /// The load operation.
    public var loadOp: GPULoadOp

    /// The store operation.
    public var storeOp: GPUStoreOp

    public init(
        view: GPUTextureView,
        resolveTarget: GPUTextureView? = nil,
        clearValue: GPUColor? = nil,
        loadOp: GPULoadOp,
        storeOp: GPUStoreOp
    ) {
        self.view = view
        self.resolveTarget = resolveTarget
        self.clearValue = clearValue
        self.loadOp = loadOp
        self.storeOp = storeOp
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        obj.view = view.jsObject.jsValue
        if let resolveTarget = resolveTarget {
            obj.resolveTarget = resolveTarget.jsObject.jsValue
        }
        if let clearValue = clearValue {
            obj.clearValue = clearValue.toJSValue()
        }
        obj.loadOp = .string(loadOp.rawValue)
        obj.storeOp = .string(storeOp.rawValue)
        return obj
    }
}

// MARK: - GPURenderPassDepthStencilAttachment

/// A depth/stencil attachment for a render pass.
public struct GPURenderPassDepthStencilAttachment: Sendable {
    /// The texture view.
    public var view: GPUTextureView

    /// The depth clear value.
    public var depthClearValue: Float?

    /// The depth load operation.
    public var depthLoadOp: GPULoadOp?

    /// The depth store operation.
    public var depthStoreOp: GPUStoreOp?

    /// Whether depth is read-only.
    public var depthReadOnly: Bool

    /// The stencil clear value.
    public var stencilClearValue: UInt32

    /// The stencil load operation.
    public var stencilLoadOp: GPULoadOp?

    /// The stencil store operation.
    public var stencilStoreOp: GPUStoreOp?

    /// Whether stencil is read-only.
    public var stencilReadOnly: Bool

    public init(
        view: GPUTextureView,
        depthClearValue: Float? = nil,
        depthLoadOp: GPULoadOp? = nil,
        depthStoreOp: GPUStoreOp? = nil,
        depthReadOnly: Bool = false,
        stencilClearValue: UInt32 = 0,
        stencilLoadOp: GPULoadOp? = nil,
        stencilStoreOp: GPUStoreOp? = nil,
        stencilReadOnly: Bool = false
    ) {
        self.view = view
        self.depthClearValue = depthClearValue
        self.depthLoadOp = depthLoadOp
        self.depthStoreOp = depthStoreOp
        self.depthReadOnly = depthReadOnly
        self.stencilClearValue = stencilClearValue
        self.stencilLoadOp = stencilLoadOp
        self.stencilStoreOp = stencilStoreOp
        self.stencilReadOnly = stencilReadOnly
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        obj.view = view.jsObject.jsValue
        if let depthClearValue = depthClearValue {
            obj.depthClearValue = .number(Double(depthClearValue))
        }
        if let depthLoadOp = depthLoadOp {
            obj.depthLoadOp = .string(depthLoadOp.rawValue)
        }
        if let depthStoreOp = depthStoreOp {
            obj.depthStoreOp = .string(depthStoreOp.rawValue)
        }
        obj.depthReadOnly = .boolean(depthReadOnly)
        obj.stencilClearValue = .number(Double(stencilClearValue))
        if let stencilLoadOp = stencilLoadOp {
            obj.stencilLoadOp = .string(stencilLoadOp.rawValue)
        }
        if let stencilStoreOp = stencilStoreOp {
            obj.stencilStoreOp = .string(stencilStoreOp.rawValue)
        }
        obj.stencilReadOnly = .boolean(stencilReadOnly)
        return obj
    }
}

// MARK: - GPURenderPassTimestampWrites

/// Timestamp writes for a render pass.
public struct GPURenderPassTimestampWrites: Sendable {
    /// The query set.
    public var querySet: GPUQuerySet

    /// The index for the beginning timestamp.
    public var beginningOfPassWriteIndex: UInt32?

    /// The index for the end timestamp.
    public var endOfPassWriteIndex: UInt32?

    public init(
        querySet: GPUQuerySet,
        beginningOfPassWriteIndex: UInt32? = nil,
        endOfPassWriteIndex: UInt32? = nil
    ) {
        self.querySet = querySet
        self.beginningOfPassWriteIndex = beginningOfPassWriteIndex
        self.endOfPassWriteIndex = endOfPassWriteIndex
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        obj.querySet = querySet.jsObject.jsValue
        if let beginningOfPassWriteIndex = beginningOfPassWriteIndex {
            obj.beginningOfPassWriteIndex = .number(Double(beginningOfPassWriteIndex))
        }
        if let endOfPassWriteIndex = endOfPassWriteIndex {
            obj.endOfPassWriteIndex = .number(Double(endOfPassWriteIndex))
        }
        return obj
    }
}

// MARK: - GPUComputePassDescriptor

/// Descriptor for beginning a compute pass.
public struct GPUComputePassDescriptor: Sendable {
    /// Timestamp writes for the pass.
    public var timestampWrites: GPUComputePassTimestampWrites?

    /// A label for the compute pass.
    public var label: String?

    public init(
        timestampWrites: GPUComputePassTimestampWrites? = nil,
        label: String? = nil
    ) {
        self.timestampWrites = timestampWrites
        self.label = label
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        if let timestampWrites = timestampWrites {
            obj.timestampWrites = timestampWrites.toJSObject().jsValue
        }
        if let label = label {
            obj.label = .string(label)
        }
        return obj
    }
}

// MARK: - GPUComputePassTimestampWrites

/// Timestamp writes for a compute pass.
public struct GPUComputePassTimestampWrites: Sendable {
    /// The query set.
    public var querySet: GPUQuerySet

    /// The index for the beginning timestamp.
    public var beginningOfPassWriteIndex: UInt32?

    /// The index for the end timestamp.
    public var endOfPassWriteIndex: UInt32?

    public init(
        querySet: GPUQuerySet,
        beginningOfPassWriteIndex: UInt32? = nil,
        endOfPassWriteIndex: UInt32? = nil
    ) {
        self.querySet = querySet
        self.beginningOfPassWriteIndex = beginningOfPassWriteIndex
        self.endOfPassWriteIndex = endOfPassWriteIndex
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        obj.querySet = querySet.jsObject.jsValue
        if let beginningOfPassWriteIndex = beginningOfPassWriteIndex {
            obj.beginningOfPassWriteIndex = .number(Double(beginningOfPassWriteIndex))
        }
        if let endOfPassWriteIndex = endOfPassWriteIndex {
            obj.endOfPassWriteIndex = .number(Double(endOfPassWriteIndex))
        }
        return obj
    }
}

// MARK: - GPUColor

/// A color value.
public struct GPUColor: Sendable {
    /// The red component.
    public var r: Double

    /// The green component.
    public var g: Double

    /// The blue component.
    public var b: Double

    /// The alpha component.
    public var a: Double

    public init(r: Double, g: Double, b: Double, a: Double) {
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }

    public static let black = GPUColor(r: 0, g: 0, b: 0, a: 1)
    public static let white = GPUColor(r: 1, g: 1, b: 1, a: 1)
    public static let clear = GPUColor(r: 0, g: 0, b: 0, a: 0)

    func toJSValue() -> JSValue {
        let obj = JSObject.global.Object.function!.new()
        obj.r = .number(r)
        obj.g = .number(g)
        obj.b = .number(b)
        obj.a = .number(a)
        return obj.jsValue
    }
}

// MARK: - Image Copy Types

/// A buffer image copy.
public struct GPUImageCopyBuffer: Sendable {
    /// The buffer.
    public var buffer: GPUBuffer

    /// The offset in bytes.
    public var offset: UInt64

    /// The bytes per row.
    public var bytesPerRow: UInt32?

    /// The rows per image.
    public var rowsPerImage: UInt32?

    public init(
        buffer: GPUBuffer,
        offset: UInt64 = 0,
        bytesPerRow: UInt32? = nil,
        rowsPerImage: UInt32? = nil
    ) {
        self.buffer = buffer
        self.offset = offset
        self.bytesPerRow = bytesPerRow
        self.rowsPerImage = rowsPerImage
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        obj.buffer = buffer.jsObject.jsValue
        obj.offset = .number(Double(offset))
        if let bytesPerRow = bytesPerRow {
            obj.bytesPerRow = .number(Double(bytesPerRow))
        }
        if let rowsPerImage = rowsPerImage {
            obj.rowsPerImage = .number(Double(rowsPerImage))
        }
        return obj
    }
}

/// A texture image copy.
public struct GPUImageCopyTexture: Sendable {
    /// The texture.
    public var texture: GPUTexture

    /// The mip level.
    public var mipLevel: UInt32

    /// The origin.
    public var origin: GPUOrigin3D

    /// The aspect.
    public var aspect: GPUTextureAspect

    public init(
        texture: GPUTexture,
        mipLevel: UInt32 = 0,
        origin: GPUOrigin3D = GPUOrigin3D(),
        aspect: GPUTextureAspect = .all
    ) {
        self.texture = texture
        self.mipLevel = mipLevel
        self.origin = origin
        self.aspect = aspect
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        obj.texture = texture.jsObject.jsValue
        obj.mipLevel = .number(Double(mipLevel))
        obj.origin = origin.toJSValue()
        obj.aspect = .string(aspect.rawValue)
        return obj
    }
}
