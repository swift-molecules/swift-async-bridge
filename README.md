# swift-async-bridge

Use this package when synchronous code (a callback, a delegate, a C event loop) must hand values to one async consumer without ever suspending or blocking the producer. Start from `Async.Bridge<Element>`: producers on any thread call `push`, the consumer awaits `next()`, and `finish()` ends the stream. When the producer must feel backpressure, or sender and receiver should be separate owned ends, use the channels in swift-async-channel instead.

## Laws

- The buffer is unbounded: `push` never waits and never drops while the bridge is open.
- Elements are delivered first in, first out, across every form of `push`. A batch pushed by one call is appended contiguously.
- Any number of producers may push concurrently; exactly one consumer may call `next()` at a time. Debug builds trap on a second concurrent `next()`; release builds do not check.
- `finish()` is idempotent. After it, `isFinished` is `true` at once, buffered elements are still delivered in order, and only then does `next()` return `nil`.
- Elements pushed after `finish()` are dropped silently; `push(draining:)` does not call its closure at all.
- `push(draining:)` calls its closure under the bridge's lock until it returns `nil`; the closure must not touch the same bridge.
- `next()` ignores task cancellation: a cancelled consumer keeps waiting and resumes with the next pushed element, or with `nil` after `finish()`.
- Unavailable in Embedded Swift.
