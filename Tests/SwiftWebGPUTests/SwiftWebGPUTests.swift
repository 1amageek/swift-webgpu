import Testing
@testable import SwiftWebGPU

// MARK: - Enum Raw Value Tests

/// Tests that enum raw values match WebGPU specification.
/// These values are passed to JavaScript and must match exactly.
@Suite("Enum Raw Values")
struct EnumRawValueTests {

    @Test("GPUPowerPreference raw values")
    func powerPreferenceRawValues() {
        #expect(GPUPowerPreference.lowPower.rawValue == "low-power")
        #expect(GPUPowerPreference.highPerformance.rawValue == "high-performance")
    }

    @Test("GPUTextureFormat common formats")
    func textureFormatRawValues() {
        // 8-bit formats
        #expect(GPUTextureFormat.r8unorm.rawValue == "r8unorm")
        #expect(GPUTextureFormat.r8uint.rawValue == "r8uint")

        // Common 32-bit formats
        #expect(GPUTextureFormat.rgba8unorm.rawValue == "rgba8unorm")
        #expect(GPUTextureFormat.rgba8unormSrgb.rawValue == "rgba8unorm-srgb")
        #expect(GPUTextureFormat.bgra8unorm.rawValue == "bgra8unorm")
        #expect(GPUTextureFormat.bgra8unormSrgb.rawValue == "bgra8unorm-srgb")

        // Depth/stencil formats
        #expect(GPUTextureFormat.depth16unorm.rawValue == "depth16unorm")
        #expect(GPUTextureFormat.depth24plus.rawValue == "depth24plus")
        #expect(GPUTextureFormat.depth24plusStencil8.rawValue == "depth24plus-stencil8")
        #expect(GPUTextureFormat.depth32float.rawValue == "depth32float")
        #expect(GPUTextureFormat.depth32floatStencil8.rawValue == "depth32float-stencil8")
    }

    @Test("GPUTextureDimension raw values")
    func textureDimensionRawValues() {
        #expect(GPUTextureDimension._1d.rawValue == "1d")
        #expect(GPUTextureDimension._2d.rawValue == "2d")
        #expect(GPUTextureDimension._3d.rawValue == "3d")
    }

    @Test("GPUTextureViewDimension raw values")
    func textureViewDimensionRawValues() {
        #expect(GPUTextureViewDimension._1d.rawValue == "1d")
        #expect(GPUTextureViewDimension._2d.rawValue == "2d")
        #expect(GPUTextureViewDimension._2dArray.rawValue == "2d-array")
        #expect(GPUTextureViewDimension.cube.rawValue == "cube")
        #expect(GPUTextureViewDimension.cubeArray.rawValue == "cube-array")
        #expect(GPUTextureViewDimension._3d.rawValue == "3d")
    }

    @Test("GPUTextureAspect raw values")
    func textureAspectRawValues() {
        #expect(GPUTextureAspect.all.rawValue == "all")
        #expect(GPUTextureAspect.stencilOnly.rawValue == "stencil-only")
        #expect(GPUTextureAspect.depthOnly.rawValue == "depth-only")
    }

    @Test("GPUAddressMode raw values")
    func addressModeRawValues() {
        #expect(GPUAddressMode.clampToEdge.rawValue == "clamp-to-edge")
        #expect(GPUAddressMode.repeat.rawValue == "repeat")
        #expect(GPUAddressMode.mirrorRepeat.rawValue == "mirror-repeat")
    }

    @Test("GPUFilterMode raw values")
    func filterModeRawValues() {
        #expect(GPUFilterMode.nearest.rawValue == "nearest")
        #expect(GPUFilterMode.linear.rawValue == "linear")
    }

    @Test("GPUCompareFunction raw values")
    func compareFunctionRawValues() {
        #expect(GPUCompareFunction.never.rawValue == "never")
        #expect(GPUCompareFunction.less.rawValue == "less")
        #expect(GPUCompareFunction.equal.rawValue == "equal")
        #expect(GPUCompareFunction.lessEqual.rawValue == "less-equal")
        #expect(GPUCompareFunction.greater.rawValue == "greater")
        #expect(GPUCompareFunction.notEqual.rawValue == "not-equal")
        #expect(GPUCompareFunction.greaterEqual.rawValue == "greater-equal")
        #expect(GPUCompareFunction.always.rawValue == "always")
    }

