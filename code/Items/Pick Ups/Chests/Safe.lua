--This chest is spawned when an item is stored in the Safe Space collectible

safe = {}

function safe:onUpdate()
  local ents = Isaac.GetRoomEntities()
  local player = Isaac.GetPlayer(0)
  local sound = SFXManager()

  if Game():GetFrameCount() == 2 then
    if saveData.safeSpace.storedItem ~= nil and saveData.safeSpace.storedItem ~= 0 then
      Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.AGONY_PICKUP_SAFE, ChestSubType.CHEST_CLOSED, Isaac.GetFreeNearPosition(player.Position, 50), Vector (0,0), player)
    end
  end


  for _,entity in pairs(ents) do
    if entity.Type == EntityType.ENTITY_PICKUP 
    and entity.Variant == PickupVariant.AGONY_PICKUP_SAFE then
      local entsprite = entity:GetSprite()
      if entity.SubType == ChestSubType.CHEST_CLOSED then 
        local entdata = entity:GetData()
        if entdata.storedItem == nil then
          entdata.storedItem = saveData.safeSpace.storedItem
        end
        if player.Position:Distance(entity.Position) <= player.Size + entity.Size + 8
          and entity.SubType ~= ChestSubType.CHEST_OPENED then
          entsprite:Play("Open", true)
          sound:Play(SoundEffect.SOUND_PLOP, 1, 0, false, 1)
          --spawn item
          Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, entdata.storedItem , Isaac.GetFreeNearPosition(player.Position, 50), Vector (0,0), player)
          saveData.safeSpace.storedItem = 0
          entity.SubType = ChestSubType.CHEST_OPENED
          Agony:SaveNow()
        end
      elseif entity.SubType == ChestSubType.CHEST_OPENED then
        if not entsprite:IsPlaying("Open") and not entsprite:IsPlaying("Opened") then
          entsprite:Play("Opened", true)
        end
      end
    end
  end
end

Agony:AddCallback(ModCallbacks.MC_POST_UPDATE, safe.onUpdate)