pragma Singleton
import QtQuick
import QtCore

QtObject {
    id: root

    property var notes: []

    property Settings store: Settings {
        // Set application identifiers
        location: StandardPaths.standardLocations(StandardPaths.ConfigLocation)[0] + "/quickshell/notes.conf"
        category: "notes"
        property string data: "[]"
    }

    function load() {
        try {
            var loadedNotes = JSON.parse(store.data)
            notes = loadedNotes
        } catch (e) {
            console.warn("Failed to load notes:", e)
            notes = []
        }
    }

    function save() {
        store.data = JSON.stringify(notes)
    }

    function add(text) {
        if (text.trim() === "") return
        var newNotes = notes.slice() // Create a copy
        newNotes.unshift({ text: text, time: Date.now() })
        notes = newNotes // Assign new array to trigger change
        save()
    }

    function remove(index) {
        var newNotes = notes.slice() // Create a copy
        newNotes.splice(index, 1)
        notes = newNotes // Assign new array to trigger change
        save()
    }

    Component.onCompleted: load()
}
