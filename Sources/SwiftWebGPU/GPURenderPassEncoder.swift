import JavaScriptKit

/// A GPU render pass encoder for encoding render commands.
///
/// ```swift
/// let renderPass = encoder.beginRenderPass(descriptor: renderPassDescriptor)
/// renderPass.setPipeline(pipeline)
/// renderPass.setVertexBuffer(0, buffer: vertexBuffer)
/// renderPass.draw(vertexCount: 3)
/// renderPass.end()
/// ```
public final class GPURenderPassEncoder: @unchecked Sendable {
    /// The underlying JavaScript `GPURenderPassEncoder` object.
    let jsObject: JSObject

    init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    /// The label of this render pass encoder.
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

    // MARK: - Pipeline and Bind Groups

    /// Sets the render pipeline.
    public func setPipeline(_ pipeline: GPURenderPipeline) {
        _ = jsObject.setPipeline!(pipeline.jsObject)
    }

    /// Sets a bind group.
    public func setBindGroup(
        _ index: UInt32,
        bindGroup: GPUBindGroup?,
        dynamicOffsets: [UInt32]? = nil
    ) {
        if let dynamicOffsets = dynamicOffsets, !dynamicOffsets.isEmpty {
            let offsetsArray = JSObject.global.Array.function!.new()
            for (i, offset) in dynamicOffsets.enumerated() {
                offsetsArray[i] = .number(Double(offset))
            }
            _ = jsObject.setBindGroup!(Double(index), bindGroup?.jsObject.jsValue ?? .null, offsetsArray)
        } else {
            _ = jsObject.setBindGroup!(Double(index), bindGroup?.jsObject.jsValue ?? .null)
        }
    }

    // MARK: - Vertex and Index Buffers

    /// Sets a vertex buffer.
    public func setVertexBuffer(
        _ slot: UInt32,
        buffer: GPUBuffer?,
        offset: UInt64 = 0,
        size: UInt64? = nil
    ) {
        if let size = size {
            _ = jsObject.setVertexBuffer!(Double(slot), buffer?.jsObject.jsValue ?? .null, Double(offset), Double(size))
        } else {
            _ = jsObject.setVertexBuffer!(Double(slot), buffer?.jsObject.jsValue ?? .null, Double(offset))
        }
    }

    /// Sets the index buffer.
    public func setIndexBuffer(
        _ buffer: GPUBuffer,
        format: GPUIndexFormat,
        offset: UInt64 = 0,
        size: UInt64? = nil
    ) {
        if let size = size {
            _ = jsObject.setIndexBuffer!(buffer.jsObject, format.rawValue, Double(offset), Double(size))
        } else {
            _ = jsObject.setIndexBuffer!(buffer.jsObject, format.rawValue, Double(offset))
        }
    }

    // MARK: - Drawing

    /// Draws primitives.
    public func draw(
        vertexCount: UInt32,
        instanceCount: UInt32 = 1,
        firstVertex: UInt32 = 0,
        firstInstance: UInt32 = 0
    ) {
        _ = jsObject.draw!(Double(vertexCount), Double(instanceCount), Double(firstVertex), Double(firstInstance))
    }

    /// Draws indexed primitives.
    public func drawIndexed(
        indexCount: UInt32,
        instanceCount: UInt32 = 1,
        firstIndex: UInt32 = 0,
        baseVertex: Int32 = 0,
        firstInstance: UInt32 = 0
    ) {
        _ = jsObject.drawIndexed!(Double(indexCount), Double(instanceCount), Double(firstIndex), Double(baseVertex), Double(firstInstance))
    }

    /// Draws primitives indirectly.
    public func drawIndirect(indirectBuffer: GPUBuffer, indirectOffset: UInt64) {
        _ = jsObject.drawIndirect!(indirectBuffer.jsObject, Double(indirectOffset))
    }

