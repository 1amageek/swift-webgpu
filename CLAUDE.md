# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

SwiftWebGPU provides type-safe Swift wrappers for the WebGPU API, enabling GPU-accelerated graphics and compute in WebAssembly applications.

**Architecture:** Swift (WASM) → JavaScriptKit → JavaScript → WebGPU API

This package is designed for Swift compiled to WebAssembly, running in a browser environment with access to WebGPU.

## Build Commands

```bash
# Build the package (note: designed for WASM target, native build will show Sendable warnings)
swift build

# Run tests
swift test

# Build for WASM (requires SwiftWasm toolchain)
swift build --triple wasm32-unknown-wasi
```

## Architecture

### Core Design Patterns

**1. JSObject Wrapper Pattern**
All WebGPU objects wrap a JavaScript `JSObject`:
```swift
public final class GPUDevice: Sendable {
    let jsObject: JSObject
    init(jsObject: JSObject) { self.jsObject = jsObject }
}
```

**2. Descriptor Pattern**
Configuration structs implement `toJSObject()` for JS interop:
```swift
struct GPUBufferDescriptor {
    func toJSObject() -> JSObject {
        let obj = JSObject.global.Object.function!.new()
        obj.size = .number(Double(size))
        return obj
    }
}
```

**3. Enum with RawValue**
WebGPU constants map to String-backed enums:
```swift
public enum GPUTextureFormat: String, Sendable {
    case rgba8unorm = "rgba8unorm"
}
// Usage: obj.format = .string(format.rawValue)
```

**4. OptionSet for Flags**
WebGPU flags use `OptionSet`:
```swift
public struct GPUBufferUsage: OptionSet, Sendable {
    public static let vertex = GPUBufferUsage(rawValue: 0x0020)
}
// Usage: obj.usage = .number(Double(usage.rawValue))
```

### File Organization

| File | Purpose |
|------|---------|
| `GPU.swift` | Entry point (`navigator.gpu`), adapter request |
| `GPUAdapter.swift` | Adapter info, device request, limits |
| `GPUDevice.swift` | Resource creation, error handling |
| `GPUBuffer.swift` | Buffer management, mapping |
| `GPUTexture.swift` | Textures, views, external textures |
| `GPUBindGroup.swift` | Bind groups, layouts, bindings |
| `GPUShaderModule.swift` | Shader compilation |
| `GPURenderPipeline.swift` | Render/compute pipelines |
| `GPUCommandEncoder.swift` | Command encoding, render passes |
| `GPURenderPassEncoder.swift` | Render/compute pass encoding |
| `GPUQueue.swift` | Command submission, queries |
| `GPUCanvasContext.swift` | Canvas configuration |
| `GPUEnums.swift` | All WebGPU enums |
| `GPUFlags.swift` | All OptionSet flags |

### JavaScriptKit Patterns

**Property Access:**
```swift
let value = jsObject.property.string    // String?
let num = jsObject.count.number         // Double?
jsObject.name = .string("value")        // Set property
```

**Method Calls:**
```swift
let result = jsObject.method!(arg1, arg2)  // ! for method call
let obj = result.object!                    // Extract JSObject
```

**Creating JS Objects:**
```swift
let obj = JSObject.global.Object.function!.new()
let array = JSObject.global.Array.function!.new()
```

**Async/Promises:**
```swift
let promise = JSPromise(jsObject.asyncMethod!().object!)!
let result = try await promise.value
```

**Iterating JS Collections:**
```swift
let iterator = jsFeatures.values!().object!
while true {
    let next = iterator.next!().object!
    if next.done.boolean == true { break }
    // Use next.value
}
```

## References

- [WebGPU Specification](https://www.w3.org/TR/webgpu/)
- [JavaScriptKit](https://github.com/swiftwasm/JavaScriptKit)
- [WebGPU MDN](https://developer.mozilla.org/en-US/docs/Web/API/WebGPU_API)
