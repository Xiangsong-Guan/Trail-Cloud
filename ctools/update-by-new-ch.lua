-- 2018.10.11

local ch_template =
  [[<!doctype html>
<html lang="zh">

<head>
  <meta http-equiv="content-type" content="text/html; charset=UTF-8">
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="航迹云，这是一个绽放于盛夏，历经秋日的留恋，最终在冬日落幕的，诗人与航迹云的故事。">
  <meta name="author" content="香颂馆">
  <meta name="Copyright" content="代码授权许可依据 MIT;图像与语文著作授权许可依据 署名-非商业性使用 4.0 国际 (CC BY-NC 4.0);2019 Gao Xiangsong/Xiangsong-Guan/香颂馆">
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
      <p><a href="../story/[pre-ch-code].html">[pre-ch-title]</a></p>
    </li>
    <li>
      <p>[ch-title]</p>
    </li>
    <li>
      <p>未完待续……</p>
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

local a_template = '<a href="../story/[next-ch-code].html">[next-ch-title]</a>'

local ch_code, pre_ch_code = string.format('%03d', tonumber(arg[1])), string.format('%03d', tonumber(arg[1]) - 1)

-- read source file
local file = io.open('../ch/' .. ch_code .. '.txt', 'r')
local ch_title = file:read()
local ch = file:read('a')
file:close()

-- load index and update index
local index = dofile('ch-title-index.lua')
local pre_ch_title = index[pre_ch_code]
if pre_ch_title == nil then
  pre_ch_title = ''
end
file = io.open('ch-title-index.lua', 'r+')
file:seek('end', -1)
file:write(string.format('  ["%03d"] = "%s",\n}', ch_code, ch_title))
file:close()

-- write to html
ch_template = ch_template:gsub('%[ch%-code%]', ch_code)
ch_template = ch_template:gsub('%[pre%-ch%-code%]', pre_ch_code)
ch_template = ch_template:gsub('%[ch%-title%]', ch_title)
ch_template = ch_template:gsub('%[pre%-ch%-title%]', pre_ch_title)
ch = ch:gsub('\n', '</p>\n    <p>')
ch = ch:gsub('<p></p>', '<p>&nbsp;</p>')
ch = ch_template:gsub('%[txt%]', '<p>' .. ch .. '</p>')
io.open('../story/' .. ch_code .. '.html', 'w'):write(ch):close()

-- update content.html
file = io.open('../content.html', 'r')
local content = file:read('a')
file:close()
content =
  content:gsub(
  '<!%-%- new index %-%->',
  [[<li>
        <p><a href="story/]] ..
    ch_code .. '.html">' .. ch_title .. [[</a></p>
      </li>
      <!-- new index -->]]
)
io.open('../content.html', 'w'):write(content):close()

-- update pre
if pre_ch_code == '-01' then
  os.exit(0)
end

a_template = a_template:gsub('%[next%-ch%-code%]', ch_code)
a_template = a_template:gsub('%[next%-ch%-title%]', ch_title)
file = io.open('../story/' .. pre_ch_code .. '.html', 'r')
local pre_ch = file:read('a')
file:close()
pre_ch = pre_ch:gsub('未完待续……', a_template)
io.open('../story/' .. pre_ch_code .. '.html', 'w'):write(pre_ch):close()

os.exit(0)
