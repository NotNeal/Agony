local item_OvergrownSpine = Isaac.GetItemIdByName("Overgrown Spine");
local overgrownSpine =  {
	hasItem = nil, --used for costume
	costumeID = nil
}
overgrownSpine.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_overgrownspine.anm2")

function overgrownSpine:linkTears()
	local player = Game():GetPlayer(0)
	if player:HasCollectible(item_OvergrownSpine) then
		local entList = Isaac.GetRoomEntities()
		local tearList = {}
		for i = 1, #entList, 1 do
			if entList[i].Type == EntityType.ENTITY_TEAR then
				table.insert(tearList,entList[i].Position)
			end
		end
		for j = 1, #tearList-1, 1 do
			if math.random(4) == 1 then
				local laser = player:FireTechLaser(tearList[j], 1, Vector (tearList[j+1].X-tearList[j].X,tearList[j+1].Y-tearList[j].Y), false, false)
				laser:SetMaxDistance(tearList[j+1]:Distance(tearList[j]))
				laser:SetTimeout(1)
				--laser:SetColor(Color(0, 0, 0, 10, 0, 0, 0), 2, 1, false, false)
			end
		end
	end
end


function overgrownSpine:onUpdate(player)
	if Game():GetFrameCount() == 1 then
		overgrownSpine.hasItem = false
	end
	if overgrownSpine.hasItem == false and player:HasCollectible(item_OvergrownSpine) then
		--player:AddNullCostume(overgrownSpine.costumeID)
		overgrownSpine.hasItem = true
	end
end
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, overgrownSpine.onUpdate)
Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, overgrownSpine.linkTears)