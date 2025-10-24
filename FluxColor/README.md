FluxColor (QML Plugin)
======================

About
-----
FluxColor is a light-weight HSV color chooser for Qt >=5.6.
The implementation is purely based on QtQuickControls 2.

Screenshot
----------

![Screenshot](screenshot.png)

How to use
----------

Copy the FluxColor plugin directory to your project resources or add its parent path to your QML import path.
See https://doc.qt.io/qt-5/qqmlengine.html#addImportPath for details on import path handling in C++ projects.

The FluxColor plugin provides a single `ColorChooser` type (see example below). It works best with a dark style, e.g. Universal Dark. You can select the style by pointing the environemnt variable `QT_QUICK_CONTROLS_CONF` to the `qtquickcontrols2.conf` shipped with this plugin:
```
QT_QUICK_CONTROLS_CONF=qtquickcontrols2.conf
```
See https://doc.qt.io/qt-5/qtquickcontrols2-configuration.html for details on style selection.

Example (QML)
-------------

```qml
import QtQuick.Controls 2.6
import QtQuick.Controls.Universal 2.6
import FluxColor 1.0 as Flux

ApplicationWindow {
    visible: true

    Universal.theme: Universal.Dark
    // Universal.accent: Universal.Violet

    minimumWidth: colorChooser.width
    minimumHeight: colorChooser.height
    maximumWidth: minimumWidth
    maximumHeight: minimumHeight

    title: "Select Color"

    Flux.ColorChooser {
        id: colorChoooser
    }
}
```

License
-------

```
Copyright (C) 2020-2021 Frank Mertens

This software is provided 'as-is', without any express or implied
warranty.  In no event will the authors be held liable for any damages
arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not
   claim that you wrote the original software. If you use this software
   in a product, an acknowledgment in the product documentation would be
   appreciated but is not required.
2. Altered source versions must be plainly marked as such, and must not be
   misrepresented as being the original software.
3. This notice may not be removed or altered from any source distribution.

Frank Mertens
frank@cyblogic.de
```