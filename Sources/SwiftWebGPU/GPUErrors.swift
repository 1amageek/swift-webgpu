import JavaScriptKit
import JavaScriptEventLoop

// MARK: - GPUError (Base Type)

/// Base protocol for GPU errors.
/// All GPU errors have a message property.
public protocol GPUErrorProtocol: Error, Sendable {
    /// A human-readable message explaining why the error occurred.
    var message: String { get }
}

// MARK: - GPUValidationError

/// An error indicating a validation failure in a WebGPU operation.
///
/// Validation errors occur when an operation violates the WebGPU specification,
/// such as providing invalid parameters to a function.
///
/// ```swift
/// device.pushErrorScope(.validation)
/// let sampler = device.createSampler(descriptor: GPUSamplerDescriptor(
///     maxAnisotropy: 0  // Invalid: must be at least 1
/// ))
/// if let error = try await device.popErrorScope() {
///     print("Validation error: \(error.message)")
/// }
/// ```
public struct GPUValidationError: GPUErrorProtocol {
    public let message: String

    /// A human-readable message explaining why the error occurred.
    init(jsObject: JSObject) {
        self.message = jsObject.message.string ?? ""
    }

    /// Creates a new validation error with the specified message.
    ///
    /// - Parameter message: A human-readable description of the error.
    public init(message: String) {
        self.message = message
    }

    /// Creates a JavaScript GPUValidationError object.
    public func toJSObject() -> JSObject {
        JSObject.global.GPUValidationError.function!.new(message)
    }
}

// MARK: - GPUOutOfMemoryError

/// An error indicating a WebGPU operation failed due to insufficient memory.
///
/// Out-of-memory errors occur when the GPU cannot allocate sufficient memory
/// for a requested resource.
///
/// ```swift
/// device.pushErrorScope(.outOfMemory)
/// let buffer = device.createBuffer(descriptor: GPUBufferDescriptor(
///     size: 100_000_000_000,  // 100GB - too large
///     usage: [.copySrc, .mapWrite]
/// ))
/// if let error = try await device.popErrorScope() {
///     print("Out of memory: \(error.message)")
/// }
/// ```
public struct GPUOutOfMemoryError: GPUErrorProtocol {
    public let message: String

    /// A human-readable message explaining why the error occurred.
    init(jsObject: JSObject) {
        self.message = jsObject.message.string ?? ""
    }

    /// Creates a new out-of-memory error with the specified message.
    ///
    /// - Parameter message: A human-readable description of the error.
    public init(message: String) {
        self.message = message
    }

    /// Creates a JavaScript GPUOutOfMemoryError object.
    public func toJSObject() -> JSObject {
        JSObject.global.GPUOutOfMemoryError.function!.new(message)
    }
}

// MARK: - GPUInternalError

/// An error indicating a WebGPU operation failed due to a system or implementation-specific reason.
///
/// Internal errors occur when an operation fails even though all validation requirements
/// were satisfied. This can happen when:
/// - An operation hits a system limit not expressible via WebGPU's supported limits
/// - A shader is too complex for the device during pipeline creation
///
/// The same operation might succeed on a different device.
///
/// ```swift
/// device.pushErrorScope(.internal)
/// let module = device.createShaderModule(descriptor: GPUShaderModuleDescriptor(
///     code: veryComplexShader
/// ))
/// if let error = try await device.popErrorScope() {
///     print("Internal error: \(error.message)")
/// }
/// ```
public struct GPUInternalError: GPUErrorProtocol {
    public let message: String

    /// A human-readable message explaining why the error occurred.
    init(jsObject: JSObject) {
        self.message = jsObject.message.string ?? ""
    }

    /// Creates a new internal error with the specified message.
    ///
    /// - Parameter message: A human-readable description of the error.
    public init(message: String) {
        self.message = message
    }

    /// Creates a JavaScript GPUInternalError object.
    public func toJSObject() -> JSObject {
        JSObject.global.GPUInternalError.function!.new(message)
    }
}

// MARK: - GPUPipelineError

/// An error that occurred during async pipeline creation.
///
/// Pipeline errors are thrown when `createRenderPipelineAsync()` or
/// `createComputePipelineAsync()` fails.
///
/// ```swift
/// do {
///     let pipeline = try await device.createRenderPipelineAsync(descriptor: descriptor)
/// } catch let error as GPUPipelineError {
///     print("Pipeline creation failed (\(error.reason)): \(error.message)")
/// }
/// ```
public struct GPUPipelineError: Error, Sendable {
    public let message: String
    public let reason: GPUPipelineErrorReason

    /// A human-readable message explaining why the error occurred.
    init(jsObject: JSObject) {
        self.message = jsObject.message.string ?? ""
        self.reason = jsObject.reason.string
            .flatMap(GPUPipelineErrorReason.init(rawValue:)) ?? .internal
    }

    /// Creates a new pipeline error.
    ///
    /// - Parameters:
    ///   - message: A human-readable description of the error.
    ///   - reason: The reason for the pipeline error.
    public init(message: String, reason: GPUPipelineErrorReason) {
        self.message = message
        self.reason = reason
    }

    /// Creates a JavaScript GPUPipelineError object.
    public func toJSObject() -> JSObject {
        let options = JSObject.global.Object.function!.new()
        options.reason = .string(reason.rawValue)
        return JSObject.global.GPUPipelineError.function!.new(message, options)
    }
}