    @Test("GPUBufferBindingType raw values")
    func bufferBindingTypeRawValues() {
        #expect(GPUBufferBindingType.uniform.rawValue == "uniform")
        #expect(GPUBufferBindingType.storage.rawValue == "storage")
        #expect(GPUBufferBindingType.readOnlyStorage.rawValue == "read-only-storage")
    }

    @Test("GPUPrimitiveTopology raw values")
    func primitiveTopologyRawValues() {
        #expect(GPUPrimitiveTopology.pointList.rawValue == "point-list")
        #expect(GPUPrimitiveTopology.lineList.rawValue == "line-list")
        #expect(GPUPrimitiveTopology.lineStrip.rawValue == "line-strip")
        #expect(GPUPrimitiveTopology.triangleList.rawValue == "triangle-list")
        #expect(GPUPrimitiveTopology.triangleStrip.rawValue == "triangle-strip")
    }

    @Test("GPUCullMode raw values")
    func cullModeRawValues() {
        #expect(GPUCullMode.none.rawValue == "none")
        #expect(GPUCullMode.front.rawValue == "front")
        #expect(GPUCullMode.back.rawValue == "back")
    }

    @Test("GPUFrontFace raw values")
    func frontFaceRawValues() {
        #expect(GPUFrontFace.ccw.rawValue == "ccw")
        #expect(GPUFrontFace.cw.rawValue == "cw")
    }

    @Test("GPUBlendFactor raw values")
    func blendFactorRawValues() {
        #expect(GPUBlendFactor.zero.rawValue == "zero")
        #expect(GPUBlendFactor.one.rawValue == "one")
        #expect(GPUBlendFactor.src.rawValue == "src")
        #expect(GPUBlendFactor.oneMinusSrc.rawValue == "one-minus-src")
        #expect(GPUBlendFactor.srcAlpha.rawValue == "src-alpha")
        #expect(GPUBlendFactor.oneMinusSrcAlpha.rawValue == "one-minus-src-alpha")
        #expect(GPUBlendFactor.dst.rawValue == "dst")
        #expect(GPUBlendFactor.oneMinusDst.rawValue == "one-minus-dst")
        #expect(GPUBlendFactor.dstAlpha.rawValue == "dst-alpha")
        #expect(GPUBlendFactor.oneMinusDstAlpha.rawValue == "one-minus-dst-alpha")
    }

    @Test("GPUBlendOperation raw values")
    func blendOperationRawValues() {
        #expect(GPUBlendOperation.add.rawValue == "add")
        #expect(GPUBlendOperation.subtract.rawValue == "subtract")
        #expect(GPUBlendOperation.reverseSubtract.rawValue == "reverse-subtract")
        #expect(GPUBlendOperation.min.rawValue == "min")
        #expect(GPUBlendOperation.max.rawValue == "max")
    }

    @Test("GPUStencilOperation raw values")
    func stencilOperationRawValues() {
        #expect(GPUStencilOperation.keep.rawValue == "keep")
        #expect(GPUStencilOperation.zero.rawValue == "zero")
        #expect(GPUStencilOperation.replace.rawValue == "replace")
        #expect(GPUStencilOperation.invert.rawValue == "invert")
        #expect(GPUStencilOperation.incrementClamp.rawValue == "increment-clamp")
        #expect(GPUStencilOperation.decrementClamp.rawValue == "decrement-clamp")
        #expect(GPUStencilOperation.incrementWrap.rawValue == "increment-wrap")
        #expect(GPUStencilOperation.decrementWrap.rawValue == "decrement-wrap")
    }

    @Test("GPUIndexFormat raw values")
    func indexFormatRawValues() {
        #expect(GPUIndexFormat.uint16.rawValue == "uint16")
        #expect(GPUIndexFormat.uint32.rawValue == "uint32")
    }

    @Test("GPULoadOp and GPUStoreOp raw values")
    func loadStoreOpRawValues() {
        #expect(GPULoadOp.load.rawValue == "load")
        #expect(GPULoadOp.clear.rawValue == "clear")
        #expect(GPUStoreOp.store.rawValue == "store")
        #expect(GPUStoreOp.discard.rawValue == "discard")
    }

