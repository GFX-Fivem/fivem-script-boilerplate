Config = {}

Citizen.CreateThread(function()
  SendReactMessage('setConfig', Config)
end)
