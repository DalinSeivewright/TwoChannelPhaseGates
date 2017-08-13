-- Code from Nin to append to Enums.  There are other potentially safer ways to do
-- this but until we run into trouble, this will be great!
local function AppendToEnum( tbl, key )
	if rawget(tbl,key) ~= nil then
		return
	end

	local maxVal = 0
    for k, v in next, tbl do
        if type(v) == "number" and v > maxVal then
            maxVal = v
        end
    end

	rawset( tbl, key, maxVal+1 )
	rawset( tbl, maxVal+1, key )

end


-- Increase Max Tech Id and add our new Tech Ids
kTechIdMax = kTechIdMax + 2
AppendToEnum(kTechId, "PhaseChannelA")
AppendToEnum(kTechId, "PhaseChannelB")
