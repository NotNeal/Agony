--local item_Hyperactive = Isaac.GetItemIdByName("Hyperactive")
local hyperactive =  {
	hasItem = false,
	costumeID = nil,
	TearBool = false
}
hyperactive.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_hyperactive.anm2")

function hyperactive:autoUseItem(player)
	if player:HasCollectible(CollectibleType.AGONY_C_HYPERACTIVE) then
		if not player:NeedsCharge() then
			-- scales with nbr of copies
			for i = 1, player:GetCollectibleNum(CollectibleType.AGONY_C_HYPERACTIVE) do
				player:UseActiveItem(player:GetActiveItem(), true, true, true, false)
			end
			player:DischargeActiveItem()
		end
	end
end

function hyperactive:cacheUpdate (player,cacheFlag)
	if (player:HasCollectible(CollectibleType.AGONY_C_HYPERACTIVE)) then 
		if (cacheFlag == CacheFlag.CACHE_SPEED) then
			player.MoveSpeed = (player.MoveSpeed +0.5*player:GetCollectibleNum(CollectibleType.AGONY_C_HYPERACTIVE))
		elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
			hyperactive.TearBool = true
		end
	end
end

function hyperactive:onPlayerUpdate(player)
	if Game():GetFrameCount() == 1 then
		hyperactive.hasItem = false
	end
	if hyperactive.hasItem == false and player:HasCollectible(CollectibleType.AGONY_C_HYPERACTIVE) then
		--player:AddNullCostume(hyperactive.costumeID)
		hyperactive.hasItem = true
	end
end

--FireDelay workaround
function hyperactive:updateFireDelay(player)
	if (hyperactive.TearBool == true) then
		player.MaxFireDelay = player.MaxFireDelay - 5*player:GetCollectibleNum(CollectibleType.AGONY_C_HYPERACTIVE)
		hyperactive.TearBool = false;
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, hyperactive.updateFireDelay)
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, hyperactive.onPlayerUpdate)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, hyperactive.cacheUpdate)
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, hyperactive.autoUseItem)