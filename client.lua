local me = PlayerPedId()

Citizen.CreateThread(function()
  while true do
    me = PlayerPedId()
    Wait(10000)
  end
end)

Citizen.CreateThread(function()
  local jacking = false
  local ResetRelation = false
  while true do
      if IsControlJustPressed(0,`INPUT_ENTER`) then
        Citizen.CreateThread(function()
          local timer = GetGameTimer()
          jacking = true
          while GetGameTimer() < timer + 2500 do
            if not Config.CanStealToPlayer then
              SetRelationshipBetweenGroups(1, `PLAYER`, `PLAYER`)
            end
            Wait(0)
          end
          jacking = false
          ResetRelation = false
        end)
        while GetSeatPedIsTryingToEnter(me) == -3 and jacking do
          Wait(10)
        end
        local user = GetJackTarget(me)
        if user ~= 0 then
          if not IsPedAPlayer(user) and not Config.CanStealToNPC then 
            ClearPedTasks(me)
            ClearPedSecondaryTask(me)
          end
        else
          Wait(1000)
          local veh = GetVehiclePedIsUsing(me)
          while IsPedInAnyVehicle(me, true) do
            CanShuffleSeat(veh,false)
            Wait(0)
          end
        end
      end
      if IsPedInAnyVehicle(me, true) then
        local veh = GetVehiclePedIsUsing(me)
        CanShuffleSeat(veh,false)
      end
      if not jacking and not IsPedOnMount(me) and not ResetRelation and not IsPedInAnyVehicle(me, true) then
        SetRelationshipBetweenGroups(5, `PLAYER`, `PLAYER`)
        ResetRelation = true
      end
      Wait(0)
  end
end)