import JavaScriptKit

// MARK: - GPUBindGroupLayout

/// A bind group layout defines the structure of a bind group.
public final class GPUBindGroupLayout: @unchecked Sendable {
    /// The underlying JavaScript `GPUBindGroupLayout` object.
    let jsObject: JSObject

    init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    /// The label of this bind group layout.
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

// MARK: - GPUBindGroup

/// A bind group contains resources bound to a shader.
public final class GPUBindGroup: @unchecked Sendable {
    /// The underlying JavaScript `GPUBindGroup` object.
    let jsObject: JSObject

    init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    /// The label of this bind group.
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

// MARK: - GPUPipelineLayout

/// A pipeline layout defines the layout of bind groups for a pipeline.
public final class GPUPipelineLayout: @unchecked Sendable {
    /// The underlying JavaScript `GPUPipelineLayout` object.
    let jsObject: JSObject

    init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    /// The label of this pipeline layout.
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

// MARK: - GPUBindGroupLayoutDescriptor

/// Descriptor for creating a bind group layout.
public struct GPUBindGroupLayoutDescriptor: Sendable {
    /// The bind group layout entries.
    public var entries: [GPUBindGroupLayoutEntry]

    /// A label for the bind group layout.
    public var label: String?

    /// Creates a bind group layout descriptor.
    public init(
        entries: [GPUBindGroupLayoutEntry],
        label: String? = nil
    ) {
        self.entries = entries
        self.label = label
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()

        let entriesArray = JSObject.global.Array.function!.new()
        for (index, entry) in entries.enumerated() {
            entriesArray[index] = entry.toJSObject().jsValue
        }
        obj.entries = entriesArray.jsValue

        if let label = label {
            obj.label = .string(label)
        }
        return obj
    }
}

// MARK: - GPUBindGroupLayoutEntry

/// An entry in a bind group layout.
public struct GPUBindGroupLayoutEntry: Sendable {
    /// The binding index.
    public var binding: UInt32

    /// The shader stages that can access this binding.
    public var visibility: GPUShaderStage

    /// Buffer binding layout (if this is a buffer binding).
    public var buffer: GPUBufferBindingLayout?

    /// Sampler binding layout (if this is a sampler binding).
    public var sampler: GPUSamplerBindingLayout?

    /// Texture binding layout (if this is a texture binding).
    public var texture: GPUTextureBindingLayout?

    /// Storage texture binding layout (if this is a storage texture binding).
    public var storageTexture: GPUStorageTextureBindingLayout?

    /// External texture binding layout.
    public var externalTexture: GPUExternalTextureBindingLayout?

    /// Creates a bind group layout entry.
    public init(
        binding: UInt32,
        visibility: GPUShaderStage,
        buffer: GPUBufferBindingLayout? = nil,
        sampler: GPUSamplerBindingLayout? = nil,
        texture: GPUTextureBindingLayout? = nil,
        storageTexture: GPUStorageTextureBindingLayout? = nil,
        externalTexture: GPUExternalTextureBindingLayout? = nil
    ) {
        self.binding = binding
        self.visibility = visibility
        self.buffer = buffer
        self.sampler = sampler
        self.texture = texture
        self.storageTexture = storageTexture
        self.externalTexture = externalTexture
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        obj.binding = .number(Double(binding))
        obj.visibility = .number(Double(visibility.rawValue))

        if let buffer = buffer {
            obj.buffer = buffer.toJSObject().jsValue
        }
        if let sampler = sampler {
            obj.sampler = sampler.toJSObject().jsValue
        }
        if let texture = texture {
            obj.texture = texture.toJSObject().jsValue
        }
        if let storageTexture = storageTexture {
            obj.storageTexture = storageTexture.toJSObject().jsValue
        }
        if externalTexture != nil {
            let extObj = JSObject.global.Object.function!.new()
            obj.externalTexture = extObj.jsValue
        }
        return obj
    }
}

// MARK: - Binding Layouts

/// Buffer binding layout.
public struct GPUBufferBindingLayout: Sendable {
    /// The type of buffer binding.
    public var type: GPUBufferBindingType

    /// Whether the binding has a dynamic offset.
    public var hasDynamicOffset: Bool

    /// The minimum binding size.
    public var minBindingSize: UInt64

    public init(
        type: GPUBufferBindingType = .uniform,
        hasDynamicOffset: Bool = false,
        minBindingSize: UInt64 = 0
    ) {
        self.type = type
        self.hasDynamicOffset = hasDynamicOffset
        self.minBindingSize = minBindingSize
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        obj.type = .string(type.rawValue)
        obj.hasDynamicOffset = .boolean(hasDynamicOffset)
        obj.minBindingSize = .number(Double(minBindingSize))
        return obj
    }
}

/// Sampler binding layout.
public struct GPUSamplerBindingLayout: Sendable {
    /// The type of sampler binding.
    public var type: GPUSamplerBindingType

    public init(type: GPUSamplerBindingType = .filtering) {
        self.type = type
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        obj.type = .string(type.rawValue)
        return obj
    }
}

/// Texture binding layout.
public struct GPUTextureBindingLayout: Sendable {
    /// The sample type.
    public var sampleType: GPUTextureSampleType

