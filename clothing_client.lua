ESX = exports["es_extended"]:getSharedObject()

Config = Config or {}
Config.Commands = {
	[Locales and Locales['top'] or "top"] = { Func = function() ToggleClothing("Top") end, Sprite = "top", Desc = ((Locales and Locales['top_desc']) or "Ziehen Sie Ihr Oberteil aus/an"), Button = 1, Name = ((Locales and Locales['cmd_top_name']) or "Torso") },
	[Locales and Locales['gloves'] or "gloves"] = { Func = function() ToggleClothing("Pants") end, Sprite = "pants", Desc = ((Locales and Locales['pants_desc']) or "Ziehen Sie Ihre Hose aus/an"), Button = 2, Name = ((Locales and Locales['cmd_pants_name']) or "Pants") },
	[Locales and Locales['visor'] or "visor"] = { Func = function() ToggleProps("Visor") end, Sprite = "visor", Desc = ((Locales and Locales['visor_desc']) or "Visier"), Button = 3, Name = ((Locales and Locales['cmd_visor_name']) or "Visor") },
	[Locales and Locales['bag'] or "bag"] = { Func = function() ToggleClothing("Bag") end, Sprite = "bag", Desc = ((Locales and Locales['bag_desc']) or "Öffne oder verschließe deine Tasche"), Button = 8, Name = ((Locales and Locales['cmd_bag_name']) or "Bag") },
	[Locales and Locales['shoes'] or "shoes"] = { Func = function() ToggleClothing("Shoes") end, Sprite = "shoes", Desc = ((Locales and Locales['shoes_desc']) or "Schuhe ausziehen/anziehen"), Button = 5, Name = ((Locales and Locales['cmd_shoes_name']) or "Shoes") },
	[Locales and Locales['vest'] or "vest"] = { Func = function() ToggleClothing("Vest") end, Sprite = "vest", Desc = ((Locales and Locales['vest_desc']) or "Weste ausziehen/anziehen"), Button = 14, Name = ((Locales and Locales['cmd_vest_name']) or "Vest") },
	[Locales and Locales['hair'] or "hair"] = { Func = function() ToggleClothing("hair") end, Sprite = "hair", Desc = ((Locales and Locales['hair_desc']) or "Haar hoch/runter/zu einem Dutt/Ponytail."), Button = 7, Name = ((Locales and Locales['cmd_hair_name']) or "Hair") },
	[Locales and Locales['hat'] or "hat"] = { Func = function() ToggleProps("Hat") end, Sprite = "hat", Desc = ((Locales and Locales['hat_desc']) or "Hut ab/auf"), Button = 4, Name = ((Locales and Locales['cmd_hat_name']) or "Hat") },
	[Locales and Locales['glasses'] or "glasses"] = { Func = function() ToggleProps("Glasses") end, Sprite = "glasses", Desc = ((Locales and Locales['glasses_desc']) or "Brille ab/auf"), Button=9, Name=((Locales and Locales ['cmd_glasses_name'])or"Glasses")},
	[Locales and Locales['ear'] or "ear"] = { Func = function() ToggleProps("Ear") end, Sprite = "ear", Desc = ((Locales and Locales['ear_desc']) or "Nehmen Sie Ihr Ohrzubehör ab/an"), Button = 10, Name = ((Locales and Locales['cmd_ear_name']) or "Ear") },
	[Locales and Locales['neck'] or "neck"] = { Func = function() ToggleClothing("Neck") end, Sprite = "neck", Desc = ((Locales and Locales['neck_desc']) or "Nehmen Sie Ihr Hals-Accessoire ab/an"), Button = 11, Name = ((Locales and Locales['cmd_neck_name']) or "Neck") },
	[Locales and Locales['watch'] or "watch"] = { Func = function() ToggleProps("Watch") end, Sprite = "watch", Desc = ((Locales and Locales['watch_desc']) or "Nehmen Sie Ihre Uhr ab/an"), Button = 12, Name = ((Locales and Locales['cmd_watch_name']) or "Watch"), Rotation = 5.0 },
	[Locales and Locales['bracelet'] or "bracelet"] = { Func = function() ToggleProps("Bracelet") end, Sprite = "bracelet", Desc = ((Locales and Locales['bracelet_desc']) or "Nehmen Sie Ihr Armband ab/an"), Button = 13, Name = ((Locales and Locales['cmd_bracelet_name']) or "Bracelet") },
	[Locales and Locales['mask'] or "mask"] = { Func = function() ToggleClothing("Mask") end, Sprite = "mask", Desc = ((Locales and Locales['mask_desc']) or "Nehmen Sie Ihre Maske ab/auf"), Button = 6, Name = ((Locales and Locales['cmd_mask_name']) or "Mask") }
}

