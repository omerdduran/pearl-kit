import QtQuick
import QtQuick.Layouts
import PearlKit 1.0

StackLayout {
    id: control

    // ---- public API
    property bool animated: false
    property string currentKey: ""

    // ---- private
    property bool _ready: false

    // ---- key <-> index lookup
    function indexOfKey(key) {
        if (!key || key.length === 0) return -1
        for (var i = 0; i < children.length; i++) {
            var c = children[i]
            if (c && c.stackKey === key) return i
        }
        return -1
    }

    function _syncKeyFromIndex() {
        if (currentIndex < 0 || currentIndex >= children.length) return
        var child = children[currentIndex]
        if (!child) return
        var key = (child.stackKey === undefined) ? "" : child.stackKey
        if (key !== currentKey) currentKey = key
    }

    onCurrentKeyChanged: {
        if (!_ready) return
        var i = indexOfKey(currentKey)
        if (i !== -1 && i !== currentIndex) currentIndex = i
    }

    onCurrentIndexChanged: {
        if (!_ready) return
        _syncKeyFromIndex()
        if (animated && currentIndex >= 0 && currentIndex < children.length) {
            var child = children[currentIndex]
            if (child) {
                child.opacity = 0.0
                _fadeAnim.target = child
                _fadeAnim.restart()
            }
        }
    }

    Component.onCompleted: {
        if (currentKey.length > 0) {
            var i = indexOfKey(currentKey)
            if (i !== -1 && i !== currentIndex) currentIndex = i
        }
        _ready = true
        _syncKeyFromIndex()
    }

    NumberAnimation {
        id: _fadeAnim
        property: "opacity"
        from: 0.0
        to: 1.0
        duration: Tokens.motion.fast
        easing.type: Easing.OutCubic
    }
}