    /// The view dimension.
    public var viewDimension: GPUTextureViewDimension

    /// Whether the texture is multisampled.
    public var multisampled: Bool

    public init(
        sampleType: GPUTextureSampleType = .float,
        viewDimension: GPUTextureViewDimension = ._2d,
        multisampled: Bool = false
    ) {
        self.sampleType = sampleType
        self.viewDimension = viewDimension
        self.multisampled = multisampled
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        obj.sampleType = .string(sampleType.rawValue)
        obj.viewDimension = .string(viewDimension.rawValue)
        obj.multisampled = .boolean(multisampled)
        return obj
    }
}

/// Storage texture binding layout.
public struct GPUStorageTextureBindingLayout: Sendable {
    /// The access mode.
    public var access: GPUStorageTextureAccess

    /// The texture format.
    public var format: GPUTextureFormat

    /// The view dimension.
    public var viewDimension: GPUTextureViewDimension

    public init(
        access: GPUStorageTextureAccess = .writeOnly,
        format: GPUTextureFormat,
        viewDimension: GPUTextureViewDimension = ._2d
    ) {
        self.access = access
        self.format = format
        self.viewDimension = viewDimension
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        obj.access = .string(access.rawValue)
        obj.format = .string(format.rawValue)
        obj.viewDimension = .string(viewDimension.rawValue)
        return obj
    }
}

/// External texture binding layout.
public struct GPUExternalTextureBindingLayout: Sendable {
    public init() {}
}

// MARK: - GPUBindGroupDescriptor

/// Descriptor for creating a bind group.
public struct GPUBindGroupDescriptor: Sendable {
    /// The bind group layout.
    public var layout: GPUBindGroupLayout

    /// The bind group entries.
    public var entries: [GPUBindGroupEntry]

    /// A label for the bind group.
    public var label: String?

    public init(
        layout: GPUBindGroupLayout,
        entries: [GPUBindGroupEntry],
        label: String? = nil
    ) {
        self.layout = layout
        self.entries = entries
        self.label = label
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        obj.layout = layout.jsObject.jsValue

        let entriesArray = JSObject.global.Array.function!.new()
        for (index, entry) in entries.enumerated() {
            entriesArray[index] = entry.toJSObject().jsValue
        }
        obj.entries = entriesArray.jsValue

        if let label = label {
            obj.label = .string(label)
        }
        return obj
    }
}

// MARK: - GPUBindGroupEntry

/// An entry in a bind group.
public struct GPUBindGroupEntry: Sendable {
    /// The binding index.
    public var binding: UInt32

    /// The resource to bind.
    public var resource: GPUBindingResource

    public init(binding: UInt32, resource: GPUBindingResource) {
        self.binding = binding
        self.resource = resource
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        obj.binding = .number(Double(binding))
        obj.resource = resource.toJSValue()
        return obj
    }
}

// MARK: - GPUBindingResource

/// A resource that can be bound in a bind group.
public enum GPUBindingResource: Sendable {
    case sampler(GPUSampler)
    case textureView(GPUTextureView)
    case bufferBinding(GPUBufferBinding)
    case externalTexture(GPUExternalTexture)

    func toJSValue() -> JSValue {
        switch self {
        case .sampler(let sampler):
            return sampler.jsObject.jsValue
        case .textureView(let view):
            return view.jsObject.jsValue
        case .bufferBinding(let binding):
            return binding.toJSObject().jsValue
        case .externalTexture(let texture):
            return texture.jsObject.jsValue
        }
    }
}

// MARK: - GPUBufferBinding

/// A buffer binding.
public struct GPUBufferBinding: Sendable {
    /// The buffer to bind.
    public var buffer: GPUBuffer

    /// The offset in bytes.
    public var offset: UInt64

    /// The size in bytes.
    public var size: UInt64?

    public init(buffer: GPUBuffer, offset: UInt64 = 0, size: UInt64? = nil) {
        self.buffer = buffer
        self.offset = offset
        self.size = size
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        obj.buffer = buffer.jsObject.jsValue
        obj.offset = .number(Double(offset))
        if let size = size {
            obj.size = .number(Double(size))
        }
        return obj
    }
}

// MARK: - GPUPipelineLayoutDescriptor

/// Descriptor for creating a pipeline layout.
public struct GPUPipelineLayoutDescriptor: Sendable {
    /// The bind group layouts.
    public var bindGroupLayouts: [GPUBindGroupLayout]

    /// A label for the pipeline layout.
    public var label: String?

    public init(
        bindGroupLayouts: [GPUBindGroupLayout],
        label: String? = nil
    ) {
        self.bindGroupLayouts = bindGroupLayouts
        self.label = label
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()

        let layoutsArray = JSObject.global.Array.function!.new()
        for (index, layout) in bindGroupLayouts.enumerated() {
            layoutsArray[index] = layout.jsObject.jsValue
        }
        obj.bindGroupLayouts = layoutsArray.jsValue

        if let label = label {
            obj.label = .string(label)
        }
        return obj
    }
}
