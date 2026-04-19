import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import PearlKit 1.0

Item {
    id: root

    // ---- public API
    property string variant: "default"
    property int currentIndex: 0
    property string currentKey: ""

    signal tabDetached(Item tab, string title)
    signal tabRedocked(Item tab, string title)

    // ---- readonly introspection
    readonly property int floatingCount: {
        var n = 0
        for (var k in _floatingMap) n++
        return n
    }
    readonly property int dockedCount: _dockedModel.length

    // ---- default slot — user DetachableTab children land in _host
    default property alias _tabsContent: _host.data

    // ---- private state
    property var _floatingMap: ({})
    property int _floatingCounter: 0
    property var _dockedModel: []
    property bool _ready: false

    // ---- helpers
    function _collectTabs() {
        var result = []
        for (var i = 0; i < _host.children.length; i++) {
            var c = _host.children[i]
            if (c && c.objectName === "detachableTab") result.push(c)
        }
        return result
    }

    function _dockedTabs() {
        return _collectTabs().filter(function (t) { return !t.isFloating })
    }

    function _rebuildModel() {
        _dockedModel = _dockedTabs()
    }

    function indexOfKey(key) {
        if (!key || key.length === 0) return -1
        var docked = _dockedTabs()
        for (var i = 0; i < docked.length; i++) {
            if (docked[i].stackKey === key) return i
        }
        return -1
    }

    function tabAtIndex(index) {
        var docked = _dockedTabs()
        if (index < 0 || index >= docked.length) return null
        return docked[index]
    }

    function tabByKey(key) {
        var all = _collectTabs()
        for (var i = 0; i < all.length; i++) {
            if (all[i].stackKey === key) return all[i]
        }
        for (var k in _floatingMap) {
            var win = _floatingMap[k]
            var tab = win ? win.content : null
            if (tab && tab.stackKey === key) return tab
        }
        return null
    }

    function isFloating(tab) {
        return tab && tab.isFloating === true
    }

    function hasFloating() {
        for (var k in _floatingMap) return true
        return false
    }

    function detachTab(index) {
        var tab = tabAtIndex(index)
        if (tab) _detachItem(tab)
    }

    function detachTabByKey(key) {
        var tab = tabByKey(key)
        if (tab && !tab.isFloating) _detachItem(tab)
    }

    function dockTab(tab) {
        if (tab && tab.isFloating) _dockItem(tab)
    }

    function dockTabByKey(key) {
        var tab = tabByKey(key)
        if (tab && tab.isFloating) _dockItem(tab)
    }

    function raiseFloating(tab) {
        if (!tab) return
        var win = _lookupWindow(tab)
        if (win) { win.raise(); win.requestActivate() }
    }

    function closeAllFloating() {
        for (var k in _floatingMap) {
            var win = _floatingMap[k]
            var tab = win ? win.content : null
            if (tab) {
                tab.parent = _host
                tab.isFloating = false
            }
            if (win) {
                win.content = null
                win.close()
                win.destroy()
            }
        }
        _floatingMap = {}
        _rebuildModel()
        _syncCurrent()
    }

    // ---- internals
    function _lookupWindow(tab) {
        for (var k in _floatingMap) {
            if (_floatingMap[k].content === tab) return _floatingMap[k]
        }
        return null
    }

    function _hostWindow() {
        return root.Window.window
    }

    function _detachItem(tab) {
        if (!tab) return
        if (tab.permanent || tab.nonDetachable) return
        if (tab.isFloating) {
            raiseFloating(tab)
            return
        }

        var host = _hostWindow()
        var wx = host ? host.x + 50 : 100
        var wy = host ? host.y + 50 : 100
        var ww = host ? Math.round(host.width * 0.7) : 800
        var wh = host ? Math.round(host.height * 0.7) : 600

        var wasCurrent = tab.isCurrent
        tab.isFloating = true

        var win = _floatingComp.createObject(root, {
            title: tab.title,
            x: wx, y: wy, width: ww, height: wh
        })
        if (host) win.transientParent = host
        win.content = tab
        win.dockRequested.connect(function () { _dockItem(tab) })

        var key = "__f" + (++_floatingCounter)
        var nextFloating = {}
        for (var fk in _floatingMap) nextFloating[fk] = _floatingMap[fk]
        nextFloating[key] = win
        _floatingMap = nextFloating
        _rebuildModel()

        win.show()

        if (wasCurrent) {
            var docked = _dockedTabs()
            if (docked.length > 0) {
                root.currentIndex = Math.min(root.currentIndex, docked.length - 1)
            } else {
                root.currentIndex = 0
            }
        }
        _syncCurrent()
        root.tabDetached(tab, tab.title)
    }

    function _dockItem(tab) {
        if (!tab || !tab.isFloating) return

        var win = _lookupWindow(tab)
        var removedKey = null
        for (var k in _floatingMap) {
            if (_floatingMap[k] === win) { removedKey = k; break }
        }
        if (removedKey !== null) {
            var nextFloating = {}
            for (var fk in _floatingMap) {
                if (fk !== removedKey) nextFloating[fk] = _floatingMap[fk]
            }
            _floatingMap = nextFloating
        }

        tab.parent = _host
        tab.isFloating = false

        if (win) {
            win.content = null
            win.close()
            win.destroy()
        }

        _rebuildModel()

        var docked = _dockedTabs()
        var idx = docked.indexOf(tab)
        if (idx >= 0) root.currentIndex = idx
        _syncCurrent()
        root.tabRedocked(tab, tab.title)
    }

    function _syncCurrent() {
        if (!_ready) return
        var docked = _dockedTabs()
        var all = _collectTabs()
        for (var i = 0; i < all.length; i++) {
            var item = all[i]
            var di = docked.indexOf(item)
            item.isCurrent = (di === root.currentIndex && !item.isFloating)
        }
        if (root.currentIndex >= 0 && root.currentIndex < docked.length) {
            var key = docked[root.currentIndex].stackKey || ""
            if (key !== root.currentKey) root.currentKey = key
        }
    }

    // ---- UI
    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        TabBar {
            id: _bar
            Layout.fillWidth: true
            variant: root.variant

            onCurrentIndexChanged: {
                if (!root._ready) return
                if (currentIndex !== root.currentIndex) root.currentIndex = currentIndex
            }

            Repeater {
                id: _rep
                model: root._dockedModel

                TabButton {
                    text: modelData ? modelData.title : ""
                    iconSource: modelData ? modelData.iconSource : ""
                    enabled: modelData !== null && modelData !== undefined
                    onDoubleClicked: {
                        if (!modelData) return
                        if (modelData.permanent || modelData.nonDetachable) return
                        root._detachItem(modelData)
                    }
                }
            }
        }

        Item {
            id: _host
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }

    Component {
        id: _floatingComp
        FloatingWindow { }
    }

    // ---- state machine
    onCurrentKeyChanged: {
        if (!_ready) return
        var i = indexOfKey(currentKey)
        if (i !== -1 && i !== currentIndex) currentIndex = i
    }

    onCurrentIndexChanged: {
        if (!_ready) return
        if (_bar.currentIndex !== currentIndex) _bar.currentIndex = currentIndex
        _syncCurrent()
    }

    Component.onCompleted: {
        _rebuildModel()
        if (currentKey && currentKey.length > 0) {
            var i = indexOfKey(currentKey)
            if (i !== -1) currentIndex = i
        }
        _bar.currentIndex = currentIndex
        _ready = true
        _syncCurrent()
    }
}
