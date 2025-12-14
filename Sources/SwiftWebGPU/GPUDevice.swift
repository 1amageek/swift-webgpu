import JavaScriptKit
import JavaScriptEventLoop

/// A GPU device is the main interface for creating GPU resources.
///
/// Use `GPUAdapter.requestDevice()` to obtain a device.
///
/// ```swift
/// let device = try await adapter.requestDevice()
/// let buffer = device.createBuffer(descriptor: GPUBufferDescriptor(
///     size: 256,
///     usage: [.vertex, .copyDst]
/// ))
/// ```
public final class GPUDevice: @unchecked Sendable {
    /// The underlying JavaScript `GPUDevice` object.
    let jsObject: JSObject

    init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    /// The set of features enabled on this device.
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

    /// The limits of this device.
    public var limits: GPUSupportedLimits {
        GPUSupportedLimits(jsObject: jsObject.limits.object!)
    }

    /// The default queue for this device.
    public var queue: GPUQueue {
        GPUQueue(jsObject: jsObject.queue.object!)
    }

    /// The label of this device.
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

    /// A promise that resolves when the device is lost.
    public func lost() async throws -> GPUDeviceLostInfo {
        let promise = JSPromise(jsObject.lost.object!)!
        let result = try await promise.value
        return GPUDeviceLostInfo(jsObject: result.object!)
    }

    /// Information about the adapter that created this device.
    public var adapterInfo: GPUAdapterInfo {
        GPUAdapterInfo(jsObject: jsObject.adapterInfo.object!)
    }

    /// Sets up a handler for uncaptured errors.
    ///
    /// - Parameter handler: A closure that receives the GPUUncapturedErrorEvent.
    /// - Returns: A closure that can be called to remove the event listener.
    @discardableResult
    public func onUncapturedError(_ handler: @escaping (GPUUncapturedErrorEvent) -> Void) -> JSClosure {
        let closure = JSClosure { args in
            if let eventObj = args.first?.object {
                let event = GPUUncapturedErrorEvent(jsObject: eventObj)
                handler(event)
            }
            return .undefined
        }
        _ = jsObject.addEventListener!("uncapturederror", closure)
        return closure
    }

    /// Removes an uncaptured error handler.
    public func removeUncapturedErrorHandler(_ closure: JSClosure) {
        _ = jsObject.removeEventListener!("uncapturederror", closure)
    }

    // MARK: - Resource Creation

    /// Creates a buffer.
    public func createBuffer(descriptor: GPUBufferDescriptor) -> GPUBuffer {
        let jsBuffer = jsObject.createBuffer!(descriptor.toJSObject()).object!
        return GPUBuffer(jsObject: jsBuffer)
    }

    /// Creates a texture.
    public func createTexture(descriptor: GPUTextureDescriptor) -> GPUTexture {
        let jsTexture = jsObject.createTexture!(descriptor.toJSObject()).object!
        return GPUTexture(jsObject: jsTexture)
    }

    /// Creates a sampler.
    public func createSampler(descriptor: GPUSamplerDescriptor? = nil) -> GPUSampler {
        let jsSampler: JSObject
        if let descriptor = descriptor {
            jsSampler = jsObject.createSampler!(descriptor.toJSObject()).object!
        } else {
            jsSampler = jsObject.createSampler!().object!
        }
        return GPUSampler(jsObject: jsSampler)
    }

    /// Creates a bind group layout.
    public func createBindGroupLayout(descriptor: GPUBindGroupLayoutDescriptor) -> GPUBindGroupLayout {
        let jsLayout = jsObject.createBindGroupLayout!(descriptor.toJSObject()).object!
        return GPUBindGroupLayout(jsObject: jsLayout)
    }

    /// Creates a pipeline layout.
    public func createPipelineLayout(descriptor: GPUPipelineLayoutDescriptor) -> GPUPipelineLayout {
        let jsLayout = jsObject.createPipelineLayout!(descriptor.toJSObject()).object!
        return GPUPipelineLayout(jsObject: jsLayout)
    }

    /// Creates a bind group.
    public func createBindGroup(descriptor: GPUBindGroupDescriptor) -> GPUBindGroup {
        let jsBindGroup = jsObject.createBindGroup!(descriptor.toJSObject()).object!
        return GPUBindGroup(jsObject: jsBindGroup)
    }

