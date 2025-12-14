import JavaScriptKit

// MARK: - Power Preference

/// Indicates the desired power profile for a GPU adapter.
public enum GPUPowerPreference: String, Sendable {
    case lowPower = "low-power"
    case highPerformance = "high-performance"
}

// MARK: - Texture Format

/// Defines the format of a texture.
public enum GPUTextureFormat: String, Sendable {
    // 8-bit formats
    case r8unorm = "r8unorm"
    case r8snorm = "r8snorm"
    case r8uint = "r8uint"
    case r8sint = "r8sint"

    // 16-bit formats
    case r16uint = "r16uint"
    case r16sint = "r16sint"
    case r16float = "r16float"
    case rg8unorm = "rg8unorm"
    case rg8snorm = "rg8snorm"
    case rg8uint = "rg8uint"
    case rg8sint = "rg8sint"

    // 32-bit formats
    case r32uint = "r32uint"
    case r32sint = "r32sint"
    case r32float = "r32float"
    case rg16uint = "rg16uint"
    case rg16sint = "rg16sint"
    case rg16float = "rg16float"
    case rgba8unorm = "rgba8unorm"
    case rgba8unormSrgb = "rgba8unorm-srgb"
    case rgba8snorm = "rgba8snorm"
    case rgba8uint = "rgba8uint"
    case rgba8sint = "rgba8sint"
    case bgra8unorm = "bgra8unorm"
    case bgra8unormSrgb = "bgra8unorm-srgb"

    // Packed 32-bit formats
    case rgb9e5ufloat = "rgb9e5ufloat"
    case rgb10a2uint = "rgb10a2uint"
    case rgb10a2unorm = "rgb10a2unorm"
    case rg11b10ufloat = "rg11b10ufloat"

    // 64-bit formats
    case rg32uint = "rg32uint"
    case rg32sint = "rg32sint"
    case rg32float = "rg32float"
    case rgba16uint = "rgba16uint"
    case rgba16sint = "rgba16sint"
    case rgba16float = "rgba16float"

    // 128-bit formats
    case rgba32uint = "rgba32uint"
    case rgba32sint = "rgba32sint"
    case rgba32float = "rgba32float"

    // Depth/stencil formats
    case stencil8 = "stencil8"
    case depth16unorm = "depth16unorm"
    case depth24plus = "depth24plus"
    case depth24plusStencil8 = "depth24plus-stencil8"
    case depth32float = "depth32float"
    case depth32floatStencil8 = "depth32float-stencil8"
}

// MARK: - Texture Dimension

/// The dimension of a texture.
public enum GPUTextureDimension: String, Sendable {
    case _1d = "1d"
    case _2d = "2d"
    case _3d = "3d"
}

// MARK: - Texture View Dimension

/// The dimension of a texture view.
public enum GPUTextureViewDimension: String, Sendable {
    case _1d = "1d"
    case _2d = "2d"
    case _2dArray = "2d-array"
    case cube = "cube"
    case cubeArray = "cube-array"
    case _3d = "3d"
}

// MARK: - Texture Aspect

/// Aspects of a texture.
public enum GPUTextureAspect: String, Sendable {
    case all = "all"
    case stencilOnly = "stencil-only"
    case depthOnly = "depth-only"
}

// MARK: - Address Mode

/// Determines how texture coordinates outside [0, 1] are handled.
public enum GPUAddressMode: String, Sendable {
    case clampToEdge = "clamp-to-edge"
    case `repeat` = "repeat"
    case mirrorRepeat = "mirror-repeat"
}

// MARK: - Filter Mode

/// The filtering method for texture sampling.
public enum GPUFilterMode: String, Sendable {
    case nearest = "nearest"
    case linear = "linear"
}

// MARK: - Mipmap Filter Mode

/// The filtering method for mipmap selection.
public enum GPUMipmapFilterMode: String, Sendable {
    case nearest = "nearest"
    case linear = "linear"
}

// MARK: - Compare Function

