Config = {}

Config.Debug = false

Config.LSPD_POSITIONS = {
    vector3(461.6504, -989.2350, 24.9149), -- Beispiel-Koordinate
}

Config.jobNames = {'police', 'sheriff'} -- Mehrere Jobs hinzufügen

Config.Locale = {
    help_notify = 'Drücke E um Fingerabdruck zu nehmen',
    menu_title = 'Fingerabdruck Menü',
    scan_finger = 'Fingerabdruck Scannen',
    create_document = 'Neues Dokument erstellen',
    check_finger_title = 'Fingerabdruck checken',
    create_doc_title = 'Dokument Erstellen',
    no_person_found = 'Es wurde keine Person im Umfeld gefunden',
    finger_exists = 'Fingerabdruck existiert',
    no_finger_found = 'Es wurde kein Fingerabdruck gefunden!',
    doc_created = 'Ein Fingerabdruck wurde erfolgreich erstellt',
    already_has_finger = 'Dieser Spieler hat bereits einen Fingerabdruck!'
}

Notify = function(msg)
    exports['cmdHud']:showNotification(msg, type)
end
