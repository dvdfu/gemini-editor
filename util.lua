local Util = {}

function Util.clamp(x, l, u)
    if x < l then return l end
    if x > u then return u end
    return x
end

return Util