    @Test("GPUQueryType raw values")
    func queryTypeRawValues() {
        #expect(GPUQueryType.occlusion.rawValue == "occlusion")
        #expect(GPUQueryType.timestamp.rawValue == "timestamp")
    }

    @Test("GPUCanvasAlphaMode raw values")
    func canvasAlphaModeRawValues() {
        #expect(GPUCanvasAlphaMode.opaque.rawValue == "opaque")
        #expect(GPUCanvasAlphaMode.premultiplied.rawValue == "premultiplied")
    }

    @Test("GPUErrorFilter raw values")
    func errorFilterRawValues() {
        #expect(GPUErrorFilter.validation.rawValue == "validation")
        #expect(GPUErrorFilter.outOfMemory.rawValue == "out-of-memory")
        #expect(GPUErrorFilter.internal.rawValue == "internal")
    }

    @Test("GPUDeviceLostReason raw values")
    func deviceLostReasonRawValues() {
        #expect(GPUDeviceLostReason.unknown.rawValue == "unknown")
        #expect(GPUDeviceLostReason.destroyed.rawValue == "destroyed")
    }

    @Test("GPUFeatureName raw values")
    func featureNameRawValues() {
        #expect(GPUFeatureName.depthClipControl.rawValue == "depth-clip-control")
        #expect(GPUFeatureName.depth32floatStencil8.rawValue == "depth32float-stencil8")
        #expect(GPUFeatureName.textureCompressionBc.rawValue == "texture-compression-bc")
        #expect(GPUFeatureName.textureCompressionEtc2.rawValue == "texture-compression-etc2")
        #expect(GPUFeatureName.textureCompressionAstc.rawValue == "texture-compression-astc")
        #expect(GPUFeatureName.timestampQuery.rawValue == "timestamp-query")
        #expect(GPUFeatureName.shaderF16.rawValue == "shader-f16")
        #expect(GPUFeatureName.subgroups.rawValue == "subgroups")
    }

    @Test("GPUVertexFormat common formats")
    func vertexFormatRawValues() {
        #expect(GPUVertexFormat.float32.rawValue == "float32")
        #expect(GPUVertexFormat.float32x2.rawValue == "float32x2")
        #expect(GPUVertexFormat.float32x3.rawValue == "float32x3")
        #expect(GPUVertexFormat.float32x4.rawValue == "float32x4")
        #expect(GPUVertexFormat.uint32.rawValue == "uint32")
        #expect(GPUVertexFormat.sint32.rawValue == "sint32")
        #expect(GPUVertexFormat.unorm8x4.rawValue == "unorm8x4")
    }
}

// MARK: - Flag/OptionSet Tests

/// Tests that OptionSet flags have correct bit values and combine correctly.
@Suite("Flag/OptionSet Operations")
struct FlagTests {

    @Test("GPUBufferUsage flag values")
    func bufferUsageValues() {
        #expect(GPUBufferUsage.mapRead.rawValue == 0x0001)
        #expect(GPUBufferUsage.mapWrite.rawValue == 0x0002)
        #expect(GPUBufferUsage.copySrc.rawValue == 0x0004)
        #expect(GPUBufferUsage.copyDst.rawValue == 0x0008)
        #expect(GPUBufferUsage.index.rawValue == 0x0010)
        #expect(GPUBufferUsage.vertex.rawValue == 0x0020)
        #expect(GPUBufferUsage.uniform.rawValue == 0x0040)
        #expect(GPUBufferUsage.storage.rawValue == 0x0080)
        #expect(GPUBufferUsage.indirect.rawValue == 0x0100)
        #expect(GPUBufferUsage.queryResolve.rawValue == 0x0200)
    }

    @Test("GPUBufferUsage combining flags")
    func bufferUsageCombination() {
        let usage: GPUBufferUsage = [.vertex, .copyDst]
        #expect(usage.rawValue == 0x0028)
        #expect(usage.contains(.vertex))
        #expect(usage.contains(.copyDst))
        #expect(!usage.contains(.uniform))
    }

    @Test("GPUTextureUsage flag values")
    func textureUsageValues() {
        #expect(GPUTextureUsage.copySrc.rawValue == 0x01)
        #expect(GPUTextureUsage.copyDst.rawValue == 0x02)
        #expect(GPUTextureUsage.textureBinding.rawValue == 0x04)
        #expect(GPUTextureUsage.storageBinding.rawValue == 0x08)
        #expect(GPUTextureUsage.renderAttachment.rawValue == 0x10)
    }