Config.ExtraCommands = {
	[Locales and Locales['pants'] or "pants"] = { Func = function() ToggleClothing("Pants", true) end, Sprite = "pants", Desc = ((Locales and Locales['pants_desc']) or "Ziehen Sie Ihre Hose aus/an"), Name = ((Locales and Locales['cmd_pants_name']) or "Pants"), OffsetX = -0.04, OffsetY = 0.0 },
	[Locales and Locales['shirt'] or "shirt"] = { Func = function() ToggleClothing("Shirt", true) end, Sprite = "shirt", Desc = ((Locales and Locales['top_desc']) or "Ziehen Sie Ihr Oberteil aus/an"), Name = ((Locales and Locales['cmd_shirt_name']) or "shirt"), OffsetX = 0.04, OffsetY = 0.0 },
	[Locales and Locales['reset'] or "reset"] = { Func = function() if not ResetClothing(true) then Notify('Nichts zum Zurücksetzen', 'error') end end, Sprite = "reset", Desc = ((Locales and Locales['reset_desc']) or "Alles wieder in den Normalzustand versetzen"), Name = ((Locales and Locales['cmd_reset_name']) or "reset"), OffsetX = 0.12, OffsetY = 0.2, Rotate = true },
	[Locales and Locales['bagoff'] or "bagoff"] = { Func = function() ToggleClothing("Bagoff", true) end, Sprite = "bagoff", SpriteFunc = function()
			local Bag = GetPedDrawableVariation(PlayerPedId(), 5)
			local BagOff = LastEquipped["Bagoff"]
			if LastEquipped["Bagoff"] then
				if Config.BagVariants[BagOff.Drawable] then
					return "bagoff"
				else
					return "paraoff"
				end
			end
			if Bag ~= 0 then
				if Config.BagVariants[Bag] then
					return "bagoff"
				else
					return "paraoff"
				end
			else
				return false
			end
		end, Desc = "Tasche abnehmen/aufsetzen", Name = "bagoff", OffsetX = -0.12, OffsetY = 0.2 }
}

exports.ox_lib:registerRadial({
	id = 'extrasmenu',
	items = {
		{
			label = Locales['glasses'],
			icon = 'glasses',
			type = 'client',
			onSelect = function()
				ExecuteCommand(Locales and Locales['glasses'] or "glasses")
			end
		},
		{
			label = Locales['visor'],
			icon = 'hat-cowboy-side',
			type = 'client',
			onSelect = function()
				ExecuteCommand(Locales and Locales['visor'] or "visor")
			end
		},
		{
			label = Locales['bag'],
			icon = 'bag-shopping',
			type = 'client',
			onSelect = function()
				ExecuteCommand(Locales and Locales['bag'] or "bag")
			end
		},
		{
			label = Locales['bracelet'],
			icon = 'user',
			type = 'client',
			onSelect = function()
				ExecuteCommand(Locales and Locales['bracelet'] or "bracelet")
			end
		},
		{
			label = Locales['watch'],
			icon = 'stopwatch',
			type = 'client',
			onSelect = function()
				ExecuteCommand(Locales and Locales['watch'] or "watch")
			end
		},
		{
			label = Locales['gloves'],
			icon = 'mitten',
			type = 'client',
			onSelect = function()
				ExecuteCommand(Locales and Locales['gloves'] or "gloves")
			end
		},
		{
			label = Locales['ear'],
			icon = 'ear-deaf',
			type = 'client',
			onSelect = function()
				ExecuteCommand(Locales and Locales['ear'] or "ear")
			end
		},
		{
			label = Locales['neck'],
			icon = 'user-tie',
			type = 'client',
			onSelect = function()
				ExecuteCommand(Locales and Locales['neck'] or "neck")
			end
		}
	}
})

exports.ox_lib:registerRadial({
	id = 'clothingmenu',
	items = {
		{
			label = Locales['mask'],
			icon = 'masks-theater',
			type = 'client',
			onSelect = function()
				ExecuteCommand(Locales and Locales['mask'] or "mask")
			end
		},
		{
			label = Locales['shoes'],
			icon = 'shoe-prints',
			type = 'client',
			onSelect = function()
				ExecuteCommand(Locales and Locales['shoes'] or "shoes")
			end
		},
		{
			label = Locales['pants'],
			icon = 'user',
			type = 'client',
			onSelect = function()
				ExecuteCommand(Locales and Locales['pants'] or "pants")
			end
		},
		{
			label = Locales['shirt'],
			icon = 'shirt',
			type = 'client',
			onSelect = function()
				ExecuteCommand(Locales and Locales['shirt'] or "shirt")
			end
		},
		{
			label = Locales['extras'],
			icon = 'plus',
			menu = 'extrasmenu'
		},
		{
			label = Locales['hat'],
			icon = 'hat-cowboy-side',
			type = 'client',
			onSelect = function()
				ExecuteCommand(Locales and Locales['hat'] or "hat")
			end
		}
	}
})

exports.ox_lib:addRadialItem({
	{
		id = 'clothing',
		label = Locales['clothing'],
		icon = 'shirt',
		menu = 'clothingmenu'
	}
})

