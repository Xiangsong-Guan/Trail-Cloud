-- 2018.10.11

local ch_template =
  [[<!doctype html>
<html lang="zh">

<head>
  <meta http-equiv="content-type" content="text/html; charset=GB18030">
  <meta charset="GB18030">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="�����ƣ�����һ��������ʢ�ģ��������յ������������ڶ�����Ļ�ģ�ʫ���뺽���ƵĹ��¡�">
  <meta name="author" content="���̹�">
  <meta name="Copyright" content="������Ȩ������� MIT;ͼ��������������Ȩ������� ����-����ҵ��ʹ�� 4.0 ���� (CC BY-NC 4.0);2018 Gao Xiangsong/Xiangsong-Guan/���̹�">
  <link rel="icon" href="/favicon.ico">

  <title>������ - [ch-code]</title>

  <link rel="stylesheet" type="text/css" href="/txt/css/cc.css">
</head>

<body>
  <h1>
    <a href="/content.html">������</a>
  </h1>

  <ol class="content">
    <li>
      <p><a href="/story/[pre-ch-code].html">[pre-ch-title]</a></p>
    </li>
    <li>
      <p>[ch-title]</p>
    </li>
    <li>
      <p>δ���������</p>
    </li>
  </ol>

  <div class="text">
    <h3>[ch-title]</h3>
    [txt]
  </div>

  <div class="footer">
    <i>
      <p>һ��������ʢ�ģ��������յ������������ڶ�����Ļ��</p>
      <p>ʫ���뺽���ƵĹ��¡�</p>
    </i>
  </div>
</body>

</html>]]

local a_template = '<a href="/story/[next-ch-code].html">[next-ch-title]</a>'

local ch_code, pre_ch_code = string.format("%03d", tonumber(arg[1])), string.format("%03d", tonumber(arg[1]) - 1)

-- read source file
local file = io.open(ch_code .. ".txt", "r")
local ch_title = file:read()
local ch = file:read("a")
file:close()

-- load index and update index
local index = dofile("ch-title-index.lua")
local pre_ch_title = index[pre_ch_code]
if pre_ch_title == nil then
  pre_ch_title = "**********************************************************************"
end
file = io.open("ch-title-index.lua", "r+")
file:seek("end", -1)
file:write(string.format('["%03d"] = "%s";\n}', ch_code, ch_title))
file:close()

-- write to html
ch_template = ch_template:gsub("%[ch%-code%]", ch_code)
ch_template = ch_template:gsub("%[pre%-ch%-code%]", pre_ch_code)
ch_template = ch_template:gsub("%[ch%-title%]", ch_title)
ch_template = ch_template:gsub("%[pre%-ch%-title%]", pre_ch_title)
ch = ch:gsub("\n", "</p>\n    <p>")
ch = ch_template:gsub("%[txt%]", "<p>" .. ch .. "</p>")
io.open("../html/story/" .. ch_code .. ".html", "w"):write(ch):close()

-- update content.html
file = io.open("../html/content.html", "r")
local content = file:read("a")
file:close()
content =
  content:gsub(
  "<!%-%- new index %-%->",
  [[<li>
      <p><a href="/story/]] ..
    ch_code .. '.html">' .. ch_title .. [[</a></p>
    </li>
    <!-- new index -->]]
)
io.open("../html/content.html", "w"):write(content):close()

-- update pre
if pre_ch_code == "-01" then
  os.exit(0)
end

a_template = a_template:gsub("%[next%-ch%-code%]", ch_code)
a_template = a_template:gsub("%[next%-ch%-title%]", ch_title)
file = io.open("../html/story/" .. pre_ch_code .. ".html", "r")
local pre_ch = file:read("a")
file:close()
pre_ch = pre_ch:gsub("δ���������", a_template)
io.open("../html/story/" .. pre_ch_code .. ".html", "w"):write(pre_ch):close()

os.exit(0)
