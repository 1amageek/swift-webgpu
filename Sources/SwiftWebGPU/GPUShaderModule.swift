import JavaScriptKit

/// A GPU shader module containing compiled shader code.
///
/// ```swift
/// let shaderModule = device.createShaderModule(descriptor: GPUShaderModuleDescriptor(
///     code: """
///     @vertex fn vs_main(@location(0) pos: vec2f) -> @builtin(position) vec4f {
///         return vec4f(pos, 0.0, 1.0);
///     }
///
///     @fragment fn fs_main() -> @location(0) vec4f {
///         return vec4f(1.0, 0.0, 0.0, 1.0);
///     }
///     """
/// ))
/// ```
public final class GPUShaderModule: @unchecked Sendable {
    /// The underlying JavaScript `GPUShaderModule` object.
    let jsObject: JSObject

    init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    /// The label of this shader module.
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

    /// Gets compilation information for this shader module.
    public func getCompilationInfo() async throws -> GPUCompilationInfo {
        let promise = JSPromise(jsObject.getCompilationInfo!().object!)!
        let result = try await promise.value
        return GPUCompilationInfo(jsObject: result.object!)
    }
}

// MARK: - GPUShaderModuleDescriptor

/// Descriptor for creating a shader module.
public struct GPUShaderModuleDescriptor: @unchecked Sendable {
    /// The WGSL shader code.
    public var code: String

    /// Source map for debugging.
    public var sourceMap: JSObject?

    /// Compilation hints.
    public var compilationHints: [GPUShaderModuleCompilationHint]

    /// A label for the shader module.
    public var label: String?

    /// Creates a shader module descriptor.
    public init(
        code: String,
        sourceMap: JSObject? = nil,
        compilationHints: [GPUShaderModuleCompilationHint] = [],
        label: String? = nil
    ) {
        self.code = code
        self.sourceMap = sourceMap
        self.compilationHints = compilationHints
        self.label = label
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        obj.code = .string(code)

        if let sourceMap = sourceMap {
            obj.sourceMap = sourceMap.jsValue
        }

        if !compilationHints.isEmpty {
            let hintsArray = JSObject.global.Array.function!.new()
            for (index, hint) in compilationHints.enumerated() {
                hintsArray[index] = hint.toJSObject().jsValue
            }
            obj.compilationHints = hintsArray.jsValue
        }

        if let label = label {
            obj.label = .string(label)
        }
        return obj
    }
}

// MARK: - GPUShaderModuleCompilationHint

/// A hint for shader compilation.
public struct GPUShaderModuleCompilationHint: Sendable {
    /// The entry point name.
    public var entryPoint: String

    /// The pipeline layout to use for compilation.
    public var layout: GPUPipelineLayoutOrAuto

    public init(entryPoint: String, layout: GPUPipelineLayoutOrAuto) {
        self.entryPoint = entryPoint
        self.layout = layout
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        obj.entryPoint = .string(entryPoint)
        obj.layout = layout.toJSValue()
        return obj
    }
}

// MARK: - GPUPipelineLayoutOrAuto

/// Either a pipeline layout or "auto".
public enum GPUPipelineLayoutOrAuto: Sendable {
    case layout(GPUPipelineLayout)
    case auto

    func toJSValue() -> JSValue {
        switch self {
        case .layout(let layout):
            return layout.jsObject.jsValue
        case .auto:
            return .string("auto")
        }
    }
}

// MARK: - GPUCompilationInfo

/// Information about shader compilation.
public struct GPUCompilationInfo: @unchecked Sendable {
    private let jsObject: JSObject

    init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    /// The compilation messages.
    public var messages: [GPUCompilationMessage] {
        var result: [GPUCompilationMessage] = []
        let jsMessages = jsObject.messages
        let length = Int(jsMessages.length.number ?? 0)
        for i in 0..<length {
            if let msgObj = jsMessages[i].object {
                result.append(GPUCompilationMessage(jsObject: msgObj))
            }
        }
        return result
    }
}

// MARK: - GPUCompilationMessage

/// A message from shader compilation.
public struct GPUCompilationMessage: @unchecked Sendable {
    private let jsObject: JSObject

    init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    /// The message text.
    public var message: String {
        jsObject.message.string ?? ""
    }

    /// The message type.
    public var type: GPUCompilationMessageType {
        let typeStr = jsObject.type.string ?? "info"
        return GPUCompilationMessageType(rawValue: typeStr) ?? .info
    }

    /// The line number (1-based).
    public var lineNum: UInt64 {
        UInt64(jsObject.lineNum.number ?? 0)
    }

    /// The position within the line.
    public var linePos: UInt64 {
        UInt64(jsObject.linePos.number ?? 0)
    }

    /// The offset in the source.
    public var offset: UInt64 {
        UInt64(jsObject.offset.number ?? 0)
    }

    /// The length of the relevant source span.
    public var length: UInt64 {
        UInt64(jsObject.length.number ?? 0)
    }
}

// MARK: - GPUCompilationMessageType

/// The type of a compilation message.
public enum GPUCompilationMessageType: String, Sendable {
    case error = "error"
    case warning = "warning"
    case info = "info"
}
