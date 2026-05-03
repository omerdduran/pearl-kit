import QtQuick
import PearlKit 1.0

ShowcasePage {
    title: "Clinical Primitives"
    subtitle: "DALI viewport overlays, 3D primitives, and clinical sample chrome."
    gridPreset: "two-col"

    ShowcaseTile {
        label: "OrientationCube"
        OrientationCube {
            width: 120
            height: 120
        }
    }
    ShowcaseTile {
        label: "Render3D"
        Render3D {
            width: 360
            height: 240
        }
    }
    ShowcaseTile {
        label: "Viewport2D"
        Viewport2D {
            width: 360
            height: 240
        }
    }
    ShowcaseTile {
        label: "VTKViewport"
        VTKViewport {
            width: 360
            height: 240
        }
    }
    ShowcaseTile {
        label: "ImageViewport"
        ImageViewport {
            width: 360
            height: 240
        }
    }
    ShowcaseTile {
        label: "ScannerMark"
        ScannerMark {
            width: 80
            height: 80
        }
    }
    ShowcaseTile {
        label: "SampleCasePreview"
        SampleCasePreview {
            width: 320
            height: 200
        }
    }
    ShowcaseTile {
        label: "Crosshair"
        Crosshair {
            width: 240
            height: 160
        }
    }
    ShowcaseTile {
        label: "AngleArc"
        AngleArc {
            width: 200
            height: 160
        }
    }
    ShowcaseTile {
        label: "ArchPath"
        ArchPath {
            width: 320
            height: 160
        }
    }
    ShowcaseTile {
        label: "DistanceLine"
        DistanceLine {
            width: 240
            height: 80
        }
    }
    ShowcaseTile {
        label: "Arrow"
        Arrow {
            width: 200
            height: 80
        }
    }
    ShowcaseTile {
        label: "RectSelect"
        RectSelect {
            width: 240
            height: 160
        }
    }
    ShowcaseTile {
        label: "TextAnnotation"
        TextAnnotation {
            width: 240
        }
    }
    ShowcaseTile {
        label: "ImplantMarker"
        ImplantMarker {
            width: 80
            height: 80
        }
    }
    ShowcaseTile {
        label: "WindowLevelPresets"
        WindowLevelPresets {
            width: 280
        }
    }
    ShowcaseTile {
        label: "SliceCounter"
        SliceCounter {
            width: 200
        }
    }
    ShowcaseTile {
        label: "ToolPalette"
        ToolPalette {
            width: 64
            height: 320
        }
    }
    ShowcaseTile {
        label: "ImplantParameterPanel"
        ImplantParameterPanel {
            width: 360
        }
    }
}
