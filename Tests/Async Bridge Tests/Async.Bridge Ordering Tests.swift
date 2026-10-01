import Async_Bridge
import Async
import Testing

@Suite
struct `Async bridge ordering` {
    @Test
    func `buffered elements are delivered first in, first out`() async {
        let bridge = Async.Bridge<Int>()
        bridge.push(1)
        bridge.push([2, 3])
        bridge.push(contentsOf: 4...5)

        var received: [Int] = []
        for _ in 0..<5 {
            if let value = await bridge.next() { received.append(value) }
        }
        #expect(received == [1, 2, 3, 4, 5])
    }

    @Test
    func `finish drains the buffer before reporting the end`() async {
        let bridge = Async.Bridge<Int>()
        bridge.push(7)
        bridge.finish()

        #expect(bridge.isFinished)
        #expect(await bridge.next() == 7)
        #expect(await bridge.next() == nil)
    }

    @Test
    func `elements pushed after finish are dropped`() async {
        let bridge = Async.Bridge<Int>()
        bridge.finish()
        bridge.push(1)
        bridge.push([2, 3])

        #expect(await bridge.next() == nil)
    }

    @Test
    func `draining push takes elements until the source returns nil`() async {
        let bridge = Async.Bridge<Int>()
        var source = [10, 20, 30].makeIterator()
        bridge.push(draining: { source.next() })
        bridge.finish()

        var received: [Int] = []
        while let value = await bridge.next() { received.append(value) }
        #expect(received == [10, 20, 30])
    }

    @Test
    func `pushing an empty array leaves the bridge empty`() async {
        let bridge = Async.Bridge<Int>()
        bridge.push([Int]())
        bridge.finish()

        #expect(await bridge.next() == nil)
    }
}
