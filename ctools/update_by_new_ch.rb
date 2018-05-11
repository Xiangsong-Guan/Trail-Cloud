# encoding: GB18030

# 约定：
#   源文件名：ch-000.txt；目标路径：../html/story/ch-000.html
#   所有源文件（章节）需要在同一文件夹下，以便析出前后目录
#   章节标题独占第一行

# 一些html中需要的元素
para_begin = "    <p>"
para_end = "</p>\n"
html_space = "&nbsp;"

# 生成文件名
dest_file_ext = "ch-[r: ch-code].html"

# 一些需要的章节元信息
# 汉字序号
ch-num = ''
# 数字序号
ch-code = ''
# 带有汉字序号的标题
ch-name = ''

# 一些需要的目录元信息
pre_ch_code = ''
pre_ch_name = ''
next_ch_code = ''
next_ch_name = ''

formulation_path = "ch-template.html"

if $PROGRAM_NAME == __FILE__
  #合法性检查
  if not File.exist? formulation_path
    puts "The formulation is not exist!"
    exit 1
  end

  puts "Pleas enter the file path: "
  source_path = gets
  source_path.chop!

  if not File.exist? source_path
    puts "The essay dose not exist!"
    exit 1
  end

  # 读取模板
  formulation = IO.read(formulation_path, encoding: Encoding::GB18030)
  # 读取文章并转换空行为一个html空格占位
  para = IO.readlines(source_path, encoding: Encoding::GB18030)
  para.each do |l|
    if l.end_with? "\n"
      l.chop!
    end
  end
  para.map! { |l| l == "" ? html_space : l }
  # 析出章节标题与汉字序号
  ch-name = para.shift
  ch-num = ch-name.chr
  # 获得正文部分的html形式
  para.map! { |l| para_begin + l + para_end }

  # 根据元文件名析出章节数字编号

  # 根据元文件名析出前后章节数字编号

  # 根据前后章节数字编号读取其章节标题，这两个文件与源文件同路径

  # 替换写入

  # 写入
  parts = formulation.split(date_flag)
  IO.write(dest_path, (parts[0] + date_flag), mode: "a", encoding: Encoding::GB18030)
  IO.write(dest_path, Time.now, mode: "a", encoding: Encoding::GB18030)

  parts = parts[1].split(headline_flag, 2)#参数2，旨在使整个串只从第一个headline_flag处分裂成两半。
  IO.write(dest_path, (parts[0] + headline_flag), mode: "a", encoding: Encoding::GB18030)
  IO.write(dest_path, para[0], mode: "a", encoding: Encoding::GB18030)
  para.delete_at 0

  parts = parts[1].split(text_flag)
  IO.write(dest_path, (parts[0] + text_flag), mode: "a", encoding: Encoding::GB18030)
  para.each do |l|
    IO.write(dest_path, (para_begin + l + para_end), mode: "a", encoding: Encoding::GB18030)
  end

  IO.write(dest_path, parts[1], mode: "a", encoding: Encoding::GB18030)
  #结束读写

  exit 0
end