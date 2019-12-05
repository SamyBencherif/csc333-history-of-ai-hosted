local gameio = {}

function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

-- get all lines from a file, returns an empty 
-- list/table if the file does not exist
gameio.readLines = function(file)
  if not file_exists(file) then
    print("File not found")
    return {} 
  end
  lines = {}
  for line in io.lines(file) do 
    lines[#lines + 1] = line
  end

  return lines
end

return gameio