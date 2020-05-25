-- 2018.10.11

--[[
����ʹ�ò���ʱ��
�������ͬĿ¼���ļ���ch-title-index.lua��������¼������½ڡ�
����谴�մ��򣬵�������ͼ¼��һ���½ڵ���ch�����в����ڸ��½�ʱ�����򽫼�����ֹ��

��ʹ�õ������ֲ���ʱ��
����ֱ��¼�룬ʹ�þɱ�ŵ�ͬ�ڸ���ԭ��HTML���ݣ��˿�Ϊ�����޸����ã�
�±�Ų��迼�ǣ�����������ĳһ�½ڼ�������½ڡ�
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
  <meta name="description" content="�����ƣ�����һ��������ʢ�ģ��������յ������������ڶ�����Ļ�ģ�ʫ���뺽���ƵĹ��¡�">
  <meta name="author" content="���̹�">
  <meta name="Copyright" content="������Ȩ������� MIT;ͼ����������������һ��Ȩ��;2020 Gao Xiangsong/Xiangsong-Guan/���̹�">
  <link rel="icon" href="../favicon.ico">

  <title>������ - [ch-code]</title>

  <link rel="stylesheet" type="text/css" href="../txt/css/cc.css">
</head>

<body>
  <h1>
    <a href="../content.html">������</a>
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
      <p>һ��������ʢ�ģ��������յ������������ڶ�����Ļ��</p>
      <p>ʫ���뺽���ƵĹ��¡�</p>
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
  local pre_in_a, post_in_a = "", "δ���������"
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
    pre_html = pre_html:gsub('δ���������', a)
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
