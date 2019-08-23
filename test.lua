json = require "/libs/json"

config = nil
isOk, err = pcall(function()
    config = json.decode('{"toMining":24,"minY":11,"toDigdown":45,"miningY":35,"groundY":56}')
end)
print(err)
if isOk then
    print("OK")
else
    print("Error")
end
print(tostring(config))