import JavaScriptKit
import JavaScriptEventLoop

/// A GPU adapter represents a specific GPU implementation.
///
/// Use `GPU.shared.requestAdapter()` to obtain an adapter.
///
/// ```swift
/// guard let adapter = try await gpu.requestAdapter() else {
///     print("No adapter found")
///     return
/// }
/// print("Adapter: \(adapter.info.vendor)")
/// let device = try await adapter.requestDevice()
/// ```
public final class GPUAdapter: @unchecked Sendable {
    /// The underlying JavaScript `GPUAdapter` object.
    let jsObject: JSObject

    init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    /// The set of features supported by this adapter.
    public var features: Set<GPUFeatureName> {
        var result: Set<GPUFeatureName> = []
        let jsFeatures = jsObject.features
        let iterator = jsFeatures.values().object!
        while true {
            let next = iterator.next!().object!
            if next.done.boolean == true {
                break
            }
            if let value = next.value.string,
               let feature = GPUFeatureName(rawValue: value) {
                result.insert(feature)
            }
        }
        return result
    }

    /// The limits supported by this adapter.
    public var limits: GPUSupportedLimits {
        GPUSupportedLimits(jsObject: jsObject.limits.object!)
    }

    /// Information about this adapter.
    public var info: GPUAdapterInfo {
        GPUAdapterInfo(jsObject: jsObject.info.object!)
    }

    /// Whether this adapter is a fallback adapter.
    public var isFallbackAdapter: Bool {
        jsObject.isFallbackAdapter.boolean ?? false
    }

    /// Requests a device from this adapter.
    ///
    /// - Parameter descriptor: Options for device creation.
    /// - Returns: A `GPUDevice`.
    /// - Throws: `GPURequestDeviceError` if the device cannot be created.
    ///   - `.operationError`: The requested limits are not supported, or the adapter was already consumed.
    ///   - `.typeError`: The requested features are not supported.
    public func requestDevice(descriptor: GPUDeviceDescriptor? = nil) async throws(GPURequestDeviceError) -> GPUDevice {
        let promise: JSPromise
        if let descriptor = descriptor {
            promise = JSPromise(jsObject.requestDevice!(descriptor.toJSObject()).object!)!
        } else {
            promise = JSPromise(jsObject.requestDevice!().object!)!
        }

        let result = await awaitDeviceRequest(promise)
        switch result {
        case .success(let value):
            return GPUDevice(jsObject: value.object!)
        case .failure(let error):
            throw error
        }
    }
}

// MARK: - GPUAdapterInfo

/// Information about a GPU adapter.
public struct GPUAdapterInfo: @unchecked Sendable {
    private let jsObject: JSObject

    init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    /// The vendor name.
    public var vendor: String {
        jsObject.vendor.string ?? ""
    }

    /// The architecture name.
    public var architecture: String {
        jsObject.architecture.string ?? ""
    }

    /// The device name.
    public var device: String {
        jsObject.device.string ?? ""
    }

    /// The device description.
    public var adapterDescription: String {
        jsObject["description"].string ?? ""
    }

    /// The minimum subgroup size supported by the adapter.
    ///
    /// This property is only available when the "subgroups" feature is supported.
    public var subgroupMinSize: UInt32? {
        guard let num = jsObject.subgroupMinSize.number else { return nil }
        return UInt32(num)
    }

    /// The maximum subgroup size supported by the adapter.
    ///
    /// This property is only available when the "subgroups" feature is supported.
    public var subgroupMaxSize: UInt32? {
        guard let num = jsObject.subgroupMaxSize.number else { return nil }
        return UInt32(num)
    }
}

// MARK: - GPUSupportedLimits

/// The limits supported by an adapter or device.
public struct GPUSupportedLimits: @unchecked Sendable {
    private let jsObject: JSObject

    init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    public var maxTextureDimension1D: UInt32 {
        UInt32(jsObject.maxTextureDimension1D.number ?? 0)
    }

    public var maxTextureDimension2D: UInt32 {
        UInt32(jsObject.maxTextureDimension2D.number ?? 0)
    }

    public var maxTextureDimension3D: UInt32 {
        UInt32(jsObject.maxTextureDimension3D.number ?? 0)
    }

    public var maxTextureArrayLayers: UInt32 {
        UInt32(jsObject.maxTextureArrayLayers.number ?? 0)
    }

    public var maxBindGroups: UInt32 {
        UInt32(jsObject.maxBindGroups.number ?? 0)
    }

    public var maxBindGroupsPlusVertexBuffers: UInt32 {
        UInt32(jsObject.maxBindGroupsPlusVertexBuffers.number ?? 0)
    }

    public var maxBindingsPerBindGroup: UInt32 {
        UInt32(jsObject.maxBindingsPerBindGroup.number ?? 0)
    }

    public var maxDynamicUniformBuffersPerPipelineLayout: UInt32 {
        UInt32(jsObject.maxDynamicUniformBuffersPerPipelineLayout.number ?? 0)
    }

    public var maxDynamicStorageBuffersPerPipelineLayout: UInt32 {
        UInt32(jsObject.maxDynamicStorageBuffersPerPipelineLayout.number ?? 0)
    }

