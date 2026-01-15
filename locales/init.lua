local DE = require 'locales/de'
local EN = require 'locales/en'

local Languages = {
	de = DE,
	en = EN,
}

Locales = Languages[Config.Language] or Languages.de
