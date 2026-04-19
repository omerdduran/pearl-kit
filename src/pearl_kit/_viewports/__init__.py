"""pearl-kit viewport primitives — native QQuickItem hosts for pixel surfaces.

These items embed heavy render backends (VTK, QGraphicsScene, OpenGL mesh) into
a QML scene without losing their existing behaviour. Each item exposes a small
Python API intended for consumers that already own a renderer (e.g. DALI's
`ImageViewer`, `VolumeRenderViewer`) and want to project its output into QML.

VTK support is optional. Consumers that do not need the `VTKViewportItem`
should not need VTK installed.
"""

from __future__ import annotations

from ._image_viewport_item import ImageViewportItem
from ._vtk_viewport_item import VTKViewportItem, vtk_available

__all__ = [
    "ImageViewportItem",
    "VTKViewportItem",
    "vtk_available",
]
