import QtQuick
import PearlKit 1.0

Text {
    id: control

    // ---- public API
    property string variant: "body"
    // variants: "title" | "heading" | "body" | "muted" | "label" | "code" | "mono"

    // ---- resolvers
    readonly property int _pxSize: {
        switch (variant) {
            case "title":   return Tokens.font.size.xxl   // 24
            case "heading": return Tokens.font.size.lg    // 18
            default:        return Tokens.font.size.sm    // 14
        }
    }

    readonly property int _weight: {
        switch (variant) {
            case "title":   return Tokens.font.weight.semibold
            case "heading": return Tokens.font.weight.semibold
            case "label":   return Tokens.font.weight.medium
            default:        return Tokens.font.weight.regular
        }
    }

    readonly property color _color: {
        if (variant === "muted" || variant === "code") return Tokens.mutedForeground
        return Tokens.foreground
    }

    readonly property string _family: {
        if (variant === "code" || variant === "mono") return Tokens.font.mono
        return Tokens.font.ui
    }

    // ---- Text defaults
    font.family:    _family
    font.pixelSize: _pxSize
    font.weight:    _weight
    color:          control.enabled
        ? _color
        : Qt.rgba(_color.r, _color.g, _color.b, 0.5)

    // title/heading use tight line-height; label uses shadcn leading-none (1.0); body variants natural
    lineHeight: {
        if (variant === "title" || variant === "heading") return 1.2
        if (variant === "label") return 1.0
        return 1.2
    }
    lineHeightMode: Text.ProportionalHeight

    renderType: Text.NativeRendering
    antialiasing: true
    wrapMode: Text.NoWrap
    elide: Text.ElideNone
}
