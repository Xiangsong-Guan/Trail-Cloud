-- 2018.10.11

--[[
当不使用参数时：
程序根据同目录下文件“ch-title-index.lua”，尝试录入后续章节。
编号需按照次序，当程序试图录入一个章节但“ch”中尚不存在该章节时，程序将即刻终止。

当使用单个数字参数时：
程序直接录入，使用旧编号等同于覆盖原有HTML内容，此可为后续修改所用；
新编号不予考虑，不允许跳过某一章节加入后续章节。
--]]


local a_template = '<a href="../story/[ch-code].html">[ch-title]</a>'
local ch_template =
[[
<!doctype html>
<html lang="zh">

<head>
  <meta http-equiv="content-type" content="text/html; charset=GB18030">
  <meta charset="GB18030">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="航迹云，这是一个绽放于盛夏，历经秋日的留恋，最终在冬日落幕的，诗人与航迹云的故事。">
  <meta name="author" content="香颂馆">
  <meta name="Copyright" content="代码授权许可依据 MIT;图像与语文著作保留一切权利;2020 Gao Xiangsong/Xiangsong-Guan/香颂馆">
  <link rel="icon" href="../favicon.ico">

  <title>航迹云 - [ch-code]</title>

  <link rel="stylesheet" type="text/css" href="../txt/css/cc.css">
</head>

<body>
  <h1>
    <a href="../content.html">航迹云</a>
  </h1>

  <ol class="content">
    <li>
      <p>[pre-item]</p>
    </li>
    <li>
      <p>[ch-title]</p>
    </li>
    <li>
      <p>[post-item]</p>
    </li>
  </ol>

  <div class="text">
    <h3>[ch-title]</h3>
    [txt]
  </div>

  <div class="footer">
    <i>
      <p>一个绽放于盛夏，历经秋日的留恋，最终在冬日落幕的</p>
      <p>诗人与航迹云的故事。</p>
    </i>
  </div>
</body>

</html>]]

local is_edit_job
local ch_code, pre_ch_code, post_ch_code
local index
local file

-- input check
ch_code = tonumber(arg[1])
if (not ch_code) and arg[1] then
  io.stderr:write("Invalid code!\n")
  return -1
end
index = dofile("ch-title-index.lua")
io.write("Handle input: ", ch_code or "nothing", ".\n")

-- edit job or addition job?
is_edit_job = ch_code
ch_code = ch_code or (#index + 1)
-- if edit but not a exist ch then invalid
if is_edit_job and (not index[ch_code]) then
  io.stderr:write("Code for edit not exist!\n")
  return -1
end
pre_ch_code = ch_code - 1
post_ch_code = ch_code + 1
if is_edit_job then
  io.write("Initialized for edit job.\n")
else
  io.write("Initialized for addition job.\n")
end

-- just do once if is edit job
while not is_edit_job do
  local ch_title
  local ch -- all the content for ch_code.txt
  local html, ch_in_p
  local pre_in_a, post_in_a = "", "未完待续……"
  local content
  local a

  io.write("Excution for code ", ch_code, "...\n")

  -- find out pre ch info, if this ch is 1st then leave blank
  if index[pre_ch_code] then
    pre_in_a = a_template:gsub("%[ch%-code%]", ("%03d"):format(pre_ch_code)):gsub("%[ch%-title%]", index[pre_ch_code])
    io.write("Found previous chapter: ", pre_ch_code, ".\n")
  else
    io.write("No previous chapter.\n")
  end
  -- find out post ch info, if this ch is last then leave "to be continue..."
  if index[post_ch_code] then
    post_in_a = a_template:gsub("%[ch%-code%]", ("%03d"):format(post_ch_code)):gsub("%[ch%-title%]", index[pre_ch_code])
    io.write("Found post chapter: ", post_ch_code, ".\n")
  else
    io.write("No post chapter.\n")
  end

  -- read source file
  file = io.open("../ch/"..("%03d"):format(ch_code)..".txt", "r")
  if not file then
    io.write("Ch.", ch_code, " not found, cancel.\n")
    break;
  end
  ch_title = file:read()
  ch = file:read("a")
  file:close()
  io.write("Compeleted story reading, found title: \"", ch_title, "\".\n");

  -- write html
  ch_in_p = ch:gsub("\n", "</p>\n    <p>"):gsub("<p></p>", "<p>&nbsp;</p>")
  html = ch_template:gsub("%[ch%-code%]", ("%03d"):format(ch_code)):gsub("%[ch%-title%]", ch_title)
  html = html:gsub("%[pre%-item%]", pre_in_a)
  html = html:gsub("%[post%-item%]", post_in_a)
  html = html:gsub("%[txt%]", "<p>" .. ch_in_p .. "</p>")
  io.open("../story/"..("%03d"):format(ch_code)..".html", "w"):write(html):close()
  io.write("../story/"..("%03d"):format(ch_code)..".html", " wrote.\n")

  -- update index
  index[ch_code] = ch_title

  -- make a
  a = a_template:gsub("%[ch%-code%]", ("%03d"):format(ch_code)):gsub("%[ch%-title%]", ch_title)

  -- update pre html
  if pre_ch_code > 0 then
    local pre_html
    io.write("Updating html content in html.", pre_ch_code, "...\n")
    file = io.open('../story/'..("%03d"):format(pre_ch_code)..'.html', 'r')
    pre_html = file:read('a')
    file:close()
    pre_html = pre_html:gsub('未完待续……', a)
    io.open('../story/'..("%03d"):format(pre_ch_code)..'.html', 'w'):write(pre_html):close()
  end

  -- append new one to content
  file = io.open("../content.html", "r")
  content = file:read("a")
  file:close()
  content =
    content:gsub(
      '<!%-%- new index %-%->',
[[
<li>
        <p>]]..a:gsub("%.%.%/", "")..[[</p>
      </li>
      <!-- new index -->]]
  )
  io.open('../content.html', 'w'):write(content):close()
  io.write("Content updated.\n")


  -- next for addition jobs
  ch_code = ch_code + 1
  pre_ch_code = ch_code - 1
  post_ch_code = ch_code + 1
end
io.write("All Excution done.\n")

-- rewrite index file
file = io.open("ch-title-index.lua", "w")
file:write("return\n{\n")
for i, v in ipairs(index) do
  file:write("\t[", ("%03d"):format(i), "] = \"", v, "\",\n")
end
file:write("}\n")
file:close()

return 0;