local variations = {
	jackets = {male = {}, female = {}},
	hair = {male = {}, female = {}},
	bags = {male = {}, female = {}},
	visor = {male = {}, female = {}},
	gloves = {
		male = {
			[16] = 4,
			[17] = 4,
			[18] = 4,
			[19] = 0,
			[20] = 1,
			[21] = 2,
			[22] = 4,
			[23] = 5,
			[24] = 6,
			[25] = 8,
			[26] = 11,
			[27] = 12,
			[28] = 14,
			[29] = 15,
			[30] = 0,
			[31] = 1,
			[32] = 2,
			[33] = 4,
			[34] = 5,
			[35] = 6,
			[36] = 8,
			[37] = 11,
			[38] = 12,
			[39] = 14,
			[40] = 15,
			[41] = 0,
			[42] = 1,
			[43] = 2,
			[44] = 4,
			[45] = 5,
			[46] = 6,
			[47] = 8,
			[48] = 11,
			[49] = 12,
			[50] = 14,
			[51] = 15,
			[52] = 0,
			[53] = 1,
			[54] = 2,
			[55] = 4,
			[56] = 5,
			[57] = 6,
			[58] = 8,
			[59] = 11,
			[60] = 12,
			[61] = 14,
			[62] = 15,
			[63] = 0,
			[64] = 1,
			[65] = 2,
			[66] = 4,
			[67] = 5,
			[68] = 6,
			[69] = 8,
			[70] = 11,
			[71] = 12,
			[72] = 14,
			[73] = 15,
			[74] = 0,
			[75] = 1,
			[76] = 2,
			[77] = 4,
			[78] = 5,
			[79] = 6,
			[80] = 8,
			[81] = 11,
			[82] = 12,
			[83] = 14,
			[84] = 15,
			[85] = 0,
			[86] = 1,
			[87] = 2,
			[88] = 4,
			[89] = 5,
			[90] = 6,
			[91] = 8,
			[92] = 11,
			[93] = 12,
			[94] = 14,
			[95] = 15,
			[96] = 4,
			[97] = 4,
			[98] = 4,
			[99] = 0,
			[100] = 1,
			[101] = 2,
			[102] = 4,
			[103] = 5,
			[104] = 6,
			[105] = 8,
			[106] = 11,
			[107] = 12,
			[108] = 14,
			[109] = 15,
			[110] = 4,
			[111] = 4,
			[115] = 112,
			[116] = 112,
			[117] = 112,
			[118] = 112,
			[119] = 112,
			[120] = 112,
			[121] = 112,
			[122] = 113,
			[123] = 113,
			[124] = 113,
			[125] = 113,
			[126] = 113,
			[127] = 113,
			[128] = 113,
			[129] = 114,
			[130] = 114,
			[131] = 114,
			[132] = 114,
			[133] = 114,
			[134] = 114,
			[135] = 114,
			[136] = 15,
			[137] = 15,
			[138] = 0,
			[139] = 1,
			[140] = 2,
			[141] = 4,
			[142] = 5,
			[143] = 6,
			[144] = 8,
			[145] = 11,
			[146] = 12,
			[147] = 14,
			[148] = 112,
			[149] = 113,
			[150] = 114,
			[151] = 0,
			[152] = 1,
			[153] = 2,
			[154] = 4,
			[155] = 5,
			[156] = 6,
			[157] = 8,
			[158] = 11,
			[159] = 12,
			[160] = 14,
			[161] = 112,
			[162] = 113,
			[163] = 114,
			[165] = 4,
			[166] = 4,
			[167] = 4,
			[168] = 4,
			[170] = 15,
			[171] = 0,
			[172] = 1,
			[173] = 2,
			[174] = 4,
			[175] = 5,
			[176] = 6,
			[177] = 8,
			[178] = 11,
			[179] = 12,
			[180] = 14,
			[181] = 112,
			[182] = 113,
			[183] = 114,
			[185] = 184,
			[186] = 184,
			[187] = 184,
			[188] = 184,
			[189] = 185,
			[190] = 184,
			[191] = 184,
			[192] = 184,
			[193] = 184,
			[194] = 184,
		},
		female = {
			[16] = 11,
			[17] = 3,
			[18] = 3,
			[19] = 3,
			[20] = 0,
			[21] = 1,
			[22] = 2,
			[23] = 3,
			[24] = 4,
			[25] = 5,
			[26] = 6,
			[27] = 7,
			[28] = 9,
			[29] = 11,
			[30] = 12,
			[31] = 14,
			[32] = 15,
			[33] = 0,
			[34] = 1,
			[35] = 2,
			[36] = 3,
			[37] = 4,
			[38] = 5,
			[39] = 6,
			[40] = 7,
			[41] = 9,
			[42] = 11,
			[43] = 12,
			[44] = 14,
			[45] = 15,
			[46] = 0,
			[47] = 1,
			[48] = 2,
			[49] = 3,
			[50] = 4,
			[51] = 5,
			[52] = 6,
			[53] = 7,
			[54] = 9,
			[55] = 11,
			[56] = 12,
			[57] = 14,
			[58] = 15,
			[59] = 0,
			[60] = 1,
			[61] = 2,
			[62] = 3,
			[63] = 4,
			[64] = 5,
			[65] = 6,
			[66] = 7,
			[67] = 9,
			[68] = 11,
			[69] = 12,
			[70] = 14,
			[71] = 15,
			[72] = 0,
			[73] = 1,
			[74] = 2,
			[75] = 3,
			[76] = 4,
			[77] = 5,
			[78] = 6,
			[79] = 7,
			[80] = 9,
			[81] = 11,
			[82] = 12,
			[83] = 14,
			[84] = 15,
			[85] = 0,
			[86] = 1,
			[87] = 2,
			[88] = 3,
			[89] = 4,
			[90] = 5,
			[91] = 6,
			[92] = 7,
			[93] = 9,
			[94] = 11,
			[95] = 12,
			[96] = 14,
			[97] = 15,
			[98] = 0,
			[99] = 1,
			[100] = 2,
			[101] = 3,
			[102] = 4,
			[103] = 5,
			[104] = 6,
			[105] = 7,
			[106] = 9,
			[107] = 11,
			[108] = 12,
			[109] = 14,
			[110] = 15,
			[111] = 3,
			[112] = 3,
			[113] = 3,
			[114] = 0,
			[115] = 1,
			[116] = 2,
			[117] = 3,
			[118] = 4,
			[119] = 5,
			[120] = 6,
			[121] = 7,
			[122] = 9,
			[123] = 11,
			[124] = 12,
			[125] = 14,
			[126] = 15,
			[127] = 3,
			[128] = 3,
			[132] = 129,
			[133] = 129,
			[134] = 129,
			[135] = 129,
			[136] = 129,
			[137] = 129,
			[138] = 129,
			[139] = 130,
			[140] = 130,
			[141] = 130,
			[142] = 130,
			[143] = 130,
			[144] = 130,
			[145] = 130,
			[146] = 131,
			[147] = 131,
			[148] = 131,
			[149] = 131,
			[150] = 131,
			[151] = 131,
			[152] = 131,
			[154] = 153,
			[155] = 153,
			[156] = 153,
			[157] = 153,
			[158] = 153,
			[159] = 153,
			[160] = 153,
			[162] = 161,
			[163] = 161,
			[164] = 161,
			[165] = 161,
			[166] = 161,
			[167] = 161,
			[168] = 161,
			[169] = 15,
			[170] = 15,
			[171] = 0,
			[172] = 1,
			[173] = 2,
			[174] = 3,
			[175] = 4,
			[176] = 5,
			[177] = 6,
			[178] = 7,
			[179] = 9,
			[180] = 11,
			[181] = 12,
			[182] = 14,
			[183] = 129,
			[184] = 130,
			[185] = 131,
			[186] = 153,
			[187] = 0,
			[188] = 1,
			[189] = 2,
			[190] = 3,
			[191] = 4,
			[192] = 5,
			[193] = 6,
			[194] = 7,
			[195] = 9,
			[196] = 11,
			[197] = 12,
			[198] = 14,
			[199] = 129,
			[200] = 130,
			[201] = 131,
			[202] = 153,
			[203] = 161,
			[204] = 161,
			[206] = 3,
			[207] = 3,
			[208] = 3,
			[209] = 3,
			[211] = 15,
			[212] = 0,
			[213] = 1,
			[214] = 2,
			[215] = 3,
			[216] = 4,
			[217] = 5,
			[218] = 6,
			[219] = 7,
			[220] = 9,
			[221] = 11,
			[222] = 12,
			[223] = 14,
			[224] = 129,
			[225] = 130,
			[226] = 131,
			[227] = 153,
			[228] = 161,
			[230] = 229,
			[231] = 229,
			[232] = 229,
			[233] = 229,
			[234] = 229,
			[235] = 229,
			[236] = 229,
			[237] = 229,
			[238] = 229,
			[239] = 229,
		}
	}
}

