import JavaScriptKit

/// A GPU render pipeline for rendering operations.
///
/// ```swift
/// let pipeline = device.createRenderPipeline(descriptor: GPURenderPipelineDescriptor(
///     vertex: GPUVertexState(
///         module: shaderModule,
///         entryPoint: "vs_main",
///         buffers: [vertexBufferLayout]
///     ),
///     fragment: GPUFragmentState(
///         module: shaderModule,
///         entryPoint: "fs_main",
///         targets: [GPUColorTargetState(format: .bgra8unorm)]
///     )
/// ))
/// ```
public final class GPURenderPipeline: @unchecked Sendable {
    /// The underlying JavaScript `GPURenderPipeline` object.
    let jsObject: JSObject

    init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    /// The label of this pipeline.
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

    /// Gets the bind group layout at the specified index.
    public func getBindGroupLayout(index: UInt32) -> GPUBindGroupLayout {
        let layout = jsObject.getBindGroupLayout!(Double(index)).object!
        return GPUBindGroupLayout(jsObject: layout)
    }
}

// MARK: - GPUComputePipeline

/// A GPU compute pipeline for compute operations.
public final class GPUComputePipeline: @unchecked Sendable {
    /// The underlying JavaScript `GPUComputePipeline` object.
    let jsObject: JSObject

    init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    /// The label of this pipeline.
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

    /// Gets the bind group layout at the specified index.
    public func getBindGroupLayout(index: UInt32) -> GPUBindGroupLayout {
        let layout = jsObject.getBindGroupLayout!(Double(index)).object!
        return GPUBindGroupLayout(jsObject: layout)
    }
}

// MARK: - GPURenderPipelineDescriptor

/// Descriptor for creating a render pipeline.
public struct GPURenderPipelineDescriptor: Sendable {
    /// The vertex state.
    public var vertex: GPUVertexState

    /// The primitive state.
    public var primitive: GPUPrimitiveState

    /// The depth/stencil state.
    public var depthStencil: GPUDepthStencilState?

    /// The multisample state.
    public var multisample: GPUMultisampleState

    /// The fragment state.
    public var fragment: GPUFragmentState?

    /// The pipeline layout.
    public var layout: GPUPipelineLayoutOrAuto

    /// A label for the pipeline.
    public var label: String?

    /// Creates a render pipeline descriptor.
    public init(
        vertex: GPUVertexState,
        primitive: GPUPrimitiveState = GPUPrimitiveState(),
        depthStencil: GPUDepthStencilState? = nil,
        multisample: GPUMultisampleState = GPUMultisampleState(),
        fragment: GPUFragmentState? = nil,
        layout: GPUPipelineLayoutOrAuto = .auto,
        label: String? = nil
    ) {
        self.vertex = vertex
        self.primitive = primitive
        self.depthStencil = depthStencil
        self.multisample = multisample
        self.fragment = fragment
        self.layout = layout
        self.label = label
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        obj.vertex = vertex.toJSObject().jsValue
        obj.primitive = primitive.toJSObject().jsValue

        if let depthStencil = depthStencil {
            obj.depthStencil = depthStencil.toJSObject().jsValue
        }

        obj.multisample = multisample.toJSObject().jsValue

        if let fragment = fragment {
            obj.fragment = fragment.toJSObject().jsValue
        }

        obj.layout = layout.toJSValue()

        if let label = label {
            obj.label = .string(label)
        }
        return obj
    }
}

// MARK: - GPUComputePipelineDescriptor

/// Descriptor for creating a compute pipeline.
public struct GPUComputePipelineDescriptor: Sendable {
    /// The compute state.
    public var compute: GPUProgrammableStage

    /// The pipeline layout.
    public var layout: GPUPipelineLayoutOrAuto

    /// A label for the pipeline.
    public var label: String?

    /// Creates a compute pipeline descriptor.
    public init(
        compute: GPUProgrammableStage,
        layout: GPUPipelineLayoutOrAuto = .auto,
        label: String? = nil
    ) {
        self.compute = compute
        self.layout = layout
        self.label = label
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        obj.compute = compute.toJSObject().jsValue
        obj.layout = layout.toJSValue()
        if let label = label {
            obj.label = .string(label)
        }
        return obj
    }
}

// MARK: - GPUProgrammableStage

/// A programmable stage in a pipeline.
public struct GPUProgrammableStage: Sendable {
    /// The shader module.
    public var module: GPUShaderModule

    /// The entry point function name.
    public var entryPoint: String?

    /// Constants to substitute in the shader.
    public var constants: [String: Double]