/// The comparison function for depth/stencil tests.
public enum GPUCompareFunction: String, Sendable {
    case never = "never"
    case less = "less"
    case equal = "equal"
    case lessEqual = "less-equal"
    case greater = "greater"
    case notEqual = "not-equal"
    case greaterEqual = "greater-equal"
    case always = "always"
}

// MARK: - Buffer Binding Type

/// The type of a buffer binding.
public enum GPUBufferBindingType: String, Sendable {
    case uniform = "uniform"
    case storage = "storage"
    case readOnlyStorage = "read-only-storage"
}

// MARK: - Sampler Binding Type

/// The type of a sampler binding.
public enum GPUSamplerBindingType: String, Sendable {
    case filtering = "filtering"
    case nonFiltering = "non-filtering"
    case comparison = "comparison"
}

// MARK: - Texture Sample Type

/// The sample type of a texture binding.
public enum GPUTextureSampleType: String, Sendable {
    case float = "float"
    case unfilterableFloat = "unfilterable-float"
    case depth = "depth"
    case sint = "sint"
    case uint = "uint"
}

// MARK: - Storage Texture Access

/// The access mode for a storage texture binding.
public enum GPUStorageTextureAccess: String, Sendable {
    case writeOnly = "write-only"
    case readOnly = "read-only"
    case readWrite = "read-write"
}

// MARK: - Vertex Format

/// The format of a vertex attribute.
public enum GPUVertexFormat: String, Sendable {
    case uint8 = "uint8"
    case uint8x2 = "uint8x2"
    case uint8x4 = "uint8x4"
    case sint8 = "sint8"
    case sint8x2 = "sint8x2"
    case sint8x4 = "sint8x4"
    case unorm8 = "unorm8"
    case unorm8x2 = "unorm8x2"
    case unorm8x4 = "unorm8x4"
    case snorm8 = "snorm8"
    case snorm8x2 = "snorm8x2"
    case snorm8x4 = "snorm8x4"
    case uint16 = "uint16"
    case uint16x2 = "uint16x2"
    case uint16x4 = "uint16x4"
    case sint16 = "sint16"
    case sint16x2 = "sint16x2"
    case sint16x4 = "sint16x4"
    case unorm16 = "unorm16"
    case unorm16x2 = "unorm16x2"
    case unorm16x4 = "unorm16x4"
    case snorm16 = "snorm16"
    case snorm16x2 = "snorm16x2"
    case snorm16x4 = "snorm16x4"
    case float16 = "float16"
    case float16x2 = "float16x2"
    case float16x4 = "float16x4"
    case float32 = "float32"
    case float32x2 = "float32x2"
    case float32x3 = "float32x3"
    case float32x4 = "float32x4"
    case uint32 = "uint32"
    case uint32x2 = "uint32x2"
    case uint32x3 = "uint32x3"
    case uint32x4 = "uint32x4"
    case sint32 = "sint32"
    case sint32x2 = "sint32x2"
    case sint32x3 = "sint32x3"
    case sint32x4 = "sint32x4"
    case unorm1010102 = "unorm10-10-10-2"
    case unorm8x4Bgra = "unorm8x4-bgra"
}

// MARK: - Vertex Step Mode

/// The step mode for vertex buffers.
public enum GPUVertexStepMode: String, Sendable {
    case vertex = "vertex"
    case instance = "instance"
}

// MARK: - Primitive Topology

/// The primitive topology for rendering.
public enum GPUPrimitiveTopology: String, Sendable {
    case pointList = "point-list"
    case lineList = "line-list"
    case lineStrip = "line-strip"
    case triangleList = "triangle-list"
    case triangleStrip = "triangle-strip"
}

// MARK: - Front Face

/// The front face winding order.
public enum GPUFrontFace: String, Sendable {
    case ccw = "ccw"
    case cw = "cw"
}

// MARK: - Cull Mode

/// The face culling mode.
public enum GPUCullMode: String, Sendable {
    case none = "none"
    case front = "front"
    case back = "back"
}

// MARK: - Blend Factor