    public var maxSampledTexturesPerShaderStage: UInt32 {
        UInt32(jsObject.maxSampledTexturesPerShaderStage.number ?? 0)
    }

    public var maxSamplersPerShaderStage: UInt32 {
        UInt32(jsObject.maxSamplersPerShaderStage.number ?? 0)
    }

    public var maxStorageBuffersPerShaderStage: UInt32 {
        UInt32(jsObject.maxStorageBuffersPerShaderStage.number ?? 0)
    }

    public var maxStorageTexturesPerShaderStage: UInt32 {
        UInt32(jsObject.maxStorageTexturesPerShaderStage.number ?? 0)
    }

    public var maxUniformBuffersPerShaderStage: UInt32 {
        UInt32(jsObject.maxUniformBuffersPerShaderStage.number ?? 0)
    }

    public var maxUniformBufferBindingSize: UInt64 {
        UInt64(jsObject.maxUniformBufferBindingSize.number ?? 0)
    }

    public var maxStorageBufferBindingSize: UInt64 {
        UInt64(jsObject.maxStorageBufferBindingSize.number ?? 0)
    }

    public var minUniformBufferOffsetAlignment: UInt32 {
        UInt32(jsObject.minUniformBufferOffsetAlignment.number ?? 0)
    }

    public var minStorageBufferOffsetAlignment: UInt32 {
        UInt32(jsObject.minStorageBufferOffsetAlignment.number ?? 0)
    }

    public var maxVertexBuffers: UInt32 {
        UInt32(jsObject.maxVertexBuffers.number ?? 0)
    }

    public var maxBufferSize: UInt64 {
        UInt64(jsObject.maxBufferSize.number ?? 0)
    }

    public var maxVertexAttributes: UInt32 {
        UInt32(jsObject.maxVertexAttributes.number ?? 0)
    }

    public var maxVertexBufferArrayStride: UInt32 {
        UInt32(jsObject.maxVertexBufferArrayStride.number ?? 0)
    }

    public var maxInterStageShaderVariables: UInt32 {
        UInt32(jsObject.maxInterStageShaderVariables.number ?? 0)
    }

    public var maxColorAttachments: UInt32 {
        UInt32(jsObject.maxColorAttachments.number ?? 0)
    }

    public var maxColorAttachmentBytesPerSample: UInt32 {
        UInt32(jsObject.maxColorAttachmentBytesPerSample.number ?? 0)
    }

    public var maxComputeWorkgroupStorageSize: UInt32 {
        UInt32(jsObject.maxComputeWorkgroupStorageSize.number ?? 0)
    }

    public var maxComputeInvocationsPerWorkgroup: UInt32 {
        UInt32(jsObject.maxComputeInvocationsPerWorkgroup.number ?? 0)
    }

    public var maxComputeWorkgroupSizeX: UInt32 {
        UInt32(jsObject.maxComputeWorkgroupSizeX.number ?? 0)
    }

    public var maxComputeWorkgroupSizeY: UInt32 {
        UInt32(jsObject.maxComputeWorkgroupSizeY.number ?? 0)
    }

    public var maxComputeWorkgroupSizeZ: UInt32 {
        UInt32(jsObject.maxComputeWorkgroupSizeZ.number ?? 0)
    }

    public var maxComputeWorkgroupsPerDimension: UInt32 {
        UInt32(jsObject.maxComputeWorkgroupsPerDimension.number ?? 0)
    }
}

// MARK: - GPUDeviceDescriptor

/// Descriptor for creating a GPU device.
public struct GPUDeviceDescriptor: Sendable {
    /// The features to enable on the device.
    public var requiredFeatures: [GPUFeatureName]

    /// The limits to request.
    public var requiredLimits: [String: UInt64]

    /// A label for the device.
    public var label: String?

    /// Default queue descriptor.
    public var defaultQueue: GPUQueueDescriptor?

    /// Creates a device descriptor.
    public init(
        requiredFeatures: [GPUFeatureName] = [],
        requiredLimits: [String: UInt64] = [:],
        label: String? = nil,
        defaultQueue: GPUQueueDescriptor? = nil
    ) {
        self.requiredFeatures = requiredFeatures
        self.requiredLimits = requiredLimits
        self.label = label
        self.defaultQueue = defaultQueue
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()

        if !requiredFeatures.isEmpty {
            let featuresArray = JSObject.global.Array.function!.new()
            for (index, feature) in requiredFeatures.enumerated() {
                featuresArray[index] = .string(feature.rawValue)
            }
            obj.requiredFeatures = featuresArray.jsValue
        }

        if !requiredLimits.isEmpty {
            let limitsObj = JSObject.global.Object.function!.new()
            for (key, value) in requiredLimits {
                limitsObj[key] = .number(Double(value))
            }
            obj.requiredLimits = limitsObj.jsValue
        }

        if let label = label {
            obj.label = .string(label)
        }

        if let defaultQueue = defaultQueue {
            obj.defaultQueue = defaultQueue.toJSObject().jsValue
        }

        return obj
    }
}

// MARK: - GPUQueueDescriptor

/// Descriptor for creating a GPU queue.
public struct GPUQueueDescriptor: Sendable {
    /// A label for the queue.
    public var label: String?

    /// Creates a queue descriptor.
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
