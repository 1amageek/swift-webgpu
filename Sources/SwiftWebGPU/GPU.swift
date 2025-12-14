import JavaScriptKit
import JavaScriptEventLoop

/// Entry point to the WebGPU API via `navigator.gpu`.
///
/// Use `GPU.shared` to access the WebGPU entry point.
///
/// ```swift
/// guard let gpu = GPU.shared else {
///     print("WebGPU not supported")
///     return
/// }
/// let adapter = try await gpu.requestAdapter()
/// ```
public final class GPU: @unchecked Sendable {
    /// The underlying JavaScript `GPU` object.
    private let jsObject: JSObject

    /// The shared GPU instance from `navigator.gpu`.
    ///
    /// Returns `nil` if WebGPU is not supported in the current environment.
    public static var shared: GPU? {
        let navigator = JSObject.global.navigator
        guard let gpuObject = navigator.gpu.object else {
            return nil
        }
        return GPU(jsObject: gpuObject)
    }

    private init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    /// Requests an adapter from the GPU.
    ///
    /// This method does not throw. If no adapter is available, it returns `nil`.
    ///
    /// - Parameter options: Options for adapter selection.
    /// - Returns: A `GPUAdapter` if one is available, `nil` otherwise.
    public func requestAdapter(options: GPURequestAdapterOptions? = nil) async -> GPUAdapter? {
        let promise: JSPromise
        if let options = options {
            promise = JSPromise(jsObject.requestAdapter!(options.toJSObject()).object!)!
        } else {
            promise = JSPromise(jsObject.requestAdapter!().object!)!
        }

        let result = await awaitPromise(promise)
        guard !result.isNull && !result.isUndefined else {
            return nil
        }
        return GPUAdapter(jsObject: result.object!)
    }

    /// Returns the preferred canvas format for the current system.
    public var preferredCanvasFormat: GPUTextureFormat {
        let format = jsObject.getPreferredCanvasFormat!().string!
        return GPUTextureFormat(rawValue: format) ?? .bgra8unorm
    }

    /// The WebGPU string identifier for this API.
    public var wgslLanguageFeatures: Set<String> {
        var features: Set<String> = []
        let jsFeatures = jsObject.wgslLanguageFeatures
        // Iterate through the Set-like object
        let iterator = jsFeatures.values().object!
        while true {
            let next = iterator.next!().object!
            if next.done.boolean == true {
                break
            }
            if let value = next.value.string {
                features.insert(value)
            }
        }
        return features
    }
}

// MARK: - Request Adapter Options

/// Options for requesting a GPU adapter.
public struct GPURequestAdapterOptions: Sendable {
    /// The power preference for the adapter.
    public var powerPreference: GPUPowerPreference?

    /// Whether to force a fallback adapter.
    public var forceFallbackAdapter: Bool

    /// Creates adapter request options.
    public init(
        powerPreference: GPUPowerPreference? = nil,
        forceFallbackAdapter: Bool = false
    ) {
        self.powerPreference = powerPreference
        self.forceFallbackAdapter = forceFallbackAdapter
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        if let powerPreference = powerPreference {
            obj.powerPreference = .string(powerPreference.rawValue)
        }
        obj.forceFallbackAdapter = .boolean(forceFallbackAdapter)
        return obj
    }
}