    /// Draws indexed primitives indirectly.
    public func drawIndexedIndirect(indirectBuffer: GPUBuffer, indirectOffset: UInt64) {
        _ = jsObject.drawIndexedIndirect!(indirectBuffer.jsObject, Double(indirectOffset))
    }

    // MARK: - Viewport and Scissor

    /// Sets the viewport.
    public func setViewport(
        x: Float,
        y: Float,
        width: Float,
        height: Float,
        minDepth: Float,
        maxDepth: Float
    ) {
        _ = jsObject.setViewport!(
            Double(x),
            Double(y),
            Double(width),
            Double(height),
            Double(minDepth),
            Double(maxDepth)
        )
    }

    /// Sets the scissor rectangle.
    public func setScissorRect(x: UInt32, y: UInt32, width: UInt32, height: UInt32) {
        _ = jsObject.setScissorRect!(Double(x), Double(y), Double(width), Double(height))
    }

    // MARK: - Stencil and Blend

    /// Sets the stencil reference value.
    public func setStencilReference(_ reference: UInt32) {
        _ = jsObject.setStencilReference!(Double(reference))
    }

    /// Sets the blend constant.
    public func setBlendConstant(_ color: GPUColor) {
        _ = jsObject.setBlendConstant!(color.toJSValue())
    }

    // MARK: - Occlusion Query

    /// Begins an occlusion query.
    public func beginOcclusionQuery(queryIndex: UInt32) {
        _ = jsObject.beginOcclusionQuery!(Double(queryIndex))
    }

    /// Ends an occlusion query.
    public func endOcclusionQuery() {
        _ = jsObject.endOcclusionQuery!()
    }

    // MARK: - Bundles

    /// Executes render bundles.
    public func executeBundles(_ bundles: [GPURenderBundle]) {
        let bundlesArray = JSObject.global.Array.function!.new()
        for (index, bundle) in bundles.enumerated() {
            bundlesArray[index] = bundle.jsObject.jsValue
        }
        _ = jsObject.executeBundles!(bundlesArray)
    }

    // MARK: - Debug

    /// Inserts a debug marker.
    public func insertDebugMarker(_ markerLabel: String) {
        _ = jsObject.insertDebugMarker!(markerLabel)
    }

    /// Pushes a debug group.
    public func pushDebugGroup(_ groupLabel: String) {
        _ = jsObject.pushDebugGroup!(groupLabel)
    }

    /// Pops a debug group.
    public func popDebugGroup() {
        _ = jsObject.popDebugGroup!()
    }

    // MARK: - End

    /// Ends the render pass.
    public func end() {
        _ = jsObject.end!()
    }
}

// MARK: - GPUComputePassEncoder

/// A GPU compute pass encoder for encoding compute commands.
public final class GPUComputePassEncoder: @unchecked Sendable {
    /// The underlying JavaScript `GPUComputePassEncoder` object.
    let jsObject: JSObject

    init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    /// The label of this compute pass encoder.
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

    /// Sets the compute pipeline.
    public func setPipeline(_ pipeline: GPUComputePipeline) {
        _ = jsObject.setPipeline!(pipeline.jsObject)
    }

    /// Sets a bind group.
    public func setBindGroup(
        _ index: UInt32,
        bindGroup: GPUBindGroup?,
        dynamicOffsets: [UInt32]? = nil
    ) {
        if let dynamicOffsets = dynamicOffsets, !dynamicOffsets.isEmpty {
            let offsetsArray = JSObject.global.Array.function!.new()
            for (i, offset) in dynamicOffsets.enumerated() {
                offsetsArray[i] = .number(Double(offset))
            }
            _ = jsObject.setBindGroup!(Double(index), bindGroup?.jsObject.jsValue ?? .null, offsetsArray)
        } else {
            _ = jsObject.setBindGroup!(Double(index), bindGroup?.jsObject.jsValue ?? .null)
        }
    }

    /// Dispatches workgroups.
    public func dispatchWorkgroups(
        workgroupCountX: UInt32,
        workgroupCountY: UInt32 = 1,
        workgroupCountZ: UInt32 = 1
    ) {
        _ = jsObject.dispatchWorkgroups!(Double(workgroupCountX), Double(workgroupCountY), Double(workgroupCountZ))
    }

