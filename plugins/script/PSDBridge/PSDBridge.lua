local Helpers = {
  rikkyModule = require("rikky_module")
}

function Helpers:getCurrentAupFolderPath()
  local aup_file_path = self.rikkyModule.getinfo("aup")
  local aup_filename = self.rikkyModule.getinfo("aup",1)
  -- return string.gsub(aup_file_path, "("..aup_filename.."%.aup)$", "")
  return aup_file_path:sub(0, #aup_file_path - string.len(aup_filename..".aup"))
end

-- 拡張ファイルパス
local FilePathEx = {}

function FilePathEx.new(file_path, old_base_folder_path)
  local self = setmetatable({
    file_path = file_path,
    old_base_folder_path = old_base_folder_path
  },{__index = FilePathEx})

  return self
end

function FilePathEx:changeBaseFolderPath(new_base_folder_path)
  return self.new(
    string.gsub(self.file_path, "^" .. self.old_base_folder_path, new_base_folder_path),
    new_base_folder_path
  )
end

function FilePathEx:getFilePath()
  return self.file_path
end

function FilePathEx:clone()
  return self.new(self.file_path ,self.old_base_folder_path)
end

-- PSDの情報を入れる箱
local PSDBox = {}

function PSDBox.new(id, ptkf, tag)
  local self = setmetatable({
    id = id,
    ptkf = ptkf,
    tag = tag,
  },{__index = PSDBox})

  return self
end

function PSDBox:getPtkf()
  local currentAupFolderPath = Helpers:getCurrentAupFolderPath()
  return self.ptkf:changeBaseFolderPath(currentAupFolderPath):getFilePath()
end

function PSDBox:getTag()
  return self.tag
end

function PSDBox:alterId(new_id)
  return self.new(new_id, self.ptkf:clone(), self.tag)
end

-- 空箱（PSDの情報を入れる箱）
local PSDBoxEmpty = {}

function PSDBoxEmpty.new()
  local self = setmetatable({
    id = 0,
    ptkf = FilePathEx.new("", ""),
    tag = 0,
  }, {__index = PSDBoxEmpty})

  return self
end

function PSDBoxEmpty:getPtkf()
  return ""
end

function PSDBoxEmpty:getTag()
  return 0
end

function PSDBoxEmpty:alterId(new_id)
  return self.new(new_id, self.ptkf:clone(), self.tag)
end

-- PSDの情報を受け渡しする橋
local PSDBridge = {}

-- PSDBoxListの初期化
function PSDBridge.PSDBoxListInit()
  return setmetatable({}, {
    __index = function()
      return PSDBoxEmpty.new()
    end
  })
end

function PSDBridge:addPSDBox(params)
  local ptkf = FilePathEx.new(params.ptkf, params.old_aup_folder_path)
  self.PSDBoxList[params.id] = PSDBox.new(params.id, ptkf, params.tag)
end

function PSDBridge:removePSDBoxById(id)
  self.PSDBoxList[id] = nil
end

function PSDBridge:findPSDBoxById(id)
  return self.PSDBoxList[id]
end

function PSDBridge:copyIdToId(from_id, to_id)
  if from_id ~= nil and to_id ~= nil then
    self.PSDBoxList[to_id] = self:findPSDBoxById(from_id):alterId(to_id)
  end
end

function PSDBridge:init()
  self.PSDBoxList = self.PSDBoxListInit()
end

PSDBridge:init()

PSDBridge.Helpers = Helpers
return PSDBridge