    /// Creates a shader module.
    public func createShaderModule(descriptor: GPUShaderModuleDescriptor) -> GPUShaderModule {
        let jsModule = jsObject.createShaderModule!(descriptor.toJSObject()).object!
        return GPUShaderModule(jsObject: jsModule)
    }

    /// Creates a compute pipeline.
    public func createComputePipeline(descriptor: GPUComputePipelineDescriptor) -> GPUComputePipeline {
        let jsPipeline = jsObject.createComputePipeline!(descriptor.toJSObject()).object!
        return GPUComputePipeline(jsObject: jsPipeline)
    }

    /// Creates a render pipeline.
    public func createRenderPipeline(descriptor: GPURenderPipelineDescriptor) -> GPURenderPipeline {
        let jsPipeline = jsObject.createRenderPipeline!(descriptor.toJSObject()).object!
        return GPURenderPipeline(jsObject: jsPipeline)
    }

    /// Creates a compute pipeline asynchronously.
    public func createComputePipelineAsync(descriptor: GPUComputePipelineDescriptor) async throws -> GPUComputePipeline {
        let promise = JSPromise(jsObject.createComputePipelineAsync!(descriptor.toJSObject()).object!)!
        let result = try await promise.value
        return GPUComputePipeline(jsObject: result.object!)
    }

    /// Creates a render pipeline asynchronously.
    public func createRenderPipelineAsync(descriptor: GPURenderPipelineDescriptor) async throws -> GPURenderPipeline {
        let promise = JSPromise(jsObject.createRenderPipelineAsync!(descriptor.toJSObject()).object!)!
        let result = try await promise.value
        return GPURenderPipeline(jsObject: result.object!)
    }

    /// Creates a command encoder.
    public func createCommandEncoder(descriptor: GPUCommandEncoderDescriptor? = nil) -> GPUCommandEncoder {
        let jsEncoder: JSObject
        if let descriptor = descriptor {
            jsEncoder = jsObject.createCommandEncoder!(descriptor.toJSObject()).object!
        } else {
            jsEncoder = jsObject.createCommandEncoder!().object!
        }
        return GPUCommandEncoder(jsObject: jsEncoder)
    }

    /// Creates a render bundle encoder.
    public func createRenderBundleEncoder(descriptor: GPURenderBundleEncoderDescriptor) -> GPURenderBundleEncoder {
        let jsEncoder = jsObject.createRenderBundleEncoder!(descriptor.toJSObject()).object!
        return GPURenderBundleEncoder(jsObject: jsEncoder)
    }

    /// Creates a query set.
    public func createQuerySet(descriptor: GPUQuerySetDescriptor) -> GPUQuerySet {
        let jsQuerySet = jsObject.createQuerySet!(descriptor.toJSObject()).object!
        return GPUQuerySet(jsObject: jsQuerySet)
    }

    /// Imports an external texture from a video element or video frame.
    ///
    /// External textures are used for efficiently sampling video frames in shaders.
    /// They expire at the end of the task that created them.
    ///
    /// - Parameter descriptor: The descriptor for the external texture.
    /// - Returns: A new `GPUExternalTexture`.
    public func importExternalTexture(descriptor: GPUExternalTextureDescriptor) -> GPUExternalTexture {
        let jsTexture = jsObject.importExternalTexture!(descriptor.toJSObject()).object!
        return GPUExternalTexture(jsObject: jsTexture)
    }

    // MARK: - Error Handling

    /// Pushes an error scope.
    public func pushErrorScope(filter: GPUErrorFilter) {
        _ = jsObject.pushErrorScope!(filter.rawValue)
    }

    /// Pops an error scope and returns any error.
    public func popErrorScope() async throws -> GPUError? {
        let promise = JSPromise(jsObject.popErrorScope!().object!)!
        let result = try await promise.value
        guard !result.isNull && !result.isUndefined else {
            return nil
        }
        return GPUError(jsObject: result.object!)
    }

    /// Destroys this device.
    public func destroy() {
        _ = jsObject.destroy!()
    }
}

// MARK: - GPUError

/// A GPU error base type.
public protocol GPUErrorProtocol: Sendable {
    /// The error message.
    var message: String { get }
}

