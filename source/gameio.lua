local gameio = {}

function file_exists(file)
  local f = love.filesystem.getInfo(file)
  return f.size ~= nil
end

-- get all lines from a file, returns an empty 
-- list/table if the file does not exist
gameio.readLines = function(file)
  if not file_exists(file) then
    print("File not found")
    return {} 
  end
  lines = {}
  for line in love.filesystem.lines(file, "rb") do 
    lines[#lines + 1] = line
  end

  return lines
end

return gameio