import JavaScriptKit

/// A GPU texture for storing image data.
///
/// ```swift
/// let texture = device.createTexture(descriptor: GPUTextureDescriptor(
///     size: GPUExtent3D(width: 256, height: 256),
///     format: .rgba8unorm,
///     usage: [.textureBinding, .copyDst]
/// ))
/// ```
public final class GPUTexture: @unchecked Sendable {
    /// The underlying JavaScript `GPUTexture` object.
    let jsObject: JSObject

    init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    /// The width of this texture.
    public var width: UInt32 {
        UInt32(jsObject.width.number ?? 0)
    }

    /// The height of this texture.
    public var height: UInt32 {
        UInt32(jsObject.height.number ?? 0)
    }

    /// The depth or array layer count of this texture.
    public var depthOrArrayLayers: UInt32 {
        UInt32(jsObject.depthOrArrayLayers.number ?? 0)
    }

    /// The mip level count of this texture.
    public var mipLevelCount: UInt32 {
        UInt32(jsObject.mipLevelCount.number ?? 0)
    }

    /// The sample count of this texture.
    public var sampleCount: UInt32 {
        UInt32(jsObject.sampleCount.number ?? 0)
    }

    /// The dimension of this texture.
    public var dimension: GPUTextureDimension {
        let dim = jsObject.dimension.string ?? "2d"
        return GPUTextureDimension(rawValue: dim) ?? ._2d
    }

    /// The format of this texture.
    public var format: GPUTextureFormat {
        let fmt = jsObject.format.string ?? "rgba8unorm"
        return GPUTextureFormat(rawValue: fmt) ?? .rgba8unorm
    }

    /// The usage flags of this texture.
    public var usage: GPUTextureUsage {
        GPUTextureUsage(rawValue: UInt32(jsObject.usage.number ?? 0))
    }

    /// The label of this texture.
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

    /// Creates a view of this texture.
    public func createView(descriptor: GPUTextureViewDescriptor? = nil) -> GPUTextureView {
        let jsView: JSObject
        if let descriptor = descriptor {
            jsView = jsObject.createView!(descriptor.toJSObject()).object!
        } else {
            jsView = jsObject.createView!().object!
        }
        return GPUTextureView(jsObject: jsView)
    }

    /// Destroys this texture.
    public func destroy() {
        _ = jsObject.destroy!()
    }
}

// MARK: - GPUTextureView

/// A view of a texture.
public final class GPUTextureView: @unchecked Sendable {
    /// The underlying JavaScript `GPUTextureView` object.
    let jsObject: JSObject

    init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    /// The label of this texture view.
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

// MARK: - GPUExternalTexture

/// An external texture for video processing.
///
/// External textures are used for efficiently sampling video frames.
///
/// ```swift
/// let video = JSObject.global.document.getElementById!("video").object!
/// let externalTexture = device.importExternalTexture(descriptor: GPUExternalTextureDescriptor(
///     source: video
/// ))
/// ```
public final class GPUExternalTexture: @unchecked Sendable {
    /// The underlying JavaScript `GPUExternalTexture` object.
    let jsObject: JSObject

    init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    /// The label of this external texture.
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

    /// Whether this external texture has expired.
    ///
    /// External textures expire at the end of the task that created them.
    public var expired: Bool {
        jsObject.expired.boolean ?? true
    }
}

// MARK: - GPUExternalTextureDescriptor

/// Descriptor for importing an external texture.
public struct GPUExternalTextureDescriptor: @unchecked Sendable {
    /// The video source (HTMLVideoElement or VideoFrame).
    public var source: JSObject

    /// The color space of the source.
    public var colorSpace: GPUPredefinedColorSpace

    /// A label for the external texture.
    public var label: String?

    /// Creates an external texture descriptor.
    public init(
        source: JSObject,
        colorSpace: GPUPredefinedColorSpace = .srgb,
        label: String? = nil
    ) {
        self.source = source
        self.colorSpace = colorSpace
        self.label = label
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        obj.source = source.jsValue
        obj.colorSpace = .string(colorSpace.rawValue)
        if let label = label {
            obj.label = .string(label)
        }
        return obj
    }
}

// MARK: - GPUTextureDescriptor

/// Descriptor for creating a texture.
public struct GPUTextureDescriptor: Sendable {
    /// The size of the texture.
    public var size: GPUExtent3D

    /// The mip level count.
    public var mipLevelCount: UInt32

    /// The sample count.
    public var sampleCount: UInt32

    /// The dimension of the texture.
    public var dimension: GPUTextureDimension

    /// The format of the texture.
    public var format: GPUTextureFormat

    /// The usage flags.
    public var usage: GPUTextureUsage

    /// The view formats.
    public var viewFormats: [GPUTextureFormat]

    /// A label for the texture.
    public var label: String?