/// A factor in a blend operation.
public enum GPUBlendFactor: String, Sendable {
    case zero = "zero"
    case one = "one"
    case src = "src"
    case oneMinusSrc = "one-minus-src"
    case srcAlpha = "src-alpha"
    case oneMinusSrcAlpha = "one-minus-src-alpha"
    case dst = "dst"
    case oneMinusDst = "one-minus-dst"
    case dstAlpha = "dst-alpha"
    case oneMinusDstAlpha = "one-minus-dst-alpha"
    case srcAlphaSaturated = "src-alpha-saturated"
    case constant = "constant"
    case oneMinusConstant = "one-minus-constant"
    case src1 = "src1"
    case oneMinusSrc1 = "one-minus-src1"
    case src1Alpha = "src1-alpha"
    case oneMinusSrc1Alpha = "one-minus-src1-alpha"
}

// MARK: - Blend Operation

/// A blending operation.
public enum GPUBlendOperation: String, Sendable {
    case add = "add"
    case subtract = "subtract"
    case reverseSubtract = "reverse-subtract"
    case min = "min"
    case max = "max"
}

// MARK: - Stencil Operation

/// An operation on a stencil value.
public enum GPUStencilOperation: String, Sendable {
    case keep = "keep"
    case zero = "zero"
    case replace = "replace"
    case invert = "invert"
    case incrementClamp = "increment-clamp"
    case decrementClamp = "decrement-clamp"
    case incrementWrap = "increment-wrap"
    case decrementWrap = "decrement-wrap"
}

// MARK: - Index Format

/// The format of index data.
public enum GPUIndexFormat: String, Sendable {
    case uint16 = "uint16"
    case uint32 = "uint32"
}

// MARK: - Load Op

/// The operation to perform on a color attachment at the start of a render pass.
public enum GPULoadOp: String, Sendable {
    case load = "load"
    case clear = "clear"
}

// MARK: - Store Op

/// The operation to perform on a color attachment at the end of a render pass.
public enum GPUStoreOp: String, Sendable {
    case store = "store"
    case discard = "discard"
}

// MARK: - Query Type

/// The type of a query.
public enum GPUQueryType: String, Sendable {
    case occlusion = "occlusion"
    case timestamp = "timestamp"
}

// MARK: - Canvas Alpha Mode

/// The alpha mode for canvas composition.
public enum GPUCanvasAlphaMode: String, Sendable {
    case opaque = "opaque"
    case premultiplied = "premultiplied"
}

// MARK: - Canvas Tone Mapping Mode

/// The tone mapping mode for canvas.
public enum GPUCanvasToneMappingMode: String, Sendable {
    case standard = "standard"
    case extended = "extended"
}

// MARK: - Error Filter

/// Filter for GPU error types.
public enum GPUErrorFilter: String, Sendable {
    case validation = "validation"
    case outOfMemory = "out-of-memory"
    case `internal` = "internal"
}

// MARK: - Device Lost Reason

/// Reason for device loss.
public enum GPUDeviceLostReason: String, Sendable {
    case unknown = "unknown"
    case destroyed = "destroyed"
}

// MARK: - Feature Name

/// GPU features that can be requested.
public enum GPUFeatureName: String, Sendable {
    case depthClipControl = "depth-clip-control"
    case depth32floatStencil8 = "depth32float-stencil8"
    case textureCompressionBc = "texture-compression-bc"
    case textureCompressionBcSliced3d = "texture-compression-bc-sliced-3d"
    case textureCompressionEtc2 = "texture-compression-etc2"
    case textureCompressionAstc = "texture-compression-astc"
    case textureCompressionAstcSliced3d = "texture-compression-astc-sliced-3d"
    case timestampQuery = "timestamp-query"
    case indirectFirstInstance = "indirect-first-instance"
    case shaderF16 = "shader-f16"
    case rg11b10ufloatRenderable = "rg11b10ufloat-renderable"
    case bgra8unormStorage = "bgra8unorm-storage"
    case float32Filterable = "float32-filterable"
    case float32Blendable = "float32-blendable"
    case clipDistances = "clip-distances"
    case dualSourceBlending = "dual-source-blending"
    case subgroups = "subgroups"
}
