--local item_SolomonCrown = Isaac.GetItemIdByName("Solomon's Crown");
local solomonCrown =  {
	hasItem = nil, --used for costume
	costumeID = nil,
	TearBool = false
}
solomonCrown.costumeID = Isaac.GetCostumeIdByPath("gfx/characters/costume_solomonscrown.anm2")

function solomonCrown:cacheUpdate (player,cacheFlag)
	if (player:HasCollectible(CollectibleType.AGONY_C_SOLOMON_CROWN)) and player:GetHearts() == player:GetMaxHearts()/2 then
		if (cacheFlag == CacheFlag.CACHE_LUCK) then
			player.Luck = (player.Luck + 2)*player:GetCollectibleNum(CollectibleType.AGONY_C_SOLOMON_CROWN);
		end
		if (cacheFlag == CacheFlag.CACHE_DAMAGE) then
			player.Damage = (player.Damage + 1.2)*player:GetCollectibleNum(CollectibleType.AGONY_C_SOLOMON_CROWN);
		end
		if (cacheFlag == CacheFlag.CACHE_SPEED) then
			player.MoveSpeed = (player.MoveSpeed + 0.3)*player:GetCollectibleNum(CollectibleType.AGONY_C_SOLOMON_CROWN);
		end
		if (cacheFlag == CacheFlag.CACHE_FIREDELAY) then
			TearBool = true
		end
	end
end

function solomonCrown:onPlayerUpdate(player)
	if Game():GetFrameCount() == 1 then
		solomonCrown.hasItem = false
	end
	if solomonCrown.hasItem == false and player:HasCollectible(CollectibleType.AGONY_C_SOLOMON_CROWN) then
		player:AddNullCostume(solomonCrown.costumeID)
		solomonCrown.hasItem = true
	end
end

--FireDelay workaround
function solomonCrown:updateFireDelay(player)
	if (solomonCrown.TearBool == true) then
		player.MaxFireDelay = player.MaxFireDelay - 2*player:GetCollectibleNum(CollectibleType.AGONY_C_SOLOMON_CROWN)
		solomonCrown.TearBool = false;
	end
end

function solomonCrown:evaluateCache(player)
	if player:HasCollectible(CollectibleType.AGONY_C_SOLOMON_CROWN) then
		player:AddCacheFlags(CacheFlag.CACHE_SPEED)
		player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
		player:AddCacheFlags(CacheFlag.CACHE_LUCK)
		player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
		player:EvaluateItems()
	end
end

Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, solomonCrown.evaluateCache)
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, solomonCrown.updateFireDelay)
Agony:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, solomonCrown.onPlayerUpdate)
Agony:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, solomonCrown.cacheUpdate)