    @Test("GPUTextureUsage combining flags")
    func textureUsageCombination() {
        let usage: GPUTextureUsage = [.textureBinding, .copyDst]
        #expect(usage.rawValue == 0x06)
        #expect(usage.contains(.textureBinding))
        #expect(usage.contains(.copyDst))
        #expect(!usage.contains(.renderAttachment))
    }

    @Test("GPUShaderStage flag values")
    func shaderStageValues() {
        #expect(GPUShaderStage.vertex.rawValue == 0x1)
        #expect(GPUShaderStage.fragment.rawValue == 0x2)
        #expect(GPUShaderStage.compute.rawValue == 0x4)
    }

    @Test("GPUShaderStage combining flags")
    func shaderStageCombination() {
        let stages: GPUShaderStage = [.vertex, .fragment]
        #expect(stages.rawValue == 0x3)
        #expect(stages.contains(.vertex))
        #expect(stages.contains(.fragment))
        #expect(!stages.contains(.compute))
    }

    @Test("GPUColorWrite flag values")
    func colorWriteValues() {
        #expect(GPUColorWrite.red.rawValue == 0x1)
        #expect(GPUColorWrite.green.rawValue == 0x2)
        #expect(GPUColorWrite.blue.rawValue == 0x4)
        #expect(GPUColorWrite.alpha.rawValue == 0x8)
        #expect(GPUColorWrite.all.rawValue == 0xF)
    }

    @Test("GPUColorWrite.all contains all channels")
    func colorWriteAllContainsAll() {
        let all = GPUColorWrite.all
        #expect(all.contains(.red))
        #expect(all.contains(.green))
        #expect(all.contains(.blue))
        #expect(all.contains(.alpha))
    }

    @Test("GPUMapMode flag values")
    func mapModeValues() {
        #expect(GPUMapMode.read.rawValue == 0x0001)
        #expect(GPUMapMode.write.rawValue == 0x0002)
    }
}

// MARK: - Value Type Tests

/// Tests for value types like GPUColor, GPUExtent3D, GPUOrigin3D.
@Suite("Value Types")
struct ValueTypeTests {

    @Test("GPUColor initialization")
    func colorInitialization() {
        let color = GPUColor(r: 0.5, g: 0.25, b: 0.75, a: 1.0)
        #expect(color.r == 0.5)
        #expect(color.g == 0.25)
        #expect(color.b == 0.75)
        #expect(color.a == 1.0)
    }

    @Test("GPUColor static values")
    func colorStaticValues() {
        #expect(GPUColor.black.r == 0)
        #expect(GPUColor.black.g == 0)
        #expect(GPUColor.black.b == 0)
        #expect(GPUColor.black.a == 1)

        #expect(GPUColor.white.r == 1)
        #expect(GPUColor.white.g == 1)
        #expect(GPUColor.white.b == 1)
        #expect(GPUColor.white.a == 1)

        #expect(GPUColor.clear.r == 0)
        #expect(GPUColor.clear.g == 0)
        #expect(GPUColor.clear.b == 0)
        #expect(GPUColor.clear.a == 0)
    }

    @Test("GPUExtent3D initialization with defaults")
    func extent3DDefaults() {
        let extent = GPUExtent3D(width: 256)
        #expect(extent.width == 256)
        #expect(extent.height == 1)
        #expect(extent.depthOrArrayLayers == 1)
    }

    @Test("GPUExtent3D full initialization")
    func extent3DFull() {
        let extent = GPUExtent3D(width: 512, height: 256, depthOrArrayLayers: 6)
        #expect(extent.width == 512)
        #expect(extent.height == 256)
        #expect(extent.depthOrArrayLayers == 6)
    }

    @Test("GPUOrigin3D initialization with defaults")
    func origin3DDefaults() {
        let origin = GPUOrigin3D()
        #expect(origin.x == 0)
        #expect(origin.y == 0)
        #expect(origin.z == 0)
    }

    @Test("GPUOrigin3D full initialization")
    func origin3DFull() {
        let origin = GPUOrigin3D(x: 10, y: 20, z: 5)
        #expect(origin.x == 10)
        #expect(origin.y == 20)
        #expect(origin.z == 5)
    }

