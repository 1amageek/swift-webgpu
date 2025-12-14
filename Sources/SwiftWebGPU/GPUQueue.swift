import JavaScriptKit

/// A GPU queue for submitting command buffers.
///
/// ```swift
/// let commandBuffer = encoder.finish()
/// device.queue.submit([commandBuffer])
/// ```
public final class GPUQueue: @unchecked Sendable {
    /// The underlying JavaScript `GPUQueue` object.
    let jsObject: JSObject

    init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    /// The label of this queue.
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

    /// Submits command buffers for execution.
    public func submit(_ commandBuffers: [GPUCommandBuffer]) {
        let buffersArray = JSObject.global.Array.function!.new()
        for (index, buffer) in commandBuffers.enumerated() {
            buffersArray[index] = buffer.jsObject.jsValue
        }
        _ = jsObject.submit!(buffersArray)
    }

    /// Returns a promise that resolves when all previously submitted work has completed.
    ///
    /// This method does not throw - it always resolves when work completes.
    public func onSubmittedWorkDone() async {
        let promise = JSPromise(jsObject.onSubmittedWorkDone!().object!)!
        _ = await awaitPromise(promise)
    }

    /// Writes data to a buffer.
    public func writeBuffer(
        _ buffer: GPUBuffer,
        bufferOffset: UInt64,
        data: JSObject,
        dataOffset: UInt64 = 0,
        size: UInt64? = nil
    ) {
        if let size = size {
            _ = jsObject.writeBuffer!(buffer.jsObject, Double(bufferOffset), data, Double(dataOffset), Double(size))
        } else {
            _ = jsObject.writeBuffer!(buffer.jsObject, Double(bufferOffset), data, Double(dataOffset))
        }
    }

    /// Writes data to a texture.
    public func writeTexture(
        destination: GPUImageCopyTexture,
        data: JSObject,
        dataLayout: GPUImageDataLayout,
        size: GPUExtent3D
    ) {
        _ = jsObject.writeTexture!(
            destination.toJSObject(),
            data,
            dataLayout.toJSObject(),
            size.toJSValue()
        )
    }

    /// Copies an external image to a texture.
    public func copyExternalImageToTexture(
        source: GPUImageCopyExternalImage,
        destination: GPUImageCopyTextureTagged,
        copySize: GPUExtent3D
    ) {
        _ = jsObject.copyExternalImageToTexture!(
            source.toJSObject(),
            destination.toJSObject(),
            copySize.toJSValue()
        )
    }
}

// MARK: - GPUImageDataLayout

/// Layout of image data in a buffer.
public struct GPUImageDataLayout: Sendable {
    /// The offset in bytes.
    public var offset: UInt64

    /// The bytes per row.
    public var bytesPerRow: UInt32?

    /// The rows per image.
    public var rowsPerImage: UInt32?

    public init(
        offset: UInt64 = 0,
        bytesPerRow: UInt32? = nil,
        rowsPerImage: UInt32? = nil
    ) {
        self.offset = offset
        self.bytesPerRow = bytesPerRow
        self.rowsPerImage = rowsPerImage
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
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

// MARK: - GPUImageCopyExternalImage

/// An external image to copy from.
public struct GPUImageCopyExternalImage: @unchecked Sendable {
    /// The source image (ImageBitmap, HTMLCanvasElement, etc.).
    public var source: JSObject

    /// The origin.
    public var origin: GPUOrigin2D

    /// Whether to flip the image vertically.
    public var flipY: Bool

    public init(
        source: JSObject,
        origin: GPUOrigin2D = GPUOrigin2D(),
        flipY: Bool = false
    ) {
        self.source = source
        self.origin = origin
        self.flipY = flipY
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        obj.source = source.jsValue
        obj.origin = origin.toJSValue()
        obj.flipY = .boolean(flipY)
        return obj
    }
}

// MARK: - GPUImageCopyTextureTagged

/// A texture copy destination with color space information.
public struct GPUImageCopyTextureTagged: Sendable {
    /// The texture.
    public var texture: GPUTexture

    /// The mip level.
    public var mipLevel: UInt32

    /// The origin.
    public var origin: GPUOrigin3D

    /// The aspect.
    public var aspect: GPUTextureAspect

    /// Whether the color space is pre-multiplied.
    public var premultipliedAlpha: Bool

    public init(
        texture: GPUTexture,
        mipLevel: UInt32 = 0,
        origin: GPUOrigin3D = GPUOrigin3D(),
        aspect: GPUTextureAspect = .all,
        premultipliedAlpha: Bool = false
    ) {
        self.texture = texture
        self.mipLevel = mipLevel
        self.origin = origin
        self.aspect = aspect
        self.premultipliedAlpha = premultipliedAlpha
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        obj.texture = texture.jsObject.jsValue
        obj.mipLevel = .number(Double(mipLevel))
        obj.origin = origin.toJSValue()
        obj.aspect = .string(aspect.rawValue)
        obj.premultipliedAlpha = .boolean(premultipliedAlpha)
        return obj
    }
}

// MARK: - GPUOrigin2D

/// A 2D origin (position).
public struct GPUOrigin2D: Sendable {
    /// The x coordinate.
    public var x: UInt32

    /// The y coordinate.
    public var y: UInt32

    public init(x: UInt32 = 0, y: UInt32 = 0) {
        self.x = x
        self.y = y
    }

    func toJSValue() -> JSValue {
        let obj = JSObject.global.Object.function!.new()
        obj.x = .number(Double(x))
        obj.y = .number(Double(y))
        return obj.jsValue
    }
}

// MARK: - GPUQuerySet

/// A GPU query set for collecting GPU timing and occlusion data.
public final class GPUQuerySet: @unchecked Sendable {
    /// The underlying JavaScript `GPUQuerySet` object.
    let jsObject: JSObject

    init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    /// The type of queries in this set.
    public var type: GPUQueryType {
        let typeStr = jsObject.type.string ?? "occlusion"
        return GPUQueryType(rawValue: typeStr) ?? .occlusion
    }

    /// The number of queries in this set.
    public var count: UInt32 {
        UInt32(jsObject.count.number ?? 0)
    }

    /// The label of this query set.
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

    /// Destroys this query set.
    public func destroy() {
        _ = jsObject.destroy!()
    }
}

// MARK: - GPUQuerySetDescriptor

/// Descriptor for creating a query set.
public struct GPUQuerySetDescriptor: Sendable {
    /// The type of queries.
    public var type: GPUQueryType

    /// The number of queries.
    public var count: UInt32

    /// A label for the query set.
    public var label: String?

    public init(type: GPUQueryType, count: UInt32, label: String? = nil) {
        self.type = type
        self.count = count
        self.label = label
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        obj.type = .string(type.rawValue)
        obj.count = .number(Double(count))
        if let label = label {
            obj.label = .string(label)
        }
        return obj
    }
}