local function addNewVariation(which, gender, one, two, single)
	local where = variations[which][gender]
	if not single then
		where[one] = two
		where[two] = one
	else
		where[one] = two
	end
end

CreateThread(function()
	-- male visor/Hat variations
	addNewVariation("visor", "male", 9, 10)
	addNewVariation("visor", "male", 18, 67)
	addNewVariation("visor", "male", 82, 67)
	addNewVariation("visor", "male", 44, 45)
	addNewVariation("visor", "male", 50, 68)
	addNewVariation("visor", "male", 51, 69)
	addNewVariation("visor", "male", 52, 70)
	addNewVariation("visor", "male", 53, 71)
	addNewVariation("visor", "male", 62, 72)
	addNewVariation("visor", "male", 65, 66)
	addNewVariation("visor", "male", 73, 74)
	addNewVariation("visor", "male", 76, 77)
	addNewVariation("visor", "male", 79, 78)
	addNewVariation("visor", "male", 80, 81)
	addNewVariation("visor", "male", 91, 92)
	addNewVariation("visor", "male", 104, 105)
	addNewVariation("visor", "male", 109, 110)
	addNewVariation("visor", "male", 116, 117)
	addNewVariation("visor", "male", 118, 119)
	addNewVariation("visor", "male", 123, 124)
	addNewVariation("visor", "male", 125, 126)
	addNewVariation("visor", "male", 127, 128)
	addNewVariation("visor", "male", 130, 131)
	addNewVariation("visor", "male", 135, 136)
	addNewVariation("visor", "male", 137, 138)
	addNewVariation("visor", "male", 139, 140)
	addNewVariation("visor", "male", 142, 143)
	addNewVariation("visor", "male", 147, 148)
	addNewVariation("visor", "male", 151, 152)
	addNewVariation("visor", "male", 127, 128)
	addNewVariation("visor", "male", 130, 131)
	-- female visor/Hat variations
	addNewVariation("visor", "female", 43, 44)
	addNewVariation("visor", "female", 49, 67)
	addNewVariation("visor", "female", 64, 65)
	addNewVariation("visor", "female", 65, 64)
	addNewVariation("visor", "female", 51, 69)
	addNewVariation("visor", "female", 50, 68)
	addNewVariation("visor", "female", 52, 70)
	addNewVariation("visor", "female", 62, 71)
	addNewVariation("visor", "female", 72, 73)
	addNewVariation("visor", "female", 75, 76)
	addNewVariation("visor", "female", 78, 77)
	addNewVariation("visor", "female", 79, 80)
	addNewVariation("visor", "female", 18, 66)
	addNewVariation("visor", "female", 66, 81)
	addNewVariation("visor", "female", 81, 66)
	addNewVariation("visor", "female", 86, 84)
	addNewVariation("visor", "female", 90, 91)
	addNewVariation("visor", "female", 103, 104)
	addNewVariation("visor", "female", 108, 109)
	addNewVariation("visor", "female", 115, 116)
	addNewVariation("visor", "female", 117, 118)
	addNewVariation("visor", "female", 122, 123)
	addNewVariation("visor", "female", 124, 125)
	addNewVariation("visor", "female", 126, 127)
	addNewVariation("visor", "female", 129, 130)
	addNewVariation("visor", "female", 134, 135)
	addNewVariation("visor", "female", 136, 137)
	addNewVariation("visor", "female", 138, 139)
	addNewVariation("visor", "female", 141, 142)
	addNewVariation("visor", "female", 146, 147)
	addNewVariation("visor", "female", 150, 151)
	-- male bags
	addNewVariation("bags", "male", 45, 44)
	addNewVariation("bags", "male", 41, 40)
	addNewVariation("bags", "male", 82, 81)
	addNewVariation("bags", "male", 86, 85)
	-- female bags
	addNewVariation("bags", "female", 45, 44)
	addNewVariation("bags", "female", 41, 40)
	addNewVariation("bags", "female", 82, 81)
	addNewVariation("bags", "female", 86, 85)
	-- male hair
	addNewVariation("hair", "male", 7, 15, true)
	addNewVariation("hair", "male", 43, 15, true)
	addNewVariation("hair", "male", 9, 43, true)
	addNewVariation("hair", "male", 11, 43, true)
	addNewVariation("hair", "male", 15, 43, true)
	addNewVariation("hair", "male", 16, 43, true)
	addNewVariation("hair", "male", 17, 43, true)
	addNewVariation("hair", "male", 20, 43, true)
	addNewVariation("hair", "male", 22, 43, true)
	addNewVariation("hair", "male", 45, 43, true)
	addNewVariation("hair", "male", 47, 43, true)
	addNewVariation("hair", "male", 49, 43, true)
	addNewVariation("hair", "male", 51, 43, true)
	addNewVariation("hair", "male", 52, 43, true)
	addNewVariation("hair", "male", 53, 43, true)
	addNewVariation("hair", "male", 56, 43, true)
	addNewVariation("hair", "male", 58, 43, true)
	-- female hair
	addNewVariation("hair", "female", 1, 49, true)
	addNewVariation("hair", "female", 2, 49, true)
	addNewVariation("hair", "female", 7, 49, true)
	addNewVariation("hair", "female", 9, 49, true)
	addNewVariation("hair", "female", 10, 49, true)
	addNewVariation("hair", "female", 11, 48, true)
	addNewVariation("hair", "female", 14, 53, true)
	addNewVariation("hair", "female", 15, 42, true)
	addNewVariation("hair", "female", 21, 42, true)
	addNewVariation("hair", "female", 23, 42, true)
	addNewVariation("hair", "female", 31, 53, true)
	addNewVariation("hair", "female", 39, 49, true)
	addNewVariation("hair", "female", 40, 49, true)
	addNewVariation("hair", "female", 42, 53, true)
	addNewVariation("hair", "female", 45, 49, true)
	addNewVariation("hair", "female", 48, 49, true)
	addNewVariation("hair", "female", 49, 48, true)
	addNewVariation("hair", "female", 52, 53, true)
	addNewVariation("hair", "female", 53, 42, true)
	addNewVariation("hair", "female", 54, 55, true)
	addNewVariation("hair", "female", 59, 42, true)
	addNewVariation("hair", "female", 59, 54, true)
	addNewVariation("hair", "female", 68, 53, true)
	addNewVariation("hair", "female", 76, 48, true)
	-- male Top/Jacket variations
	addNewVariation("jackets", "male", 29, 30)
	addNewVariation("jackets", "male", 31, 32)
	addNewVariation("jackets", "male", 42, 43)
	addNewVariation("jackets", "male", 59, 60)
	addNewVariation("jackets", "male", 68, 69)
	addNewVariation("jackets", "male", 74, 75)
	addNewVariation("jackets", "male", 87, 88)
	addNewVariation("jackets", "male", 93, 94)
	addNewVariation("jackets", "male", 99, 100)
	addNewVariation("jackets", "male", 101, 102)
	addNewVariation("jackets", "male", 103, 104)
	addNewVariation("jackets", "male", 126, 127)
	addNewVariation("jackets", "male", 129, 130)
	addNewVariation("jackets", "male", 131, 132)
	addNewVariation("jackets", "male", 184, 185)
	addNewVariation("jackets", "male", 188, 189)
	addNewVariation("jackets", "male", 194, 195)
	addNewVariation("jackets", "male", 196, 197)
	addNewVariation("jackets", "male", 198, 199)
	addNewVariation("jackets", "male", 200, 203)
	addNewVariation("jackets", "male", 202, 205)
	addNewVariation("jackets", "male", 206, 207)
	addNewVariation("jackets", "male", 209, 212)
	addNewVariation("jackets", "male", 210, 211)
	addNewVariation("jackets", "male", 217, 218)
	addNewVariation("jackets", "male", 229, 230)
	addNewVariation("jackets", "male", 232, 233)
	addNewVariation("jackets", "male", 235, 236)
	addNewVariation("jackets", "male", 241, 242)
	addNewVariation("jackets", "male", 251, 253)
	addNewVariation("jackets", "male", 256, 261)
	addNewVariation("jackets", "male", 262, 263)
	addNewVariation("jackets", "male", 265, 266)
	addNewVariation("jackets", "male", 267, 268)
	addNewVariation("jackets", "male", 279, 280)
	addNewVariation("jackets", "male", 292, 293)
	addNewVariation("jackets", "male", 294, 295)
	addNewVariation("jackets", "male", 296, 297)
	addNewVariation("jackets", "male", 300, 303)
	addNewVariation("jackets", "male", 301, 302)
	addNewVariation("jackets", "male", 305, 306)
	addNewVariation("jackets", "male", 311, 312)
	addNewVariation("jackets", "male", 300, 303)
	addNewVariation("jackets", "male", 301, 302)
	addNewVariation("jackets", "male", 305, 306)
	addNewVariation("jackets", "male", 311, 312)
	addNewVariation("jackets", "male", 314, 315)
	addNewVariation("jackets", "male", 316, 317)
	addNewVariation("jackets", "male", 318, 319)
	addNewVariation("jackets", "male", 321, 322)
	addNewVariation("jackets", "male", 330, 331)
	addNewVariation("jackets", "male", 336, 337)
	addNewVariation("jackets", "male", 339, 126)
	addNewVariation("jackets", "male", 340, 341)
	addNewVariation("jackets", "male", 343, 344)
	addNewVariation("jackets", "male", 346, 234)
	addNewVariation("jackets", "male", 347, 260)
	addNewVariation("jackets", "male", 348, 349)
	addNewVariation("jackets", "male", 352, 353)
	addNewVariation("jackets", "male", 354, 355)
	addNewVariation("jackets", "male", 359, 360)
	-- female Top/Jacket variations
	addNewVariation("jackets", "female", 53, 52)
	addNewVariation("jackets", "female", 57, 58)
	addNewVariation("jackets", "female", 62, 63)
	addNewVariation("jackets", "female", 84, 85)
	addNewVariation("jackets", "female", 90, 91)
	addNewVariation("jackets", "female", 92, 93)
	addNewVariation("jackets", "female", 94, 95)
	addNewVariation("jackets", "female", 117, 118)
	addNewVariation("jackets", "female", 120, 121)
	addNewVariation("jackets", "female", 128, 129)
	addNewVariation("jackets", "female", 187, 186)
	addNewVariation("jackets", "female", 190, 191)
	addNewVariation("jackets", "female", 196, 197)
	addNewVariation("jackets", "female", 198, 199)
	addNewVariation("jackets", "female", 200, 201)
	addNewVariation("jackets", "female", 202, 205)
	addNewVariation("jackets", "female", 204, 207)
	addNewVariation("jackets", "female", 210, 211)
	addNewVariation("jackets", "female", 213, 216)
	addNewVariation("jackets", "female", 214, 215)
	addNewVariation("jackets", "female", 225, 226)
	addNewVariation("jackets", "female", 227, 228)
	addNewVariation("jackets", "female", 239, 240)
	addNewVariation("jackets", "female", 242, 243)
	addNewVariation("jackets", "female", 244, 364)
	addNewVariation("jackets", "female", 245, 246)
	addNewVariation("jackets", "female", 249, 250)
	addNewVariation("jackets", "female", 259, 261)
	addNewVariation("jackets", "female", 265, 270)
	addNewVariation("jackets", "female", 271, 272)
	addNewVariation("jackets", "female", 274, 275)
	addNewVariation("jackets", "female", 276, 277)
	addNewVariation("jackets", "female", 280, 281)
	addNewVariation("jackets", "female", 292, 293)
	addNewVariation("jackets", "female", 305, 306)
	addNewVariation("jackets", "female", 307, 308)
	addNewVariation("jackets", "female", 311, 314)
	addNewVariation("jackets", "female", 312, 313)
	addNewVariation("jackets", "female", 316, 317)
	addNewVariation("jackets", "female", 325, 326)
	addNewVariation("jackets", "female", 327, 328)
	addNewVariation("jackets", "female", 329, 330)
	addNewVariation("jackets", "female", 332, 333)
	addNewVariation("jackets", "female", 339, 340)
	addNewVariation("jackets", "female", 345, 346)
	addNewVariation("jackets", "female", 351, 352)
	addNewVariation("jackets", "female", 354, 121)
	addNewVariation("jackets", "female", 355, 356)
	addNewVariation("jackets", "female", 357, 359)
	addNewVariation("jackets", "female", 358, 360)
	addNewVariation("jackets", "female", 362, 363)
	addNewVariation("jackets", "female", 366, 367)
	addNewVariation("jackets", "female", 365, 269)
	addNewVariation("jackets", "female", 370, 371)
	addNewVariation("jackets", "female", 372, 373)
	addNewVariation("jackets", "female", 378, 379)
end)

