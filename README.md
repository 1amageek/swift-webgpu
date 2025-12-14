# SwiftWebGPU

Type-safe Swift bindings for the [WebGPU API](https://www.w3.org/TR/webgpu/), enabling GPU-accelerated graphics and compute in WebAssembly applications.

## Overview

SwiftWebGPU provides idiomatic Swift wrappers for the WebGPU API, allowing you to write GPU-accelerated code in Swift that runs in the browser via WebAssembly.

**Architecture:** Swift (WASM) → JavaScriptKit → JavaScript → WebGPU API

## Requirements

- Swift 6.0+
- [SwiftWasm](https://swiftwasm.org/) toolchain for WebAssembly compilation
- A browser with WebGPU support (Chrome 113+, Edge 113+, Firefox 114+ with flag)

## Installation

Add SwiftWebGPU to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/1amageek/swift-webgpu.git", from: "0.1.0")
]
```

Then add it to your target dependencies:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "SwiftWebGPU", package: "swift-webgpu")
    ]
)
```

## Usage

### Getting Started

```swift
import SwiftWebGPU

// Check WebGPU availability
guard let gpu = GPU.shared else {
    print("WebGPU is not supported")
    return
}

// Request an adapter and device
let adapter = try await gpu.requestAdapter()
let device = try await adapter?.requestDevice()
```

### Creating a Buffer

```swift
let buffer = device.createBuffer(descriptor: GPUBufferDescriptor(
    size: 256,
    usage: [.vertex, .copyDst]
))
```

### Creating a Shader Module

```swift
let shaderModule = device.createShaderModule(descriptor: GPUShaderModuleDescriptor(
    code: """
    @vertex
    fn vs_main(@builtin(vertex_index) idx: u32) -> @builtin(position) vec4f {
        var positions = array<vec2f, 3>(
            vec2f(0.0, 0.5),
            vec2f(-0.5, -0.5),
            vec2f(0.5, -0.5)
        );
        return vec4f(positions[idx], 0.0, 1.0);
    }

    @fragment
    fn fs_main() -> @location(0) vec4f {
        return vec4f(1.0, 0.0, 0.0, 1.0);
    }
    """
))
```

### Creating a Render Pipeline

```swift
let pipeline = device.createRenderPipeline(descriptor: GPURenderPipelineDescriptor(
    vertex: GPUVertexState(
        module: shaderModule,
        entryPoint: "vs_main"
    ),
    fragment: GPUFragmentState(
        module: shaderModule,
        entryPoint: "fs_main",
        targets: [
            GPUColorTargetState(format: gpu.preferredCanvasFormat)
        ]
    )
))
```

### Rendering

```swift
// Get the canvas context
let canvas = JSObject.global.document.getElementById!("canvas").object!
let context = GPUCanvasContext(jsObject: canvas.getContext!("webgpu").object!)

context.configure(GPUCanvasConfiguration(
    device: device,
    format: gpu.preferredCanvasFormat
))

// Create command encoder and render
let encoder = device.createCommandEncoder()
let renderPass = encoder.beginRenderPass(descriptor: GPURenderPassDescriptor(
    colorAttachments: [
        GPURenderPassColorAttachment(
            view: context.getCurrentTexture().createView(),
            loadOp: .clear,
            storeOp: .store,
            clearValue: GPUColor(r: 0.0, g: 0.0, b: 0.0, a: 1.0)
        )
    ]
))

renderPass.setPipeline(pipeline)
renderPass.draw(3)
renderPass.end()

device.queue.submit([encoder.finish()])
```

## API Overview

### Core Classes

| Class | Description |
|-------|-------------|
| `GPU` | Entry point via `navigator.gpu` |
| `GPUAdapter` | Represents a GPU adapter |
| `GPUDevice` | Main interface for creating GPU resources |
| `GPUBuffer` | GPU buffer for vertex/index/uniform data |
| `GPUTexture` | GPU texture resource |
| `GPUShaderModule` | Compiled shader module |
| `GPURenderPipeline` | Render pipeline configuration |
| `GPUComputePipeline` | Compute pipeline configuration |
| `GPUCommandEncoder` | Records GPU commands |
| `GPURenderPassEncoder` | Encodes render pass commands |
| `GPUComputePassEncoder` | Encodes compute pass commands |
| `GPUQueue` | Command submission queue |
| `GPUBindGroup` | Resource bindings for shaders |
| `GPUCanvasContext` | Canvas rendering context |

### Enums

All WebGPU enums are represented as Swift enums with `String` raw values matching the WebGPU specification:

```swift
public enum GPUTextureFormat: String, Sendable {
    case rgba8unorm = "rgba8unorm"
    case bgra8unorm = "bgra8unorm"
    case depth24plus = "depth24plus"
    // ...
}
```

### Flags

WebGPU flags are represented as `OptionSet` types:

```swift
public struct GPUBufferUsage: OptionSet, Sendable {
    public static let mapRead = GPUBufferUsage(rawValue: 0x0001)
    public static let mapWrite = GPUBufferUsage(rawValue: 0x0002)
    public static let copyDst = GPUBufferUsage(rawValue: 0x0008)
    public static let vertex = GPUBufferUsage(rawValue: 0x0020)
    public static let uniform = GPUBufferUsage(rawValue: 0x0040)
    // ...
}

// Usage
let usage: GPUBufferUsage = [.vertex, .copyDst]
```

## Building for WebAssembly

```bash
# Build for WASM (requires SwiftWasm toolchain)
swift build --triple wasm32-unknown-wasi
```

## References

- [WebGPU Specification](https://www.w3.org/TR/webgpu/)
- [WGSL Specification](https://www.w3.org/TR/WGSL/)
- [WebGPU MDN Documentation](https://developer.mozilla.org/en-US/docs/Web/API/WebGPU_API)
- [JavaScriptKit](https://github.com/swiftwasm/JavaScriptKit)
- [SwiftWasm](https://swiftwasm.org/)

## License

MIT License
