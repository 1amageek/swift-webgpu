import JavaScriptKit

/// A GPU buffer for storing data.
///
/// ```swift
/// let buffer = device.createBuffer(descriptor: GPUBufferDescriptor(
///     size: 256,
///     usage: [.vertex, .copyDst]
/// ))
/// ```
public final class GPUBuffer: @unchecked Sendable {
    /// The underlying JavaScript `GPUBuffer` object.
    let jsObject: JSObject

    init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    /// The size of the buffer in bytes.
    public var size: UInt64 {
        UInt64(jsObject.size.number ?? 0)
    }

    /// The usage flags of this buffer.
    public var usage: GPUBufferUsage {
        GPUBufferUsage(rawValue: UInt32(jsObject.usage.number ?? 0))
    }

    /// The map state of this buffer.
    public var mapState: GPUBufferMapState {
        let state = jsObject.mapState.string ?? "unmapped"
        return GPUBufferMapState(rawValue: state) ?? .unmapped
    }

    /// The label of this buffer.
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

    /// Maps the buffer for reading or writing.
    ///
    /// - Parameters:
    ///   - mode: The mapping mode.
    ///   - offset: The offset in bytes.
    ///   - size: The size in bytes. If nil, maps to the end of the buffer.
    /// - Throws: `GPUBufferMapError` if the mapping operation fails.
    public func mapAsync(mode: GPUMapMode, offset: UInt64 = 0, size: UInt64? = nil) async throws(GPUBufferMapError) {
        let promise: JSPromise
        if let size = size {
            promise = JSPromise(jsObject.mapAsync!(
                Double(mode.rawValue),
                Double(offset),
                Double(size)
            ).object!)!
        } else {
            promise = JSPromise(jsObject.mapAsync!(
                Double(mode.rawValue),
                Double(offset)
            ).object!)!
        }
        let result = await awaitBufferMap(promise)
        switch result {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }

    /// Gets a mapped range of the buffer.
    ///
    /// - Parameters:
    ///   - offset: The offset in bytes.
    ///   - size: The size in bytes. If nil, returns to the end of the mapping.
    /// - Returns: An `ArrayBuffer` for the mapped range.
    ///
    /// - Note: This method must be called after `mapAsync()` completes successfully.
    ///         The buffer must be in the `mapped` state.
    public func getMappedRange(offset: UInt64 = 0, size: UInt64? = nil) -> JSObject {
        if let size = size {
            return jsObject.getMappedRange!(Double(offset), Double(size)).object!
        } else {
            return jsObject.getMappedRange!(Double(offset)).object!
        }
    }

    /// Unmaps the buffer.
    public func unmap() {
        _ = jsObject.unmap!()
    }

    /// Destroys this buffer.
    public func destroy() {
        _ = jsObject.destroy!()
    }
}

// MARK: - GPUBufferMapState

/// The map state of a buffer.
public enum GPUBufferMapState: String, Sendable {
    case unmapped = "unmapped"
    case pending = "pending"
    case mapped = "mapped"
}

// MARK: - GPUBufferDescriptor

/// Descriptor for creating a buffer.
public struct GPUBufferDescriptor: Sendable {
    /// The size of the buffer in bytes.
    public var size: UInt64

    /// The usage flags for the buffer.
    public var usage: GPUBufferUsage

    /// Whether the buffer is mappable at creation.
    public var mappedAtCreation: Bool

    /// A label for the buffer.
    public var label: String?

    /// Creates a buffer descriptor.
    public init(
        size: UInt64,
        usage: GPUBufferUsage,
        mappedAtCreation: Bool = false,
        label: String? = nil
    ) {
        self.size = size
        self.usage = usage
        self.mappedAtCreation = mappedAtCreation
        self.label = label
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        obj.size = .number(Double(size))
        obj.usage = .number(Double(usage.rawValue))
        obj.mappedAtCreation = .boolean(mappedAtCreation)
        if let label = label {
            obj.label = .string(label)
        }
        return obj
    }
}