local drawables = {
	["Top"] = {
		Drawable = 11,
		Table = variations.jackets,
		Emote = {Dict = "missmic4", Anim = "michael_tux_fidget", Move = 51, Dur = 1500}
	},
	["gloves"] = {
		Drawable = 3,
		Table = variations.gloves,
		Remember = true,
		Emote = {Dict = "nmt_3_rcm-10", Anim = "cs_nigel_dual-10", Move = 51, Dur = 1200}
	},
	["Shoes"] = {
		Drawable = 6,
		Table = {Standalone = true, male = 34, female = 35},
		Emote = {Dict = "random@domestic", Anim = "pickup_low", Move = 0, Dur = 1200}
	},
	["Neck"] = {
		Drawable = 7,
		Table = {Standalone = true, male = 0, female = 0 },
		Emote = {Dict = "clothingtie", Anim = "try_tie_positive_a", Move = 51, Dur = 2100}
	},
	["Vest"] = {
		Drawable = 9,
		Table = {Standalone = true, male = 0, female = 0 },
		Emote = {Dict = "clothingtie", Anim = "try_tie_negative_a", Move = 51, Dur = 1200}
	},
	["Bag"] = {
		Drawable = 5,
		Table = variations.bags,
		Emote = {Dict = "anim@heists@ornate_bank@grab_cash", Anim = "intro", Move = 51, Dur = 1600}
	},
	["Mask"] = {
		Drawable = 1,
		Table = {Standalone = true, male = 0, female = 0 },
		Emote = {Dict = "mp_masks@standard_car@ds@", Anim = "put_on_mask", Move = 51, Dur = 800}
	},
	["hair"] = {
		Drawable = 2,
		Table = variations.hair,
		Remember = true,
		Emote = {Dict = "clothingtie", Anim = "check_out_a", Move = 51, Dur = 2000}
	},
}