    /// Creates a texture descriptor.
    public init(
        size: GPUExtent3D,
        mipLevelCount: UInt32 = 1,
        sampleCount: UInt32 = 1,
        dimension: GPUTextureDimension = ._2d,
        format: GPUTextureFormat,
        usage: GPUTextureUsage,
        viewFormats: [GPUTextureFormat] = [],
        label: String? = nil
    ) {
        self.size = size
        self.mipLevelCount = mipLevelCount
        self.sampleCount = sampleCount
        self.dimension = dimension
        self.format = format
        self.usage = usage
        self.viewFormats = viewFormats
        self.label = label
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        obj.size = size.toJSValue()
        obj.mipLevelCount = .number(Double(mipLevelCount))
        obj.sampleCount = .number(Double(sampleCount))
        obj.dimension = .string(dimension.rawValue)
        obj.format = .string(format.rawValue)
        obj.usage = .number(Double(usage.rawValue))

        if !viewFormats.isEmpty {
            let formatsArray = JSObject.global.Array.function!.new()
            for (index, format) in viewFormats.enumerated() {
                formatsArray[index] = .string(format.rawValue)
            }
            obj.viewFormats = formatsArray.jsValue
        }

        if let label = label {
            obj.label = .string(label)
        }
        return obj
    }
}

// MARK: - GPUTextureViewDescriptor

/// Descriptor for creating a texture view.
public struct GPUTextureViewDescriptor: Sendable {
    /// The format of the view.
    public var format: GPUTextureFormat?

    /// The dimension of the view.
    public var dimension: GPUTextureViewDimension?

    /// The aspect of the texture to view.
    public var aspect: GPUTextureAspect

    /// The base mip level.
    public var baseMipLevel: UInt32

    /// The mip level count.
    public var mipLevelCount: UInt32?

    /// The base array layer.
    public var baseArrayLayer: UInt32

    /// The array layer count.
    public var arrayLayerCount: UInt32?

    /// A label for the view.
    public var label: String?

    /// Creates a texture view descriptor.
    public init(
        format: GPUTextureFormat? = nil,
        dimension: GPUTextureViewDimension? = nil,
        aspect: GPUTextureAspect = .all,
        baseMipLevel: UInt32 = 0,
        mipLevelCount: UInt32? = nil,
        baseArrayLayer: UInt32 = 0,
        arrayLayerCount: UInt32? = nil,
        label: String? = nil
    ) {
        self.format = format
        self.dimension = dimension
        self.aspect = aspect
        self.baseMipLevel = baseMipLevel
        self.mipLevelCount = mipLevelCount
        self.baseArrayLayer = baseArrayLayer
        self.arrayLayerCount = arrayLayerCount
        self.label = label
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()

        if let format = format {
            obj.format = .string(format.rawValue)
        }
        if let dimension = dimension {
            obj.dimension = .string(dimension.rawValue)
        }
        obj.aspect = .string(aspect.rawValue)
        obj.baseMipLevel = .number(Double(baseMipLevel))
        if let mipLevelCount = mipLevelCount {
            obj.mipLevelCount = .number(Double(mipLevelCount))
        }
        obj.baseArrayLayer = .number(Double(baseArrayLayer))
        if let arrayLayerCount = arrayLayerCount {
            obj.arrayLayerCount = .number(Double(arrayLayerCount))
        }
        if let label = label {
            obj.label = .string(label)
        }
        return obj
    }
}

// MARK: - GPUExtent3D

/// A 3D extent (size).
public struct GPUExtent3D: Sendable {
    /// The width.
    public var width: UInt32

    /// The height.
    public var height: UInt32

    /// The depth or array layer count.
    public var depthOrArrayLayers: UInt32

    /// Creates a 3D extent.
    public init(width: UInt32, height: UInt32 = 1, depthOrArrayLayers: UInt32 = 1) {
        self.width = width
        self.height = height
        self.depthOrArrayLayers = depthOrArrayLayers
    }

    func toJSValue() -> JSValue {
        let obj = JSObject.global.Object.function!.new()
        obj.width = .number(Double(width))
        obj.height = .number(Double(height))
        obj.depthOrArrayLayers = .number(Double(depthOrArrayLayers))
        return obj.jsValue
    }
}

// MARK: - GPUOrigin3D

/// A 3D origin (position).
public struct GPUOrigin3D: Sendable {
    /// The x coordinate.
    public var x: UInt32

    /// The y coordinate.
    public var y: UInt32

    /// The z coordinate.
    public var z: UInt32

    /// Creates a 3D origin.
    public init(x: UInt32 = 0, y: UInt32 = 0, z: UInt32 = 0) {
        self.x = x
        self.y = y
        self.z = z
    }

    func toJSValue() -> JSValue {
        let obj = JSObject.global.Object.function!.new()
        obj.x = .number(Double(x))
        obj.y = .number(Double(y))
        obj.z = .number(Double(z))
        return obj.jsValue
    }
}
