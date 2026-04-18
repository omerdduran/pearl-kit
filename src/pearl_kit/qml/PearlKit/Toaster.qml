pragma Singleton
import QtQuick
import PearlKit 1.0

QtObject {
    id: root

    property string position: "top-right"
    property int maxStack: 3
    property int defaultDuration: 4000

    readonly property ListModel _stack: ListModel { }

    property var _bridge: null
    property int _nextId: 0

    signal dismissRequested(int id)

    function show(opts) {
        const entry = _normalize(opts)
        if (!_isAppActive() && _bridge) {
            _bridge.showOsNotification(entry.title, entry.description, entry.type === "error")
            return entry.id
        }
        while (_stack.count >= maxStack)
            _stack.remove(0)
        _stack.append(entry)
        return entry.id
    }

    function dismiss(id) {
        dismissRequested(id)
    }

    function dismissAll() {
        for (var i = _stack.count - 1; i >= 0; --i)
            dismissRequested(_stack.get(i).id)
    }

    function _bindBridge(ref) {
        _bridge = ref
    }

    function _removeById(id) {
        for (var i = 0; i < _stack.count; ++i) {
            if (_stack.get(i).id === id) {
                _stack.remove(i)
                return
            }
        }
    }

    function _normalize(opts) {
        const o = opts || {}
        const type = o.type || "default"
        const isLoading = type === "loading"
        return {
            id: ++_nextId,
            type: type,
            title: o.title || "",
            description: o.description || "",
            duration: o.duration !== undefined
                ? o.duration
                : (isLoading ? 0 : defaultDuration)
        }
    }

    function _isAppActive() {
        if (!_bridge)
            return true
        return _bridge.isAppActive
    }
}