    /// Dispatches workgroups indirectly.
    public func dispatchWorkgroupsIndirect(indirectBuffer: GPUBuffer, indirectOffset: UInt64) {
        _ = jsObject.dispatchWorkgroupsIndirect!(indirectBuffer.jsObject, Double(indirectOffset))
    }

    /// Inserts a debug marker.
    public func insertDebugMarker(_ markerLabel: String) {
        _ = jsObject.insertDebugMarker!(markerLabel)
    }

    /// Pushes a debug group.
    public func pushDebugGroup(_ groupLabel: String) {
        _ = jsObject.pushDebugGroup!(groupLabel)
    }

    /// Pops a debug group.
    public func popDebugGroup() {
        _ = jsObject.popDebugGroup!()
    }

    /// Ends the compute pass.
    public func end() {
        _ = jsObject.end!()
    }
}

// MARK: - GPURenderBundle

/// A GPU render bundle containing pre-recorded render commands.
public final class GPURenderBundle: @unchecked Sendable {
    /// The underlying JavaScript `GPURenderBundle` object.
    let jsObject: JSObject

    init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    /// The label of this render bundle.
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
}

// MARK: - GPURenderBundleEncoder

/// A GPU render bundle encoder for recording render commands into a bundle.
public final class GPURenderBundleEncoder: @unchecked Sendable {
    /// The underlying JavaScript `GPURenderBundleEncoder` object.
    let jsObject: JSObject

    init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    /// The label of this render bundle encoder.
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

    /// Sets the render pipeline.
    public func setPipeline(_ pipeline: GPURenderPipeline) {
        _ = jsObject.setPipeline!(pipeline.jsObject)
    }

    /// Sets a bind group.
    public func setBindGroup(
        _ index: UInt32,
        bindGroup: GPUBindGroup?,
        dynamicOffsets: [UInt32]? = nil
    ) {
        if let dynamicOffsets = dynamicOffsets, !dynamicOffsets.isEmpty {
            let offsetsArray = JSObject.global.Array.function!.new()
            for (i, offset) in dynamicOffsets.enumerated() {
                offsetsArray[i] = .number(Double(offset))
            }
            _ = jsObject.setBindGroup!(Double(index), bindGroup?.jsObject.jsValue ?? .null, offsetsArray)
        } else {
            _ = jsObject.setBindGroup!(Double(index), bindGroup?.jsObject.jsValue ?? .null)
        }
    }

    /// Sets a vertex buffer.
    public func setVertexBuffer(
        _ slot: UInt32,
        buffer: GPUBuffer?,
        offset: UInt64 = 0,
        size: UInt64? = nil
    ) {
        if let size = size {
            _ = jsObject.setVertexBuffer!(Double(slot), buffer?.jsObject.jsValue ?? .null, Double(offset), Double(size))
        } else {
            _ = jsObject.setVertexBuffer!(Double(slot), buffer?.jsObject.jsValue ?? .null, Double(offset))
        }
    }

    /// Sets the index buffer.
    public func setIndexBuffer(
        _ buffer: GPUBuffer,
        format: GPUIndexFormat,
        offset: UInt64 = 0,
        size: UInt64? = nil
    ) {
        if let size = size {
            _ = jsObject.setIndexBuffer!(buffer.jsObject, format.rawValue, Double(offset), Double(size))
        } else {
            _ = jsObject.setIndexBuffer!(buffer.jsObject, format.rawValue, Double(offset))
        }
    }

    /// Draws primitives.
    public func draw(
        vertexCount: UInt32,
        instanceCount: UInt32 = 1,
        firstVertex: UInt32 = 0,
        firstInstance: UInt32 = 0
    ) {
        _ = jsObject.draw!(Double(vertexCount), Double(instanceCount), Double(firstVertex), Double(firstInstance))
    }