    public init(
        module: GPUShaderModule,
        entryPoint: String? = nil,
        constants: [String: Double] = [:]
    ) {
        self.module = module
        self.entryPoint = entryPoint
        self.constants = constants
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        obj.module = module.jsObject.jsValue
        if let entryPoint = entryPoint {
            obj.entryPoint = .string(entryPoint)
        }
        if !constants.isEmpty {
            let constantsObj = JSObject.global.Object.function!.new()
            for (key, value) in constants {
                constantsObj[key] = .number(value)
            }
            obj.constants = constantsObj.jsValue
        }
        return obj
    }
}

// MARK: - GPUVertexState

/// The vertex state for a render pipeline.
public struct GPUVertexState: Sendable {
    /// The shader module.
    public var module: GPUShaderModule

    /// The entry point function name.
    public var entryPoint: String?

    /// Constants to substitute in the shader.
    public var constants: [String: Double]

    /// The vertex buffer layouts.
    public var buffers: [GPUVertexBufferLayout?]

    public init(
        module: GPUShaderModule,
        entryPoint: String? = nil,
        constants: [String: Double] = [:],
        buffers: [GPUVertexBufferLayout?] = []
    ) {
        self.module = module
        self.entryPoint = entryPoint
        self.constants = constants
        self.buffers = buffers
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        obj.module = module.jsObject.jsValue
        if let entryPoint = entryPoint {
            obj.entryPoint = .string(entryPoint)
        }
        if !constants.isEmpty {
            let constantsObj = JSObject.global.Object.function!.new()
            for (key, value) in constants {
                constantsObj[key] = .number(value)
            }
            obj.constants = constantsObj.jsValue
        }
        if !buffers.isEmpty {
            let buffersArray = JSObject.global.Array.function!.new()
            for (index, buffer) in buffers.enumerated() {
                if let buffer = buffer {
                    buffersArray[index] = buffer.toJSObject().jsValue
                } else {
                    buffersArray[index] = .null
                }
            }
            obj.buffers = buffersArray.jsValue
        }
        return obj
    }
}

// MARK: - GPUVertexBufferLayout

/// The layout of a vertex buffer.
public struct GPUVertexBufferLayout: Sendable {
    /// The stride in bytes between vertices.
    public var arrayStride: UInt64

    /// The step mode.
    public var stepMode: GPUVertexStepMode

    /// The vertex attributes.
    public var attributes: [GPUVertexAttribute]

    public init(
        arrayStride: UInt64,
        stepMode: GPUVertexStepMode = .vertex,
        attributes: [GPUVertexAttribute]
    ) {
        self.arrayStride = arrayStride
        self.stepMode = stepMode
        self.attributes = attributes
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        obj.arrayStride = .number(Double(arrayStride))
        obj.stepMode = .string(stepMode.rawValue)

        let attrsArray = JSObject.global.Array.function!.new()
        for (index, attr) in attributes.enumerated() {
            attrsArray[index] = attr.toJSObject().jsValue
        }
        obj.attributes = attrsArray.jsValue
        return obj
    }
}

// MARK: - GPUVertexAttribute

/// A vertex attribute.
public struct GPUVertexAttribute: Sendable {
    /// The format of the attribute.
    public var format: GPUVertexFormat

    /// The offset in bytes.
    public var offset: UInt64

    /// The shader location.
    public var shaderLocation: UInt32

    public init(format: GPUVertexFormat, offset: UInt64, shaderLocation: UInt32) {
        self.format = format
        self.offset = offset
        self.shaderLocation = shaderLocation
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        obj.format = .string(format.rawValue)
        obj.offset = .number(Double(offset))
        obj.shaderLocation = .number(Double(shaderLocation))
        return obj
    }
}

// MARK: - GPUPrimitiveState

/// The primitive state for a render pipeline.
public struct GPUPrimitiveState: Sendable {
    /// The primitive topology.
    public var topology: GPUPrimitiveTopology

    /// The index format for strips.
    public var stripIndexFormat: GPUIndexFormat?

    /// The front face winding order.
    public var frontFace: GPUFrontFace

    /// The cull mode.
    public var cullMode: GPUCullMode

    /// Whether to clip depths to [0, 1].
    public var unclippedDepth: Bool

    public init(
        topology: GPUPrimitiveTopology = .triangleList,
        stripIndexFormat: GPUIndexFormat? = nil,
        frontFace: GPUFrontFace = .ccw,
        cullMode: GPUCullMode = .none,
        unclippedDepth: Bool = false
    ) {
        self.topology = topology
        self.stripIndexFormat = stripIndexFormat
        self.frontFace = frontFace
        self.cullMode = cullMode
        self.unclippedDepth = unclippedDepth
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        obj.topology = .string(topology.rawValue)
        if let stripIndexFormat = stripIndexFormat {
            obj.stripIndexFormat = .string(stripIndexFormat.rawValue)
        }
        obj.frontFace = .string(frontFace.rawValue)
        obj.cullMode = .string(cullMode.rawValue)
        obj.unclippedDepth = .boolean(unclippedDepth)
        return obj
    }
}