/// The reason for a pipeline error.
public enum GPUPipelineErrorReason: String, Sendable {
    /// Pipeline creation failed due to a validation error.
    case validation = "validation"
    /// Pipeline creation failed due to an internal error.
    case `internal` = "internal"
}

// MARK: - GPURequestDeviceError

/// Error thrown when requesting a GPU device fails.
public enum GPURequestDeviceError: Error, Sendable {
    /// The requested limits are not supported by the adapter,
    /// or the adapter has already been consumed.
    case operationError(message: String)

    /// The requested features are not supported by the adapter.
    case typeError(message: String)
}

// MARK: - GPUBufferMapError

/// Error thrown when buffer mapping fails.
public enum GPUBufferMapError: Error, Sendable {
    /// Validation error during mapping.
    case validation(message: String)
    /// The buffer was destroyed before mapping completed.
    case aborted
    /// Unknown error.
    case unknown(message: String)
}

/// A rejection from a JavaScript promise that does not define a more specific
/// WebGPU error contract.
public struct GPUJavaScriptPromiseError: Error, Sendable {
    public let name: String
    public let message: String

    init(jsValue: JSValue) {
        self.name = jsValue.object?.name.string ?? "Error"
        self.message = jsValue.object?.message.string ?? "JavaScript promise rejected"
    }
}

// MARK: - Error Scope Result

/// The result of popping an error scope.
/// Returns one of the GPU error types, or nil if no error occurred.
public enum GPUScopeError: Sendable {
    case validation(GPUValidationError)
    case outOfMemory(GPUOutOfMemoryError)
    case `internal`(GPUInternalError)

    init?(jsObject: JSObject?) {
        guard let jsObject = jsObject else { return nil }

        // Check if null or undefined
        let jsValue = jsObject.jsValue
        if jsValue.isNull || jsValue.isUndefined {
            return nil
        }

        // Determine error type by constructor name
        let constructorName = jsObject.constructor.name.string ?? ""
        switch constructorName {
        case "GPUValidationError":
            self = .validation(GPUValidationError(jsObject: jsObject))
        case "GPUOutOfMemoryError":
            self = .outOfMemory(GPUOutOfMemoryError(jsObject: jsObject))
        case "GPUInternalError":
            self = .internal(GPUInternalError(jsObject: jsObject))
        default:
            // Fallback: treat as validation error
            self = .validation(GPUValidationError(jsObject: jsObject))
        }
    }

    /// The error message.
    public var message: String {
        switch self {
        case .validation(let error): return error.message
        case .outOfMemory(let error): return error.message
        case .internal(let error): return error.message
        }
    }
}

// MARK: - Promise Helpers

/// Awaits a JavaScript Promise and returns its fulfilled value.
/// Preserves the caller's actor isolation while awaiting the promise value.
@inline(__always)
public func awaitPromise(
    _ promise: JSPromise,
    isolation: isolated (any Actor)? = #isolation
) async throws(GPUJavaScriptPromiseError) -> JSValue {
    do {
        return try await promise.value(isolation: isolation)
    } catch let error {
        throw GPUJavaScriptPromiseError(jsValue: error.thrownValue)
    }
}

/// Awaits a JavaScript Promise that may reject with a GPURequestDeviceError.
@inline(__always)
func awaitDeviceRequest(
    _ promise: JSPromise,
    isolation: isolated (any Actor)? = #isolation
) async -> Result<JSValue, GPURequestDeviceError> {
    do {
        return .success(try await promise.value(isolation: isolation))
    } catch let exception {
        let name = exception.thrownValue.object?.name.string ?? ""
        let message = exception.thrownValue.object?.message.string ?? "Unknown error"

        let swiftError: GPURequestDeviceError
        switch name {
        case "TypeError":
            swiftError = .typeError(message: message)
        default:
            swiftError = .operationError(message: message)
        }
        return .failure(swiftError)
    }
}

/// Awaits a JavaScript Promise that may reject with a GPUPipelineError.
@inline(__always)
func awaitPipelineCreation(
    _ promise: JSPromise,
    isolation: isolated (any Actor)? = #isolation
) async -> Result<JSValue, GPUPipelineError> {
    do {
        return .success(try await promise.value(isolation: isolation))
    } catch let exception {
        let pipelineError: GPUPipelineError
        if let obj = exception.thrownValue.object {
            pipelineError = GPUPipelineError(jsObject: obj)
        } else {
            pipelineError = GPUPipelineError(message: "Unknown error", reason: .internal)
        }
        return .failure(pipelineError)
    }
}

/// Awaits a JavaScript Promise that may reject with a GPUBufferMapError.
@inline(__always)
func awaitBufferMap(
    _ promise: JSPromise,
    isolation: isolated (any Actor)? = #isolation
) async -> Result<Void, GPUBufferMapError> {
    do {
        _ = try await promise.value(isolation: isolation)
        return .success(())
    } catch let exception {
        let name = exception.thrownValue.object?.name.string ?? ""
        let message = exception.thrownValue.object?.message.string ?? "Unknown error"

        let swiftError: GPUBufferMapError
        switch name {
        case "AbortError":
            swiftError = .aborted
        case "OperationError":
            swiftError = .validation(message: message)
        default:
            swiftError = .unknown(message: message)
        }
        return .failure(swiftError)
    }
}
