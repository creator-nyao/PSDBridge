local Helpers = {
  rikkyModule = require("rikky_module")
}

function Helpers:getCurrentAupFolderPath()
  local aup_file_path = self.rikkyModule.getinfo("aup")
  local aup_filename = self.rikkyModule.getinfo("aup",1)
  return string.gsub(aup_file_path, "("..aup_filename.."%.aup)$", "")
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

-- PSDの情報を入れる箱
local PSDBox = {}

function PSDBox.new(params)
  local self = setmetatable({
    id = params.id,
    ptkf = FilePathEx.new(params.ptkf, params.old_aup_folder_path),
    tag = params.tag,
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

-- 空箱（PSDの情報を入れる箱）
local PSDBoxEmpty = {}

function PSDBoxEmpty.new()
  local self = setmetatable({
    id = 0,
    ptkf = "",
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
  self.PSDBoxList[params.id] = PSDBox.new({
    id=params.id,
    ptkf=params.ptkf,
    old_aup_folder_path = params.old_aup_folder_path,
    tag=params.tag,
    obj=params.obj,
  })
end

function PSDBridge:removePSDBox(id)
  self.PSDBoxList[id] = nil
end

function PSDBridge:findPSDBoxById(id)
  return self.PSDBoxList[id]
end

-- 作成途中で気力がお亡くなりに
-- function PSDBridge:copyIdToId(fromId, toId)
  
-- end

function PSDBridge:init()
  self.PSDBoxList = self.PSDBoxListInit()
end

PSDBridge:init()

PSDBridge.Helpers = Helpers
return PSDBridge