// MARK: - GPUDepthStencilState

/// The depth/stencil state for a render pipeline.
public struct GPUDepthStencilState: Sendable {
    /// The format of the depth/stencil attachment.
    public var format: GPUTextureFormat

    /// Whether depth writing is enabled.
    public var depthWriteEnabled: Bool?

    /// The depth comparison function.
    public var depthCompare: GPUCompareFunction?

    /// The stencil state for front-facing primitives.
    public var stencilFront: GPUStencilFaceState

    /// The stencil state for back-facing primitives.
    public var stencilBack: GPUStencilFaceState

    /// The stencil read mask.
    public var stencilReadMask: UInt32

    /// The stencil write mask.
    public var stencilWriteMask: UInt32

    /// The depth bias.
    public var depthBias: Int32

    /// The depth bias slope scale.
    public var depthBiasSlopeScale: Float

    /// The depth bias clamp.
    public var depthBiasClamp: Float

    public init(
        format: GPUTextureFormat,
        depthWriteEnabled: Bool? = nil,
        depthCompare: GPUCompareFunction? = nil,
        stencilFront: GPUStencilFaceState = GPUStencilFaceState(),
        stencilBack: GPUStencilFaceState = GPUStencilFaceState(),
        stencilReadMask: UInt32 = 0xFFFFFFFF,
        stencilWriteMask: UInt32 = 0xFFFFFFFF,
        depthBias: Int32 = 0,
        depthBiasSlopeScale: Float = 0,
        depthBiasClamp: Float = 0
    ) {
        self.format = format
        self.depthWriteEnabled = depthWriteEnabled
        self.depthCompare = depthCompare
        self.stencilFront = stencilFront
        self.stencilBack = stencilBack
        self.stencilReadMask = stencilReadMask
        self.stencilWriteMask = stencilWriteMask
        self.depthBias = depthBias
        self.depthBiasSlopeScale = depthBiasSlopeScale
        self.depthBiasClamp = depthBiasClamp
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        obj.format = .string(format.rawValue)
        if let depthWriteEnabled = depthWriteEnabled {
            obj.depthWriteEnabled = .boolean(depthWriteEnabled)
        }
        if let depthCompare = depthCompare {
            obj.depthCompare = .string(depthCompare.rawValue)
        }
        obj.stencilFront = stencilFront.toJSObject().jsValue
        obj.stencilBack = stencilBack.toJSObject().jsValue
        obj.stencilReadMask = .number(Double(stencilReadMask))
        obj.stencilWriteMask = .number(Double(stencilWriteMask))
        obj.depthBias = .number(Double(depthBias))
        obj.depthBiasSlopeScale = .number(Double(depthBiasSlopeScale))
        obj.depthBiasClamp = .number(Double(depthBiasClamp))
        return obj
    }
}

// MARK: - GPUStencilFaceState

/// The stencil state for a face.
public struct GPUStencilFaceState: Sendable {
    /// The compare function.
    public var compare: GPUCompareFunction

    /// The fail operation.
    public var failOp: GPUStencilOperation

    /// The depth fail operation.
    public var depthFailOp: GPUStencilOperation

    /// The pass operation.
    public var passOp: GPUStencilOperation

    public init(
        compare: GPUCompareFunction = .always,
        failOp: GPUStencilOperation = .keep,
        depthFailOp: GPUStencilOperation = .keep,
        passOp: GPUStencilOperation = .keep
    ) {
        self.compare = compare
        self.failOp = failOp
        self.depthFailOp = depthFailOp
        self.passOp = passOp
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        obj.compare = .string(compare.rawValue)
        obj.failOp = .string(failOp.rawValue)
        obj.depthFailOp = .string(depthFailOp.rawValue)
        obj.passOp = .string(passOp.rawValue)
        return obj
    }
}

// MARK: - GPUMultisampleState

/// The multisample state for a render pipeline.
public struct GPUMultisampleState: Sendable {
    /// The sample count.
    public var count: UInt32

    /// The sample mask.
    public var mask: UInt32

    /// Whether alpha-to-coverage is enabled.
    public var alphaToCoverageEnabled: Bool

