import JavaScriptKit

/// A GPU sampler for texture sampling operations.
///
/// ```swift
/// let sampler = device.createSampler(descriptor: GPUSamplerDescriptor(
///     magFilter: .linear,
///     minFilter: .linear
/// ))
/// ```
public final class GPUSampler: @unchecked Sendable {
    /// The underlying JavaScript `GPUSampler` object.
    let jsObject: JSObject

    init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    /// The label of this sampler.
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

// MARK: - GPUSamplerDescriptor

/// Descriptor for creating a sampler.
public struct GPUSamplerDescriptor: Sendable {
    /// The address mode for the u coordinate.
    public var addressModeU: GPUAddressMode

    /// The address mode for the v coordinate.
    public var addressModeV: GPUAddressMode

    /// The address mode for the w coordinate.
    public var addressModeW: GPUAddressMode

    /// The magnification filter.
    public var magFilter: GPUFilterMode

    /// The minification filter.
    public var minFilter: GPUFilterMode

    /// The mipmap filter.
    public var mipmapFilter: GPUMipmapFilterMode

    /// The minimum LOD clamp.
    public var lodMinClamp: Float

    /// The maximum LOD clamp.
    public var lodMaxClamp: Float

    /// The comparison function for comparison samplers.
    public var compare: GPUCompareFunction?

    /// The maximum anisotropy.
    public var maxAnisotropy: UInt16

    /// A label for the sampler.
    public var label: String?

    /// Creates a sampler descriptor.
    public init(
        addressModeU: GPUAddressMode = .clampToEdge,
        addressModeV: GPUAddressMode = .clampToEdge,
        addressModeW: GPUAddressMode = .clampToEdge,
        magFilter: GPUFilterMode = .nearest,
        minFilter: GPUFilterMode = .nearest,
        mipmapFilter: GPUMipmapFilterMode = .nearest,
        lodMinClamp: Float = 0,
        lodMaxClamp: Float = 32,
        compare: GPUCompareFunction? = nil,
        maxAnisotropy: UInt16 = 1,
        label: String? = nil
    ) {
        self.addressModeU = addressModeU
        self.addressModeV = addressModeV
        self.addressModeW = addressModeW
        self.magFilter = magFilter
        self.minFilter = minFilter
        self.mipmapFilter = mipmapFilter
        self.lodMinClamp = lodMinClamp
        self.lodMaxClamp = lodMaxClamp
        self.compare = compare
        self.maxAnisotropy = maxAnisotropy
        self.label = label
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        obj.addressModeU = .string(addressModeU.rawValue)
        obj.addressModeV = .string(addressModeV.rawValue)
        obj.addressModeW = .string(addressModeW.rawValue)
        obj.magFilter = .string(magFilter.rawValue)
        obj.minFilter = .string(minFilter.rawValue)
        obj.mipmapFilter = .string(mipmapFilter.rawValue)
        obj.lodMinClamp = .number(Double(lodMinClamp))
        obj.lodMaxClamp = .number(Double(lodMaxClamp))
        if let compare = compare {
            obj.compare = .string(compare.rawValue)
        }
        obj.maxAnisotropy = .number(Double(maxAnisotropy))
        if let label = label {
            obj.label = .string(label)
        }
        return obj
    }
}
