Config = {}

Config.Language = 'de'  -- 'de' für Deutsch, 'en' für Englisch

Config.ExtrasEnabled = true

Config.BagVariants = {[40] = true, [41] = true, [44] = true, [45] = true}

-- Fahrzeug-spezifische Sitzkonfigurationen
-- Nutze den Fahrzeug-Modelnamen in Kleinbuchstaben als Schlüssel (z.B. 'hlf')
-- oder die Model-Hash-Zeichenfolge.
-- Zwei Formen werden unterstützt:
-- 1) Nur Labels (einfach):
--    seats = { 'Fahrer', 'Beifahrer', 'Sitz 1' }
--    Die Indizes werden automatisch berechnet (1 -> -1, 2 -> 0, 3 -> 1, ...).
-- 2) Explizite Definition (Label + optionaler index):
--    seats = { {label='Fahrer', index=-1}, {label='Beifahrer', index=0}, {label='Sitz 1', index=2} }
--    Wenn `index` vorhanden ist, wird dieser verwendet statt der automatischen Logik.
-- Beispiel-Tabellen:
Config.VehicleSeats = {
    ['hlf'] = {
        seats = {
            { label = 'Maschinist', index = -1 },
            { label = 'Gruppenführer', index = 0 },
            { label = 'Melder', index = 1 },
            { label = 'Angriffstruppführer', index = 2 },
            { label = 'Angriffstruppmitglied', index = 3 },
            { label = 'Wassertruppführer', index = 4 },
            { label = 'Wassertruppmitglied', index = 5 },
            { label = 'Schlauchtruppführer', index = 6 },
            { label = 'Schlauchtruppmitglied', index = 7 },
        }
    },
}