    public init(
        count: UInt32 = 1,
        mask: UInt32 = 0xFFFFFFFF,
        alphaToCoverageEnabled: Bool = false
    ) {
        self.count = count
        self.mask = mask
        self.alphaToCoverageEnabled = alphaToCoverageEnabled
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        obj.count = .number(Double(count))
        obj.mask = .number(Double(mask))
        obj.alphaToCoverageEnabled = .boolean(alphaToCoverageEnabled)
        return obj
    }
}

// MARK: - GPUFragmentState

/// The fragment state for a render pipeline.
public struct GPUFragmentState: Sendable {
    /// The shader module.
    public var module: GPUShaderModule

    /// The entry point function name.
    public var entryPoint: String?

    /// Constants to substitute in the shader.
    public var constants: [String: Double]

    /// The color targets.
    public var targets: [GPUColorTargetState?]

    public init(
        module: GPUShaderModule,
        entryPoint: String? = nil,
        constants: [String: Double] = [:],
        targets: [GPUColorTargetState?]
    ) {
        self.module = module
        self.entryPoint = entryPoint
        self.constants = constants
        self.targets = targets
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        obj.module = module.jsObject.jsValue
        if let entryPoint = entryPoint {
            obj.entryPoint = .string(entryPoint)
        }
        if !constants.isEmpty {
            let constantsObj = JSObject.global.Object.function!.new()
            for (key, value) in constants {
                constantsObj[key] = .number(value)
            }
            obj.constants = constantsObj.jsValue
        }

        let targetsArray = JSObject.global.Array.function!.new()
        for (index, target) in targets.enumerated() {
            if let target = target {
                targetsArray[index] = target.toJSObject().jsValue
            } else {
                targetsArray[index] = .null
            }
        }
        obj.targets = targetsArray.jsValue
        return obj
    }
}

// MARK: - GPUColorTargetState

/// A color target for a render pipeline.
public struct GPUColorTargetState: Sendable {
    /// The format of the color target.
    public var format: GPUTextureFormat

    /// The blend state.
    public var blend: GPUBlendState?

    /// The write mask.
    public var writeMask: GPUColorWrite

    public init(
        format: GPUTextureFormat,
        blend: GPUBlendState? = nil,
        writeMask: GPUColorWrite = .all
    ) {
        self.format = format
        self.blend = blend
        self.writeMask = writeMask
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        obj.format = .string(format.rawValue)
        if let blend = blend {
            obj.blend = blend.toJSObject().jsValue
        }
        obj.writeMask = .number(Double(writeMask.rawValue))
        return obj
    }
}

// MARK: - GPUBlendState

/// The blend state for a color target.
public struct GPUBlendState: Sendable {
    /// The color blend component.
    public var color: GPUBlendComponent

    /// The alpha blend component.
    public var alpha: GPUBlendComponent

    public init(color: GPUBlendComponent, alpha: GPUBlendComponent) {
        self.color = color
        self.alpha = alpha
    }

    /// Creates a standard alpha blending state.
    public static var alphaBlending: GPUBlendState {
        GPUBlendState(
            color: GPUBlendComponent(
                srcFactor: .srcAlpha,
                dstFactor: .oneMinusSrcAlpha,
                operation: .add
            ),
            alpha: GPUBlendComponent(
                srcFactor: .one,
                dstFactor: .oneMinusSrcAlpha,
                operation: .add
            )
        )
    }

    /// Creates a premultiplied alpha blending state.
    public static var premultipliedAlpha: GPUBlendState {
        GPUBlendState(
            color: GPUBlendComponent(
                srcFactor: .one,
                dstFactor: .oneMinusSrcAlpha,
                operation: .add
            ),
            alpha: GPUBlendComponent(
                srcFactor: .one,
                dstFactor: .oneMinusSrcAlpha,
                operation: .add
            )
        )
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        obj.color = color.toJSObject().jsValue
        obj.alpha = alpha.toJSObject().jsValue
        return obj
    }
}

// MARK: - GPUBlendComponent

/// A component of a blend operation.
public struct GPUBlendComponent: Sendable {
    /// The source blend factor.
    public var srcFactor: GPUBlendFactor

    /// The destination blend factor.
    public var dstFactor: GPUBlendFactor

    /// The blend operation.
    public var operation: GPUBlendOperation

    public init(
        srcFactor: GPUBlendFactor = .one,
        dstFactor: GPUBlendFactor = .zero,
        operation: GPUBlendOperation = .add
    ) {
        self.srcFactor = srcFactor
        self.dstFactor = dstFactor
        self.operation = operation
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        obj.srcFactor = .string(srcFactor.rawValue)
        obj.dstFactor = .string(dstFactor.rawValue)
        obj.operation = .string(operation.rawValue)
        return obj
    }
}