    /// Draws indexed primitives.
    public func drawIndexed(
        indexCount: UInt32,
        instanceCount: UInt32 = 1,
        firstIndex: UInt32 = 0,
        baseVertex: Int32 = 0,
        firstInstance: UInt32 = 0
    ) {
        _ = jsObject.drawIndexed!(Double(indexCount), Double(instanceCount), Double(firstIndex), Double(baseVertex), Double(firstInstance))
    }

    /// Draws primitives indirectly.
    public func drawIndirect(indirectBuffer: GPUBuffer, indirectOffset: UInt64) {
        _ = jsObject.drawIndirect!(indirectBuffer.jsObject, Double(indirectOffset))
    }

    /// Draws indexed primitives indirectly.
    public func drawIndexedIndirect(indirectBuffer: GPUBuffer, indirectOffset: UInt64) {
        _ = jsObject.drawIndexedIndirect!(indirectBuffer.jsObject, Double(indirectOffset))
    }

    /// Inserts a debug marker.
    public func insertDebugMarker(_ markerLabel: String) {
        _ = jsObject.insertDebugMarker!(markerLabel)
    }

    /// Pushes a debug group.
    public func pushDebugGroup(_ groupLabel: String) {
        _ = jsObject.pushDebugGroup!(groupLabel)
    }

    /// Pops a debug group.
    public func popDebugGroup() {
        _ = jsObject.popDebugGroup!()
    }

    /// Finishes recording and returns a render bundle.
    public func finish(descriptor: GPURenderBundleDescriptor? = nil) -> GPURenderBundle {
        let jsBundle: JSObject
        if let descriptor = descriptor {
            jsBundle = jsObject.finish!(descriptor.toJSObject()).object!
        } else {
            jsBundle = jsObject.finish!().object!
        }
        return GPURenderBundle(jsObject: jsBundle)
    }
}

// MARK: - GPURenderBundleEncoderDescriptor

/// Descriptor for creating a render bundle encoder.
public struct GPURenderBundleEncoderDescriptor: Sendable {
    /// The color formats.
    public var colorFormats: [GPUTextureFormat?]

    /// The depth/stencil format.
    public var depthStencilFormat: GPUTextureFormat?

    /// The sample count.
    public var sampleCount: UInt32

    /// Whether depth is read-only.
    public var depthReadOnly: Bool

    /// Whether stencil is read-only.
    public var stencilReadOnly: Bool

    /// A label for the render bundle encoder.
    public var label: String?

    public init(
        colorFormats: [GPUTextureFormat?],
        depthStencilFormat: GPUTextureFormat? = nil,
        sampleCount: UInt32 = 1,
        depthReadOnly: Bool = false,
        stencilReadOnly: Bool = false,
        label: String? = nil
    ) {
        self.colorFormats = colorFormats
        self.depthStencilFormat = depthStencilFormat
        self.sampleCount = sampleCount
        self.depthReadOnly = depthReadOnly
        self.stencilReadOnly = stencilReadOnly
        self.label = label
    }

    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()

        let formatsArray = JSObject.global.Array.function!.new()
        for (index, format) in colorFormats.enumerated() {
            if let format = format {
                formatsArray[index] = .string(format.rawValue)
            } else {
                formatsArray[index] = .null
            }
        }
        obj.colorFormats = formatsArray.jsValue

        if let depthStencilFormat = depthStencilFormat {
            obj.depthStencilFormat = .string(depthStencilFormat.rawValue)
        }
        obj.sampleCount = .number(Double(sampleCount))
        obj.depthReadOnly = .boolean(depthReadOnly)
        obj.stencilReadOnly = .boolean(stencilReadOnly)
        if let label = label {
            obj.label = .string(label)
        }
        return obj
    }
}

// MARK: - GPURenderBundleDescriptor

/// Descriptor for finishing a render bundle.
public struct GPURenderBundleDescriptor: Sendable {
    /// A label for the render bundle.
    public var label: String?

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
