pragma Singleton
import QtQuick
import QtCore

QtObject {
    id: root

    property var notes: []
    property var categories: ["notes"]
    property string currentCategory: "notes"

    property Settings store: Settings {
        location: StandardPaths.standardLocations(StandardPaths.ConfigLocation)[0] + "/quickshell/notes.conf"
        category: "notes"
        property string data: "[]"
        property string categoriesData: "[\"notes\"]"
        property string currentCategoryData: "notes"
    }

    function load() {
        try {
            var loadedNotes = JSON.parse(store.data)
            notes = loadedNotes
        } catch (e) {
            console.warn("Failed to load notes:", e)
            notes = []
        }

        try {
            var loadedCategories = JSON.parse(store.categoriesData)
            if (loadedCategories.indexOf("notes") === -1) {
                loadedCategories.unshift("notes")
            }
            categories = loadedCategories
        } catch (e) {
            console.warn("Failed to load categories:", e)
            categories = ["notes"]
        }

        currentCategory = store.currentCategoryData || "notes"
    }

    function save() {
        store.data = JSON.stringify(notes)
        store.categoriesData = JSON.stringify(categories)
        store.currentCategoryData = currentCategory
    }

    function add(text, category) {
        if (text.trim() === "") return
        var cat = category || currentCategory
        var newNotes = notes.slice()
        newNotes.unshift({
            id: Date.now() + Math.random(),
            text: text,
            time: Date.now(),
            category: cat
        })
        notes = newNotes
        save()
    }

    function remove(index) {
        var newNotes = notes.slice()
        newNotes.splice(index, 1)
        notes = newNotes
        save()
    }

    function addCategory(categoryName) {
        if (categoryName.trim() === "") return
        if (categories.indexOf(categoryName) !== -1) return

        var newCategories = categories.slice()
        newCategories.push(categoryName)
        categories = newCategories
        save()
    }

    function removeCategory(categoryName) {
        if (categoryName === "notes") return // Cannot remove default category

        var newCategories = categories.slice()
        var index = newCategories.indexOf(categoryName)
        if (index !== -1) {
            newCategories.splice(index, 1)
            categories = newCategories

            // Remove all notes in this category
            var newNotes = notes.filter(function(note) {
                return note.category !== categoryName
            })
            notes = newNotes

            // Switch to default if current category was removed
            if (currentCategory === categoryName) {
                currentCategory = "notes"
            }

            save()
        }
    }

    function setCurrentCategory(categoryName) {
        currentCategory = categoryName
        save()
    }

    function getNotesForCategory(categoryName) {
        return notes.filter(function(note) {
            return note.category === categoryName
        })
    }

    Component.onCompleted: load()
}