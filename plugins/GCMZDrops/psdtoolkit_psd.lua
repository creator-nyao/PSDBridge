local P = {}

P.name = "PSD ファイルの exo 化"

P.priority = 0

function P.ondragenter(files, state)
  for i, v in ipairs(files) do
    if v.filepath:match("[^.]+$"):lower() == "psd" then
      -- ファイルの拡張子が psd のファイルがあったら処理できそうなので true
      return true
    end
  end
  return false
end

function P.ondragover(files, state)
  -- ondragenter で処理できそうなものは ondragover でも処理できそうなので調べず true
  return true
end

function P.ondragleave()
end

function P.encodelua(s)
  s = GCMZDrops.convertencoding(s, "sjis", "utf8")
  s = GCMZDrops.encodeluastring(s)
  s = GCMZDrops.convertencoding(s, "utf8", "sjis")
  return s
end

function P.ondrop(files, state)
  for i, v in ipairs(files) do
    -- ファイルの拡張子が psd だったら
    if v.filepath:match("[^.]+$"):lower() == "psd" then
      local filepath = v.filepath
      local filename = filepath:match("[^/\\]+$")

      -- 一緒に pfv ファイルを掴んでいないか調べる
      local psddir = filepath:sub(1, #filepath-#filename)
      for i2, v2 in ipairs(files) do
        if v2.filepath:match("[^.]+$"):lower() == "pfv" then
          local pfv = v2.filepath:match("[^/\\]+$")
          local pfvdir = v2.filepath:sub(1, #v2.filepath-#pfv)
          if psddir == pfvdir then
            -- 同じフォルダー内の pfv ファイルを一緒に投げ込んでいたので連結
            filepath = filepath .. "|" .. pfv
            -- この pfv ファイルはドロップされるファイルからは取り除いておく
            table.remove(files, i2)
            break
          end
        end
      end

      -- aupファイルのフォルダの配下の場合、aupファイルからの相対パスを抜き出す
      rikky_module = require("rikky_module")
      local aup_file_path = rikky_module.getinfo("aup")
      local aup_filename = rikky_module.getinfo("aup",1)
      local aup_folder_path = string.gsub(aup_file_path, "("..aup_filename.."%.aup)", "")

      -- ファイルを直接読み込む代わりに exo ファイルを組み立てる
      math.randomseed(os.time())
      local tag = math.floor(math.random()*0x7fffffff + 1)
      local proj = GCMZDrops.getexeditfileinfo()
      local exo = [[
[exedit]
width=]] .. proj.width .. "\r\n" .. [[
height=]] .. proj.height .. "\r\n" .. [[
rate=]] .. proj.rate .. "\r\n" .. [[
scale=]] .. proj.scale .. "\r\n" .. [[
length=64
audio_rate=]] .. proj.audio_rate .. "\r\n" .. [[
audio_ch=]] .. proj.audio_ch .. "\r\n" .. [[
[0]
start=1
end=64
layer=1
group=1
overlay=1
camera=0
[0.0]
_name=テキスト
サイズ=1
表示速度=0.0
文字毎に個別オブジェクト=0
移動座標上に表示する=0
自動スクロール=0
B=0
I=0
type=0
autoadjust=0
soft=0
monospace=0
align=4
spacing_x=0
spacing_y=0
precision=0
color=ffffff
color2=000000
font=MS UI Gothic
text=]] .. GCMZDrops.encodeexotext("<?  -- PSDBridge準備 " .. filename .. "\r\n\r\nlocal id = obj.layer     -- ID\r\nlocal ptkf=" .. P.encodelua(filepath) .. "\r\nlocal old_aup_folder_path = " .. P.encodelua(aup_folder_path) .. "\r\nlocal tag = " .. tag .. "     -- 識別用タグ\r\n\r\n\r\n-- 以下は書き換えないでください\r\nrequire(\"PSDBridge\"):addPSDBox({\r\n  id=id,\r\n  ptkf=ptkf,\r\n  tag=tag,\r\n  obj=obj,\r\n  old_aup_folder_path=old_aup_folder_path,\r\n})\r\n\r\n-- 何も出力しないと直後のアニメーション効果以外適用されないため\r\n-- それに対するワークアラウンド\r\nmes(\" \")\r\n\r\n\r\n\r\n\r\n\r\n-- エラーにならない為だけの受け皿\r\nlocal ptkl=\"\"\r\n?>") .. "\r\n" .. [[
[0.1]
_name=標準描画
X=0.0
Y=0.0
Z=0.0
拡大率=100.00
透明度=0.0
回転=0.00
blend=0
]]

      -- PSDToolKit ウィンドウにドロップされたファイルを追加する
      -- 一時的に package.cpath を書き換え PSDToolKitBridge.dll を読み込んで addfile を呼ぶ
      local origcpath = package.cpath
      package.cpath = GCMZDrops.scriptdir() .. "..\\script\\PSDToolKit\\?.dll"
      require('PSDToolKitBridge').addfile(GCMZDrops.convertencoding(filepath, "sjis", "utf8"), tag)
      package.cpath = origcpath

      local filepath = GCMZDrops.createtempfile("psd", ".exo")
      f, err = io.open(filepath, "wb")
      if f == nil then
        error(err)
      end
      f:write(exo)
      f:close()
      debug_print("["..P.name.."] が " .. v.filepath .. " を exo ファイルに差し替えました。元のファイルは orgfilepath で取得できます。")
      files[i] = {filepath=filepath, orgfilepath=v.filepath}
    end
  end
  -- 他のイベントハンドラーにも処理をさせたいのでここは常に false
  return false
end

return P