    @Test("GPUOrigin2D initialization with defaults")
    func origin2DDefaults() {
        let origin = GPUOrigin2D()
        #expect(origin.x == 0)
        #expect(origin.y == 0)
    }

    @Test("GPUOrigin2D full initialization")
    func origin2DFull() {
        let origin = GPUOrigin2D(x: 100, y: 200)
        #expect(origin.x == 100)
        #expect(origin.y == 200)
    }
}

// MARK: - Descriptor Tests

/// Tests for descriptor initialization with default values.
@Suite("Descriptor Initialization")
struct DescriptorTests {

    @Test("GPUBufferDescriptor initialization")
    func bufferDescriptor() {
        let descriptor = GPUBufferDescriptor(
            size: 1024,
            usage: [.vertex, .copyDst]
        )
        #expect(descriptor.size == 1024)
        #expect(descriptor.usage.contains(.vertex))
        #expect(descriptor.usage.contains(.copyDst))
        #expect(descriptor.mappedAtCreation == false)
        #expect(descriptor.label == nil)
    }

    @Test("GPUBufferDescriptor with mappedAtCreation")
    func bufferDescriptorMapped() {
        let descriptor = GPUBufferDescriptor(
            size: 256,
            usage: .uniform,
            mappedAtCreation: true,
            label: "Test Buffer"
        )
        #expect(descriptor.size == 256)
        #expect(descriptor.mappedAtCreation == true)
        #expect(descriptor.label == "Test Buffer")
    }

    @Test("GPUTextureDescriptor initialization")
    func textureDescriptor() {
        let descriptor = GPUTextureDescriptor(
            size: GPUExtent3D(width: 256, height: 256),
            format: .rgba8unorm,
            usage: [.textureBinding, .copyDst]
        )
        #expect(descriptor.size.width == 256)
        #expect(descriptor.size.height == 256)
        #expect(descriptor.format == .rgba8unorm)
        #expect(descriptor.usage.contains(.textureBinding))
        #expect(descriptor.mipLevelCount == 1)
        #expect(descriptor.sampleCount == 1)
        #expect(descriptor.dimension == ._2d)
    }

    @Test("GPUSamplerDescriptor default values")
    func samplerDescriptorDefaults() {
        let descriptor = GPUSamplerDescriptor()
        #expect(descriptor.addressModeU == .clampToEdge)
        #expect(descriptor.addressModeV == .clampToEdge)
        #expect(descriptor.addressModeW == .clampToEdge)
        #expect(descriptor.magFilter == .nearest)
        #expect(descriptor.minFilter == .nearest)
        #expect(descriptor.mipmapFilter == .nearest)
        #expect(descriptor.lodMinClamp == 0)
        #expect(descriptor.lodMaxClamp == 32)
        #expect(descriptor.compare == nil)
        #expect(descriptor.maxAnisotropy == 1)
    }

    @Test("GPUSamplerDescriptor linear filtering")
    func samplerDescriptorLinear() {
        let descriptor = GPUSamplerDescriptor(
            magFilter: .linear,
            minFilter: .linear,
            mipmapFilter: .linear
        )
        #expect(descriptor.magFilter == .linear)
        #expect(descriptor.minFilter == .linear)
        #expect(descriptor.mipmapFilter == .linear)
    }

    @Test("GPUPrimitiveState default values")
    func primitiveStateDefaults() {
        let state = GPUPrimitiveState()
        #expect(state.topology == .triangleList)
        #expect(state.stripIndexFormat == nil)
        #expect(state.frontFace == .ccw)
        #expect(state.cullMode == .none)
        #expect(state.unclippedDepth == false)
    }

    @Test("GPUMultisampleState default values")
    func multisampleStateDefaults() {
        let state = GPUMultisampleState()
        #expect(state.count == 1)
        #expect(state.mask == 0xFFFFFFFF)
        #expect(state.alphaToCoverageEnabled == false)
    }

    @Test("GPUDepthStencilState initialization")
    func depthStencilState() {
        let state = GPUDepthStencilState(
            format: .depth24plus,
            depthWriteEnabled: true,
            depthCompare: .less
        )
        #expect(state.format == .depth24plus)
        #expect(state.depthWriteEnabled == true)
        #expect(state.depthCompare == .less)
        #expect(state.stencilReadMask == 0xFFFFFFFF)
        #expect(state.stencilWriteMask == 0xFFFFFFFF)
    }

