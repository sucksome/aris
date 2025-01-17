
/* The main window.

   Copyright (C) 2023 Saksham Attri.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
import QtQuick.Dialogs
import proof.model 1.0
import goal.model 1.0

ApplicationWindow {
    id: rootID

    property font thefont: rootID.font
    property bool isExtFile: false // If the file is opened from an external file
    property bool darkMode: false
    property string filename: "Untitled"
    property bool fileExists: isExtFile
    property int premiseCount: 1
    property bool computePremise: false // set to true if Open or Import Proof are used
    //    property bool closing: false

    // Function to compute premiseCount, used when opening new file
    function computePremiseCount(item) {
        premiseCount = 0
        for (var child in item.contentItem.children) {
            if (item.contentItem.children[child].type === "premise")
                premiseCount++
            //            else if (item.contentItem.children[child].type !== "undefined")
            //                break
        }
    }

    // Function to check if the item is a TextField QML Type
    function isTextField(item) {
        return item instanceof TextField
    }

    // Function to add a Premise
    function addPremise(index, listView) {
        if (computePremise) {
            computePremiseCount(listView)
            computePremise = false
        }
        var insertIndex = (index < premiseCount) ? index + 1 : premiseCount
        theData.insertLine(insertIndex, insertIndex + 1, "", "premise", false,
                           false, false, 0, [-1])
        proofModel.updateLines()
        proofModel.updateRefs(insertIndex, true)
        listView.currentIndex = insertIndex
        cConnector.evalText = "Evaluate Proof"
        premiseCount = premiseCount + 1
    }

    // Function to add a Conclusion
    function addConclusion(index, listView, model) {
        if (index + 1 < premiseCount)
            return
        theData.insertLine(index + 1, index + 2, "", "choose", model.sub,
                           false, false, model.ind, [-1])
        proofModel.updateLines()
        proofModel.updateRefs(index + 1, true)
        listView.currentIndex = index + 1
        cConnector.evalText = "Evaluate Proof"
    }

    width: 1200
    height: 700
    visible: true
    title: qsTr(filename.slice(filename.lastIndexOf(
                                   "/") + 1) + " | " + "GNU Aris")
    font: thefont
    color: darkMode ? "#121212" : "white"

    // Footer to display error messages
    footer: Label {
        height: statusID.implicitHeight
        visible: !(cConnector.evalText === "Correct!"
                   || cConnector.evalText === "Evaluate Proof")

        Text {
            id: statusID
            text: cConnector.evalText
            color: darkMode ? "#CF6679" : "red"
        }
    }

    //    onClosing: function(close){
    //        close.accepted = closing;
    //        onTriggered: if(!closing) exitMessageID.open();
    //    }

    // Burger Button
    Button {
        id: burgerMenu

        height: keyboardID.width
        width: keyboardID.width
        palette {
            button: darkMode ? "#121212" : "white"
        }

        hoverEnabled: true
        ToolTip.visible: hovered
        ToolTip.text: "Menu"

        onClicked: menuOptions.open()

        Text {
            anchors.centerIn: parent
            color: darkMode ? "#BB86FC" : "black"
            text: "\u2630"
            minimumPointSize: 20
        }
    }

    // On-Screen Keyboard
    Frame {
        id: keyboardID

        anchors.verticalCenter: parent.verticalCenter

        KeyGroup {}
    }

    // Drawer associated with the Burger Button
    Drawer {
        id: menuOptions

        width: drawerToolBar.implicitWidth
        height: rootID.height
        interactive: true

        DrawerTools {
            id: drawerToolBar
        }
    }

    // Dialogs associated with the DrawerTools
    FileDialog {
        id: fileDialogID

        title: "Choose the proof file"
        //selectFolder: false
        nameFilters: ["Aris files (*.tle)"]
        fileMode: FileDialog.OpenFile
        defaultSuffix: "tle"
        onAccepted: {
            cConnector.openProof(selectedFile, theData, theGoals)
            filename = selectedFile
            isExtFile = true
            computePremise = true
        }
    }

    FileDialog {
        id: saveAsID

        nameFilters: ["Aris files (*.tle)"]
        title: "Save As"
        fileMode: FileDialog.SaveFile
        defaultSuffix: "tle"
        onAccepted: {
            cConnector.saveProof(selectedFile, theData, theGoals)
            filename = selectedFile
            fileExists = true
        }
    }

    FileDialog {
        id: latexID

        nameFilters: ["Latex files (*.tex)"]
        title: "Save As"
        fileMode: FileDialog.SaveFile
        defaultSuffix: "tex"
        onAccepted: auxConnector.latex(selectedFile, theData, cConnector)
    }

    FileDialog {
        id: importID

        nameFilters: ["Aris files (*.tle)"]
        title: "Import Proof"
        fileMode: FileDialog.OpenFile
        defaultSuffix: "tle"
        onAccepted: {
            isExtFile = true
            computePremise = true
            auxConnector.importProof(selectedFile, theData, cConnector,
                                     proofModel)
        }
    }

    FontDialog {
        id: fontDialogID

        title: "Choose Font"
        onAccepted: thefont = currentFont
    }

    Dialog {
        id: goalDialogID

        title: "Goals"
        width: parent.width / 2
        height: parent.height / 2
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        background: Rectangle {
            anchors.fill: parent
            color: darkMode ? "#1F1B24" : "white"
            opacity: 1 //0.6
            border.width: 2
        }

        palette {

            button: darkMode ? "#1F1A24" : "white"
            buttonText: darkMode ? "white" : "black"
            text: darkMode ? "white" : "black"
            window: darkMode ? "#1F1B24" : "white"
        }

        parent: Overlay.overlay
        focus: true
        //modal: true
        closePolicy: Popup.CloseOnEscape // To allow keyboard access
        standardButtons: Dialog.Ok

        ColumnLayout {
            id: goalAreaID

            anchors.fill: parent

            ListView {
                model: goalDataID
                delegate: GoalLine {}

                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 10

                ScrollBar.vertical: ScrollBar {}
            }
        }
    }

    // Message Dialog when Closing App
    //    Dialog{
    //        id: exitMessageID

    //        title: "The document was modified"
    //        x: (parent.width - width)/2
    //        y: (parent.height - height)/2

    //        parent: Overlay.overlay
    //        focus: true
    //        modal: true
    //        closePolicy: Popup.CloseOnEscape

    //        standardButtons: MessageDialog.Save | MessageDialog.Discard
    //        onAccepted: {
    //            if (Qt.platform.os === "wasm")
    //                cConnector.wasmSaveProof(theData,theGoals);
    //            else
    //                saveAsID.open();

    //            closing = true;
    //        }
    //        onDiscarded: {
    //            closing = true;
    //            rootID.close();
    //        }

    //        Text{
    //            text: "Do you want to save the file"
    //        }

    //    }
    GoalModel {
        id: goalDataID
        glines: theGoals
    }

    ProofModel {
        id: proofModel
        lines: theData
    }

    ProofArea {
        id: proofID
    }
} // TODO://  1)  Dark Mode for Drawer//  2)  Closing App on Desktop
