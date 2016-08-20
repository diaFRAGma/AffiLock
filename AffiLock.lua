function AffiLock()
	local manaNeed = 0
	local cast = ""
		
	-- Wenn man etwas im Target hat wird dieses versucht anzugreifen.
	if UnitName("target") ~= nil then
		if not IsBuffActive("Dämonenrüstung") then
			cast = "Dämonenrüstung"
			manaNeed = 1150
		elseif not IsBuffActive("Lebensentzug", "target") then
			cast = "Lebensentzug"
			manaNeed = 285
		elseif UnitHealthMax("player") - UnitHealth("player") > 330 then
			cast = "Blutsauger"
			manaNeed = 240
		elseif UnitHealth("pet") < 500 and UnitHealth("player") > 375 then
			cast = "Lebenslinie"
			manaNeed = 0
		elseif not IsBuffActive("Fluch der Pein", "target") then
			if getCooldown("Fluch verstärken") == 0 then
				CastSpellByName("Fluch verstärken")
			end
			cast = "Fluch der Pein"
			manaNeed = 170
		elseif not IsBuffActive("Verderbnis", "target") then
			cast = "Verderbnis"
			manaNeed = 225
		elseif not IsBuffActive("Feuerbrand", "target") then
			cast = "Feuerbrand"
			manaNeed = 289
		else
			cast = "Schattenblitz"
			manaNeed = 259
		end
	
		-- todo todesmantel

		-- Aderlass wenn zu wennig Mana da ist um den nächsten Cast zu machen aber nur wenn man auch genug Leben hat.
		if UnitHealth("player") > 330 and UnitMana("player") < manaNeed then
			CastSpellByName("Aderlass")
		elseif UnitHealthMax("player") == UnitHealth("player") and UnitManaMax("player") - UnitMana("player") >= 396 then
			-- Aderlass wenn Leben voll aber Mana nicht.
			CastSpellByName("Aderlass")
		end

		PetAttack()
		CastSpellByName(cast)
	else
		-- Wenn man nichts im Target hat, dann wird Dämonenrüstung gebufft und das Pet Geheilt und Adergelassen.
		if not IsBuffActive("Dämonenrüstung") then
			cast = "Dämonenrüstung"
		elseif UnitHealthMax("pet") - UnitHealth("pet") > 890 and UnitHealth("player") > 375 then
			cast = "Lebenslinie"
		end
		-- Aderlass wenn Leben voll aber Mana nicht.
		if UnitHealthMax("player") == UnitHealth("player") and UnitManaMax("player") - UnitMana("player") >= 396 then
			CastSpellByName("Aderlass")
		end
		CastSpellByName(cast)
	end
end

function getCooldown(pSpell)
	local i = 1
	while true do
		local spellName, spellRank = GetSpellName(i, BOOKTYPE_SPELL)
		if not spellName then
			do break end
		end
		if spellName == pSpell then
			local start, duration, enabled = GetSpellCooldown(i, BOOKTYPE_SPELL)
			if enabled == 0 then
				-- Der Zauber ist gerade aktiv. Der CD startet erst wenn er verbraucht wurde.
				return -1
			elseif ( start > 0 and duration > 0) then
				-- Der Zauber hat CD.
				return start + duration - GetTime()
			else
				-- Der Zauber hat keinen CD und kann genutzt werden.
				return 0
			end
		end
		i = i + 1
	end
end