    @Test("GPUStencilFaceState default values")
    func stencilFaceStateDefaults() {
        let state = GPUStencilFaceState()
        #expect(state.compare == .always)
        #expect(state.failOp == .keep)
        #expect(state.depthFailOp == .keep)
        #expect(state.passOp == .keep)
    }

    @Test("GPUBlendComponent default values")
    func blendComponentDefaults() {
        let component = GPUBlendComponent()
        #expect(component.srcFactor == .one)
        #expect(component.dstFactor == .zero)
        #expect(component.operation == .add)
    }

    @Test("GPUColorTargetState default values")
    func colorTargetStateDefaults() {
        let state = GPUColorTargetState(format: .bgra8unorm)
        #expect(state.format == .bgra8unorm)
        #expect(state.blend == nil)
        #expect(state.writeMask == .all)
    }

    @Test("GPUVertexAttribute initialization")
    func vertexAttribute() {
        let attr = GPUVertexAttribute(
            format: .float32x3,
            offset: 0,
            shaderLocation: 0
        )
        #expect(attr.format == .float32x3)
        #expect(attr.offset == 0)
        #expect(attr.shaderLocation == 0)
    }

    @Test("GPUVertexBufferLayout initialization")
    func vertexBufferLayout() {
        let layout = GPUVertexBufferLayout(
            arrayStride: 12,
            attributes: [
                GPUVertexAttribute(format: .float32x3, offset: 0, shaderLocation: 0)
            ]
        )
        #expect(layout.arrayStride == 12)
        #expect(layout.stepMode == .vertex)
        #expect(layout.attributes.count == 1)
    }

    @Test("GPUBindGroupLayoutEntry initialization")
    func bindGroupLayoutEntry() {
        let entry = GPUBindGroupLayoutEntry(
            binding: 0,
            visibility: [.vertex, .fragment],
            buffer: GPUBufferBindingLayout(type: .uniform)
        )
        #expect(entry.binding == 0)
        #expect(entry.visibility.contains(.vertex))
        #expect(entry.visibility.contains(.fragment))
        #expect(entry.buffer?.type == .uniform)
    }

    @Test("GPUBufferBindingLayout default values")
    func bufferBindingLayoutDefaults() {
        let layout = GPUBufferBindingLayout()
        #expect(layout.type == .uniform)
        #expect(layout.hasDynamicOffset == false)
        #expect(layout.minBindingSize == 0)
    }

    @Test("GPUTextureBindingLayout default values")
    func textureBindingLayoutDefaults() {
        let layout = GPUTextureBindingLayout()
        #expect(layout.sampleType == .float)
        #expect(layout.viewDimension == ._2d)
        #expect(layout.multisampled == false)
    }

    @Test("GPUSamplerBindingLayout default values")
    func samplerBindingLayoutDefaults() {
        let layout = GPUSamplerBindingLayout()
        #expect(layout.type == .filtering)
    }

    @Test("GPUImageDataLayout default values")
    func imageDataLayoutDefaults() {
        let layout = GPUImageDataLayout()
        #expect(layout.offset == 0)
        #expect(layout.bytesPerRow == nil)
        #expect(layout.rowsPerImage == nil)
    }
}

// MARK: - Blend State Tests

/// Tests for blend state configurations.
@Suite("Blend State")
struct BlendStateTests {

    @Test("GPUBlendState.alphaBlending configuration")
    func alphaBlending() {
        let blend = GPUBlendState.alphaBlending

        // Color component
        #expect(blend.color.srcFactor == .srcAlpha)
        #expect(blend.color.dstFactor == .oneMinusSrcAlpha)
        #expect(blend.color.operation == .add)

        // Alpha component
        #expect(blend.alpha.srcFactor == .one)
        #expect(blend.alpha.dstFactor == .oneMinusSrcAlpha)
        #expect(blend.alpha.operation == .add)
    }

    @Test("GPUBlendState.premultipliedAlpha configuration")
    func premultipliedAlpha() {
        let blend = GPUBlendState.premultipliedAlpha

        // Color component
        #expect(blend.color.srcFactor == .one)
        #expect(blend.color.dstFactor == .oneMinusSrcAlpha)
        #expect(blend.color.operation == .add)

        // Alpha component
        #expect(blend.alpha.srcFactor == .one)
        #expect(blend.alpha.dstFactor == .oneMinusSrcAlpha)
        #expect(blend.alpha.operation == .add)
    }