/// A GPU error.
public struct GPUError: GPUErrorProtocol, @unchecked Sendable {
    let jsObject: JSObject

    init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    /// The error message.
    public var message: String {
        jsObject.message.string ?? ""
    }

    /// Returns the specific error type if it can be determined.
    public func asValidationError() -> GPUValidationError? {
        // Check if this is a GPUValidationError by checking constructor name
        let constructorName = jsObject.constructor.name.string
        if constructorName == "GPUValidationError" {
            return GPUValidationError(jsObject: jsObject)
        }
        return nil
    }

    /// Returns the specific error type if it can be determined.
    public func asOutOfMemoryError() -> GPUOutOfMemoryError? {
        let constructorName = jsObject.constructor.name.string
        if constructorName == "GPUOutOfMemoryError" {
            return GPUOutOfMemoryError(jsObject: jsObject)
        }
        return nil
    }

    /// Returns the specific error type if it can be determined.
    public func asInternalError() -> GPUInternalError? {
        let constructorName = jsObject.constructor.name.string
        if constructorName == "GPUInternalError" {
            return GPUInternalError(jsObject: jsObject)
        }
        return nil
    }
}

// MARK: - GPUValidationError

/// A validation error from the GPU.
public struct GPUValidationError: GPUErrorProtocol, @unchecked Sendable {
    private let jsObject: JSObject

    init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    /// Creates a new validation error.
    public init(message: String) {
        self.jsObject = JSObject.global.GPUValidationError.function!.new(message)
    }

    /// The error message.
    public var message: String {
        jsObject.message.string ?? ""
    }
}

// MARK: - GPUOutOfMemoryError

/// An out-of-memory error from the GPU.
public struct GPUOutOfMemoryError: GPUErrorProtocol, @unchecked Sendable {
    private let jsObject: JSObject

    init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    /// Creates a new out-of-memory error.
    public init(message: String) {
        self.jsObject = JSObject.global.GPUOutOfMemoryError.function!.new(message)
    }

    /// The error message.
    public var message: String {
        jsObject.message.string ?? ""
    }
}

// MARK: - GPUInternalError

/// An internal error from the GPU.
public struct GPUInternalError: GPUErrorProtocol, @unchecked Sendable {
    private let jsObject: JSObject

    init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    /// Creates a new internal error.
    public init(message: String) {
        self.jsObject = JSObject.global.GPUInternalError.function!.new(message)
    }

    /// The error message.
    public var message: String {
        jsObject.message.string ?? ""
    }
}

// MARK: - GPUPipelineError

/// An error that occurred during pipeline creation.
public struct GPUPipelineError: Error, @unchecked Sendable {
    private let jsObject: JSObject

    init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    /// Creates a new pipeline error.
    public init(message: String, reason: GPUPipelineErrorReason) {
        let options = JSObject.global.Object.function!.new()
        options.reason = .string(reason.rawValue)
        self.jsObject = JSObject.global.GPUPipelineError.function!.new(message, options)
    }

    /// The error message.
    public var message: String {
        jsObject.message.string ?? ""
    }

    /// The reason for the pipeline error.
    public var reason: GPUPipelineErrorReason {
        let reasonStr = jsObject.reason.string ?? "internal"
        return GPUPipelineErrorReason(rawValue: reasonStr) ?? .internal
    }
}

/// The reason for a pipeline error.
public enum GPUPipelineErrorReason: String, Sendable {
    case validation = "validation"
    case `internal` = "internal"
}

// MARK: - GPUDeviceLostInfo

/// Information about a lost device.
public struct GPUDeviceLostInfo: @unchecked Sendable {
    private let jsObject: JSObject

    init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    /// The reason the device was lost.
    public var reason: GPUDeviceLostReason {
        let reasonStr = jsObject.reason.string ?? "unknown"
        return GPUDeviceLostReason(rawValue: reasonStr) ?? .unknown
    }

    /// A message describing the loss.
    public var message: String {
        jsObject.message.string ?? ""
    }
}

// MARK: - GPUUncapturedErrorEvent

/// An event fired when an uncaptured GPU error occurs.
public struct GPUUncapturedErrorEvent: @unchecked Sendable {
    private let jsObject: JSObject

    init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    /// The error that was not captured.
    public var error: GPUError {
        GPUError(jsObject: jsObject.error.object!)
    }
}