local Extras = {
	["Shirt"] = {
		Drawable = 11,
		Table = {
			Standalone = true, male = 252, female = 15,
			Extra = {
				{Drawable = 8, Id = 15, Tex = 0, Name = "Extra Undershirt"},
				{Drawable = 3, Id = 15, Tex = 0, Name = "Extra Gloves"},
				{Drawable = 10, Id = 0, Tex = 0, Name = "Extra Decals"},
				}
			},
		Emote = {Dict = "clothingtie", Anim = "try_tie_negative_a", Move = 51, Dur = 1200}
	},
	["Pants"] = {
		Drawable = 4,
		Table = {Standalone = true, male = 61, female = 15},
		Emote = {Dict = "re@construction", Anim = "out_of_breath", Move = 51, Dur = 1300}
	},
	["Bagoff"] = {
		Drawable = 5,
		Table = {Standalone = true, male = 0, female = 0},
		Emote = {Dict = "clothingtie", Anim = "try_tie_negative_a", Move = 51, Dur = 1200}
	},
}

local Props = {
	["visor"] = {
		Prop = 0,
		Variants = variations.visor,
		Emote = {
			On = {Dict = "mp_masks@standard_car@ds@", Anim = "put_on_mask", Move = 51, Dur = 600},
			Off = {Dict = "missheist_agency2ahelmet", Anim = "take_off_helmet_stand", Move = 51, Dur = 1200}
		}
	},
	["Hat"] = {
		Prop = 0,
		Emote = {
			On = {Dict = "mp_masks@standard_car@ds@", Anim = "put_on_mask", Move = 51, Dur = 600},
			Off = {Dict = "missheist_agency2ahelmet", Anim = "take_off_helmet_stand", Move = 51, Dur = 1200}
		}
	},
	["Glasses"] = {
		Prop = 1,
		Emote = {
			On = {Dict = "clothingspecs", Anim = "take_off", Move = 51, Dur = 1400},
			Off = {Dict = "clothingspecs", Anim = "take_off", Move = 51, Dur = 1400}
		}
	},
	["Ear"] = {
		Prop = 2,
		Emote = {
			On = {Dict = "mp_cp_stolen_tut", Anim = "b_think", Move = 51, Dur = 900},
			Off = {Dict = "mp_cp_stolen_tut", Anim = "b_think", Move = 51, Dur = 900}
		}
	},
	["Watch"] = {
		Prop = 6,
		Emote = {
			On = {Dict = "nmt_3_rcm-10", Anim = "cs_nigel_dual-10", Move = 51, Dur = 1200},
			Off = {Dict = "nmt_3_rcm-10", Anim = "cs_nigel_dual-10", Move = 51, Dur = 1200}
		}
	},
	["Bracelet"] = {
		Prop = 7,
		Emote = {
			On = {Dict = "nmt_3_rcm-10", Anim = "cs_nigel_dual-10", Move = 51, Dur = 1200},
			Off = {Dict = "nmt_3_rcm-10", Anim = "cs_nigel_dual-10", Move = 51, Dur = 1200}
		}
	},
}