    @Test("Custom blend state")
    func customBlendState() {
        let blend = GPUBlendState(
            color: GPUBlendComponent(
                srcFactor: .src,
                dstFactor: .dst,
                operation: .add
            ),
            alpha: GPUBlendComponent(
                srcFactor: .one,
                dstFactor: .zero,
                operation: .add
            )
        )

        #expect(blend.color.srcFactor == .src)
        #expect(blend.color.dstFactor == .dst)
        #expect(blend.alpha.srcFactor == .one)
        #expect(blend.alpha.dstFactor == .zero)
    }
}

// MARK: - Canvas Configuration Tests

/// Tests for canvas configuration types.
@Suite("Canvas Configuration")
struct CanvasConfigurationTests {

    @Test("GPUPredefinedColorSpace raw values")
    func predefinedColorSpaceRawValues() {
        #expect(GPUPredefinedColorSpace.srgb.rawValue == "srgb")
        #expect(GPUPredefinedColorSpace.displayP3.rawValue == "display-p3")
    }

    @Test("GPUCanvasToneMapping default mode")
    func canvasToneMappingDefault() {
        let toneMapping = GPUCanvasToneMapping()
        #expect(toneMapping.mode == .standard)
    }

    @Test("GPUCanvasToneMappingMode raw values")
    func canvasToneMappingModeRawValues() {
        #expect(GPUCanvasToneMappingMode.standard.rawValue == "standard")
        #expect(GPUCanvasToneMappingMode.extended.rawValue == "extended")
    }
}

// MARK: - Query Set Tests

/// Tests for query set configurations.
@Suite("Query Set")
struct QuerySetTests {

    @Test("GPUQuerySetDescriptor initialization")
    func querySetDescriptor() {
        let descriptor = GPUQuerySetDescriptor(
            type: .occlusion,
            count: 16
        )
        #expect(descriptor.type == .occlusion)
        #expect(descriptor.count == 16)
        #expect(descriptor.label == nil)
    }

    @Test("GPUQuerySetDescriptor with label")
    func querySetDescriptorWithLabel() {
        let descriptor = GPUQuerySetDescriptor(
            type: .timestamp,
            count: 2,
            label: "Timestamp Query"
        )
        #expect(descriptor.type == .timestamp)
        #expect(descriptor.count == 2)
        #expect(descriptor.label == "Timestamp Query")
    }
}

// MARK: - Shader Module Tests

/// Tests for shader module configurations.
@Suite("Shader Module")
struct ShaderModuleTests {

    @Test("GPUCompilationMessageType raw values")
    func compilationMessageTypeRawValues() {
        #expect(GPUCompilationMessageType.error.rawValue == "error")
        #expect(GPUCompilationMessageType.warning.rawValue == "warning")
        #expect(GPUCompilationMessageType.info.rawValue == "info")
    }
}

// MARK: - Pipeline Error Tests

/// Tests for pipeline error types.
@Suite("Pipeline Error")
struct PipelineErrorTests {

    @Test("GPUPipelineErrorReason raw values")
    func pipelineErrorReasonRawValues() {
        #expect(GPUPipelineErrorReason.validation.rawValue == "validation")
        #expect(GPUPipelineErrorReason.internal.rawValue == "internal")
    }
}

// MARK: - Storage Texture Tests

/// Tests for storage texture configurations.
@Suite("Storage Texture")
struct StorageTextureTests {

    @Test("GPUStorageTextureBindingLayout default values")
    func storageTextureBindingLayoutDefaults() {
        let layout = GPUStorageTextureBindingLayout(
            format: .rgba8unorm
        )
        #expect(layout.access == .writeOnly)
        #expect(layout.format == .rgba8unorm)
        #expect(layout.viewDimension == ._2d)
    }

    @Test("GPUStorageTextureAccess raw values")
    func storageTextureAccessRawValues() {
        #expect(GPUStorageTextureAccess.writeOnly.rawValue == "write-only")
        #expect(GPUStorageTextureAccess.readOnly.rawValue == "read-only")
        #expect(GPUStorageTextureAccess.readWrite.rawValue == "read-write")
    }
}
