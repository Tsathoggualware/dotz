import Quickshell
import Quickshell.Io
import Quickshell.Widgets

import QtQuick
import QtQuick.Layouts
import QtQuick.Effects   // Qt 6 effects

Text {
    property string mainFont: "FiraCode"
    property string symbolFont: "Symbols Nerd Font Mono"
    property int pointSize: 12
    property int symbolSize: pointSize * 1.4
    property string symbolText
    property bool dim

    text: wrapSymbols(symbolText)
    anchors.centerIn: parent
    color: dim ? "#CCCCCC" : "white"
    textFormat: Text.RichText

    font {
        family: mainFont
        pointSize: pointSize
    }

    Text {
        id: textcopy
        visible: false
        text: parent.text
        textFormat: parent.textFormat
        color: parent.color
        font: parent.font
    }

ShaderEffect {
    anchors.fill: textcopy
    property variant source: textcopy
    fragmentShader: "
        #version 330
        uniform sampler2D source;
        in vec2 qt_TexCoord0;
        out vec4 fragColor;
        void main() {
            vec4 base = texture(source, qt_TexCoord0);
            vec4 blur = vec4(0.0);

            blur += texture(source, qt_TexCoord0 + vec2( 1.0/512.0,  1.0/512.0));
            blur += texture(source, qt_TexCoord0 + vec2(-1.0/512.0, -1.0/512.0));
            blur += texture(source, qt_TexCoord0 + vec2( 1.0/512.0, -1.0/512.0));
            blur += texture(source, qt_TexCoord0 + vec2(-1.0/512.0,  1.0/512.0));

            fragColor = vec4(0,0,0,0.7) * (blur.a * 0.25) + base;
        }
    "
}
}