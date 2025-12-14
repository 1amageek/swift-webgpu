import JavaScriptKit

/// A GPU canvas context for rendering to a canvas.
///
/// ```swift
/// let canvas = JSObject.global.document.getElementById!("canvas").object!
/// let context = GPUCanvasContext(canvas: canvas)
/// context.configure(GPUCanvasConfiguration(device: device, format: gpu.preferredCanvasFormat))
///
/// // In render loop:
/// let texture = context.getCurrentTexture()
/// let view = texture.createView()
/// ```
public final class GPUCanvasContext: @unchecked Sendable {
    /// The underlying JavaScript `GPUCanvasContext` object.
    let jsObject: JSObject

    /// Creates a canvas context from a canvas element.
    ///
    /// - Parameter canvas: The HTML canvas element.
    public init(canvas: JSObject) {
        self.jsObject = canvas.getContext!("webgpu").object!
    }

    /// Creates a canvas context from an existing context object.
    ///
    /// - Parameter jsObject: The JavaScript GPUCanvasContext object.
    public init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    /// The canvas element.
    public var canvas: JSObject {
        jsObject.canvas.object!
    }

    /// Configures the canvas context.
    public func configure(_ configuration: GPUCanvasConfiguration) {
        _ = jsObject.configure!(configuration.toJSObject())
    }

    /// Unconfigures the canvas context.
    public func unconfigure() {
        _ = jsObject.unconfigure!()
    }

    /// Gets the current configuration of the canvas context.
    ///
    /// Returns `nil` if the context has not been configured.
    public func getConfiguration() -> GPUCanvasConfigurationOut? {
        let result = jsObject.getConfiguration!()
        guard !result.isNull && !result.isUndefined else {
            return nil
        }
        return GPUCanvasConfigurationOut(jsObject: result.object!)
    }

    /// Gets the current texture for rendering.
    public func getCurrentTexture() -> GPUTexture {
        let jsTexture = jsObject.getCurrentTexture!().object!
        return GPUTexture(jsObject: jsTexture)
    }
}

// MARK: - GPUCanvasConfigurationOut

/// The returned configuration from getConfiguration().
public struct GPUCanvasConfigurationOut: @unchecked Sendable {
    private let jsObject: JSObject

    init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    /// The device used for rendering.
    public var device: GPUDevice {
        GPUDevice(jsObject: jsObject.device.object!)
    }

    /// The texture format.
    public var format: GPUTextureFormat {
        let fmt = jsObject.format.string ?? "bgra8unorm"
        return GPUTextureFormat(rawValue: fmt) ?? .bgra8unorm
    }

    /// The texture usage.
    public var usage: GPUTextureUsage {
        GPUTextureUsage(rawValue: UInt32(jsObject.usage.number ?? 0))
    }

    /// The view formats.
    public var viewFormats: [GPUTextureFormat] {
        var result: [GPUTextureFormat] = []
        guard let formatsArray = jsObject.viewFormats.object else { return result }
        let length = Int(formatsArray.length.number ?? 0)
        for i in 0..<length {
            if let formatStr = formatsArray[i].string,
               let format = GPUTextureFormat(rawValue: formatStr) {
                result.append(format)
            }
        }
        return result
    }

    /// The color space.
    public var colorSpace: GPUPredefinedColorSpace {
        let cs = jsObject.colorSpace.string ?? "srgb"
        return GPUPredefinedColorSpace(rawValue: cs) ?? .srgb
    }

    /// The alpha mode.
    public var alphaMode: GPUCanvasAlphaMode {
        let mode = jsObject.alphaMode.string ?? "opaque"
        return GPUCanvasAlphaMode(rawValue: mode) ?? .opaque
    }
}

// MARK: - GPUCanvasConfiguration

/// Configuration for a canvas context.
public struct GPUCanvasConfiguration: @unchecked Sendable {
    /// The device to use.
    public var device: GPUDevice

    /// The texture format.
    public var format: GPUTextureFormat

    /// The texture usage.
    public var usage: GPUTextureUsage

    /// The view formats.
    public var viewFormats: [GPUTextureFormat]

    /// The color space.
    public var colorSpace: GPUPredefinedColorSpace

    /// The tone mapping.
    public var toneMapping: GPUCanvasToneMapping

    /// The alpha mode.
    public var alphaMode: GPUCanvasAlphaMode

    /// Creates a canvas configuration.
    public init(
        device: GPUDevice,
        format: GPUTextureFormat,
        usage: GPUTextureUsage = .renderAttachment,
        viewFormats: [GPUTextureFormat] = [],
        colorSpace: GPUPredefinedColorSpace = .srgb,
        toneMapping: GPUCanvasToneMapping = GPUCanvasToneMapping(),
        alphaMode: GPUCanvasAlphaMode = .opaque
    ) {
        self.device = device
        self.format = format
        self.usage = usage
        self.viewFormats = viewFormats
        self.colorSpace = colorSpace
        self.toneMapping = toneMapping
        self.alphaMode = alphaMode
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        obj.device = device.jsObject.jsValue
        obj.format = .string(format.rawValue)
        obj.usage = .number(Double(usage.rawValue))

        if !viewFormats.isEmpty {
            let formatsArray = JSObject.global.Array.function!.new()
            for (index, format) in viewFormats.enumerated() {
                formatsArray[index] = .string(format.rawValue)
            }
            obj.viewFormats = formatsArray.jsValue
        }

        obj.colorSpace = .string(colorSpace.rawValue)
        obj.toneMapping = toneMapping.toJSObject().jsValue
        obj.alphaMode = .string(alphaMode.rawValue)
        return obj
    }
}

// MARK: - GPUPredefinedColorSpace

/// A predefined color space.
public enum GPUPredefinedColorSpace: String, Sendable {
    case srgb = "srgb"
    case displayP3 = "display-p3"
}

// MARK: - GPUCanvasToneMapping

/// Tone mapping configuration for a canvas.
public struct GPUCanvasToneMapping: Sendable {
    /// The tone mapping mode.
    public var mode: GPUCanvasToneMappingMode

    public init(mode: GPUCanvasToneMappingMode = .standard) {
        self.mode = mode
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        obj.mode = .string(mode.rawValue)
        return obj
    }
}
