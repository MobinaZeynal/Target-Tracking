/*
 * Copyright (C) 2020-2021 Frank Mertens.
 *
 * Distribution and use is allowed under the terms of the zlib license
 * (see LICENSE-zlib).
 *
 */

import QtQuick.Controls 2.6
import QtQuick.Controls.Universal 2.6

ApplicationWindow {
    visible: true

    Universal.theme: Universal.Dark
    // Universal.accent: Universal.Violet

    minimumWidth: colorChooser.width
    minimumHeight: colorChooser.height
    maximumWidth: minimumWidth
    maximumHeight: minimumHeight

    title: "FluxColor"

    ColorChooser {
        id: colorChooser
    }
}