LastEquipped = {}
Cooldown = false

local function PlayToggleEmote(e, cb)
	local Ped = PlayerPedId()
	while not HasAnimDictLoaded(e.Dict) do RequestAnimDict(e.Dict) Wait(100) end
	if IsPedInAnyVehicle(Ped) then e.Move = 51 end
	TaskPlayAnim(Ped, e.Dict, e.Anim, 3.0, 3.0, e.Dur, e.Move, 0, false, false, false)
	local Pause = e.Dur-500 if Pause < 500 then Pause = 500 end
	IncurCooldown(Pause)
	Wait(Pause)
	cb()
end

function ResetClothing(anim)
	if type(anim) == "table" then
		anim = true
	end
	local Ped = PlayerPedId()
	local e = drawables.Top.Emote
	if anim then TaskPlayAnim(Ped, e.Dict, e.Anim, 3.0, 3.0, 3000, e.Move, 0, false, false, false) end
	for _, v in pairs(LastEquipped) do
		if v then
			if v.Drawable then SetPedComponentVariation(Ped, v.Id, v.Drawable, v.Texture, 0)
			elseif v.Prop then ClearPedProp(Ped, v.Id) SetPedPropIndex(Ped, v.Id, v.Prop, v.Texture, true) end
		end
	end
	LastEquipped = {}
end

RegisterNetEvent('pd-clothing:ResetClothing', ResetClothing)

