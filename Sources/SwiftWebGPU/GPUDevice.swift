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
    ///
    /// This method does not throw - it always resolves when the device becomes lost.
    public func lost() async -> GPUDeviceLostInfo {
        let promise = JSPromise(jsObject.lost.object!)!
        let result = await awaitPromise(promise)
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
    ///
    /// - Parameter descriptor: The compute pipeline descriptor.
    /// - Returns: A new compute pipeline.
    /// - Throws: `GPUPipelineError` if pipeline creation fails.
    public func createComputePipelineAsync(descriptor: GPUComputePipelineDescriptor) async throws(GPUPipelineError) -> GPUComputePipeline {
        let promise = JSPromise(jsObject.createComputePipelineAsync!(descriptor.toJSObject()).object!)!
        let result = await awaitPipelineCreation(promise)
        switch result {
        case .success(let value):
            return GPUComputePipeline(jsObject: value.object!)
        case .failure(let error):
            throw error
        }
    }

    /// Creates a render pipeline asynchronously.
    ///
    /// - Parameter descriptor: The render pipeline descriptor.
    /// - Returns: A new render pipeline.
    /// - Throws: `GPUPipelineError` if pipeline creation fails.
    public func createRenderPipelineAsync(descriptor: GPURenderPipelineDescriptor) async throws(GPUPipelineError) -> GPURenderPipeline {
        let promise = JSPromise(jsObject.createRenderPipelineAsync!(descriptor.toJSObject()).object!)!
        let result = await awaitPipelineCreation(promise)
        switch result {
        case .success(let value):
            return GPURenderPipeline(jsObject: value.object!)
        case .failure(let error):
            throw error
        }
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

    /// Pops an error scope and returns any error that was captured.
    ///
    /// - Returns: A `GPUScopeError` if an error was captured, `nil` otherwise.
    public func popErrorScope() async -> GPUScopeError? {
        let promise = JSPromise(jsObject.popErrorScope!().object!)!
        let result = await awaitPromise(promise)
        guard !result.isNull && !result.isUndefined else {
            return nil
        }
        return GPUScopeError(jsObject: result.object)
    }

    /// Destroys this device.
    public func destroy() {
        _ = jsObject.destroy!()
    }
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
    ///
    /// Returns `nil` if the error type could not be determined.
    public var error: GPUScopeError? {
        GPUScopeError(jsObject: jsObject.error.object)
    }
}