function ToggleClothing(whic, extra)
	local which = whic
	if type(whic) == "table" then
		which = tostring(whic.id)
	end
	Wait(50)

    if which == "Shirt" or which == "Pants" or which == "Bagoff" then
        extra = true
    end
	if Cooldown then return end
	local Toggle = drawables[which] if extra then Toggle = Extras[which] end
	local Ped = PlayerPedId()
	local Cur = {
		Drawable = GetPedDrawableVariation(Ped, Toggle.Drawable),
		Id = Toggle.Drawable,
		Ped = Ped,
		Texture = GetPedTextureVariation(Ped, Toggle.Drawable),
	}
	local Gender = IsMpPed(Ped)
	if which ~= "Mask" then
		if not Gender then Notify(Locales['wrong_ped']) return false end 
	local Table = Toggle.Table[Gender]
	if not Toggle.Table.Standalone then
		for k,v in pairs(Table) do
			if not Toggle.Remember then
				if k == Cur.Drawable then
					PlayToggleEmote(Toggle.Emote, function() SetPedComponentVariation(Ped, Toggle.Drawable, v, Cur.Texture, 0) end) return true
				end
			else
				if not LastEquipped[which] then
					if k == Cur.Drawable then
						PlayToggleEmote(Toggle.Emote, function() LastEquipped[which] = Cur SetPedComponentVariation(Ped, Toggle.Drawable, v, Cur.Texture, 0) end) return true
					end
				else
					local Last = LastEquipped[which]
					PlayToggleEmote(Toggle.Emote, function() SetPedComponentVariation(Ped, Toggle.Drawable, Last.Drawable, Last.Texture, 0) LastEquipped[which] = false end) return true
				end
			end
		end
		Notify(Locales['no_variants']) return
	else
		if not LastEquipped[which] then
			if Cur.Drawable ~= Table then
				PlayToggleEmote(Toggle.Emote, function()
					LastEquipped[which] = Cur
					SetPedComponentVariation(Ped, Toggle.Drawable, Table, 0, 0)
					if Toggle.Table.Extra then
						local extraToggled = Toggle.Table.Extra
						for _, v in pairs(extraToggled) do
							local ExtraCur = {Drawable = GetPedDrawableVariation(Ped, v.Drawable),  Texture = GetPedTextureVariation(Ped, v.Drawable), Id = v.Drawable}
							SetPedComponentVariation(Ped, v.Drawable, v.Id, v.Tex, 0)
							LastEquipped[v.Name] = ExtraCur
						end
					end
				end)
				return true
			end
		else
			local Last = LastEquipped[which]
			PlayToggleEmote(Toggle.Emote, function()
				SetPedComponentVariation(Ped, Toggle.Drawable, Last.Drawable, Last.Texture, 0)
				LastEquipped[which] = false
				if Toggle.Table.Extra then
					local extraToggled = Toggle.Table.Extra
					for _, v in pairs(extraToggled) do
						if LastEquipped[v.Name] then
							Last = LastEquipped[v.Name]
							SetPedComponentVariation(Ped, Last.Id, Last.Drawable, Last.Texture, 0)
							LastEquipped[v.Name] = false
						end
					end
				end
			end)
			return true
		end
	end
	Notify(Locales['already_wearing']) return false
end

end

RegisterNetEvent('pd-clothing:ToggleClothing', ToggleClothing)

function ToggleProps(whic)
	local which = whic
	if type(whic) == "table" then
		which = tostring(whic.id)
	end
	Wait(50)

	if Cooldown then return end
	local Prop = Props[which]
	local Ped = PlayerPedId()
	local Cur = {
		Id = Prop.Prop,
		Ped = Ped,
		Prop = GetPedPropIndex(Ped, Prop.Prop),
		Texture = GetPedPropTextureIndex(Ped, Prop.Prop),
	}
	if not Prop.Variants then
		if Cur.Prop ~= -1 then 
			PlayToggleEmote(Prop.Emote.Off, function() LastEquipped[which] = Cur ClearPedProp(Ped, Prop.Prop) end) return true
		else
			local Last = LastEquipped[which]
			if Last then
				PlayToggleEmote(Prop.Emote.On, function() SetPedPropIndex(Ped, Prop.Prop, Last.Prop, Last.Texture, true) end) LastEquipped[which] = false return true
			end
		end
		Notify(Locales['nothing_to_remove']) return false
	else
		local Gender = IsMpPed(Ped)
		if not Gender then Notify(Locales['wrong_ped']) return false end
		variations = Prop.Variants[Gender]
		for k,v in pairs(variations) do
			if Cur.Prop == k then
				PlayToggleEmote(Prop.Emote.On, function() SetPedPropIndex(Ped, Prop.Prop, v, Cur.Texture, true) end) return true
			end
		end
		Notify(Locales['no_variants']) return false
	end
end

RegisterNetEvent('pd-clothing:ToggleProps', ToggleProps)

CreateThread(function()
	Wait(100)
	
	for k,v in pairs(Config.Commands) do
		RegisterCommand(k, v.Func)
		--log("Created /"..k.." ("..v.Desc..")") -- Useful for translation checking.
	end

	if Config.ExtrasEnabled then
		for k,v in pairs(Config.ExtraCommands) do
			RegisterCommand(k, v.Func)
			--log("Created /"..k.." ("..v.Desc..")") -- Useful for translation checking.
		end
	end
end)

AddEventHandler('onResourceStop', function(resource) 
	if resource == GetCurrentResourceName() then
		ResetClothing()
	end
end)

function IncurCooldown(ms)
	CreateThread(function()
		Cooldown = true Wait(ms) Cooldown = false
	end)
end

function Notify(message)
	lib.notify({
		title = Locales and Locales['clothing_title'] or 'Clothing System',
		description = message,
		type = 'inform'
	})
end

function IsMpPed(ped)
	local male = `mp_m_freemode_01` local female = `mp_f_freemode_01`
	local CurrentModel = GetEntityModel(ped)
	if CurrentModel == male then return "male" elseif CurrentModel == female then return "female" else return false end
end

RegisterNetEvent('dpc:EquipLast', function()
	local Ped = PlayerPedId()
	for _, v in pairs(LastEquipped) do
		if v then
			if v.Drawable then SetPedComponentVariation(Ped, v.ID, v.Drawable, v.Texture, 0)
			elseif v.Prop then ClearPedProp(Ped, v.ID) SetPedPropIndex(Ped, v.ID, v.Prop, v.Texture, true) end
		end
	end
	LastEquipped = {}
end)

RegisterNetEvent('dpc:ResetClothing', function()
	LastEquipped = {}
end)
