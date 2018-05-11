# encoding: GB18030

# Լ����
#   Դ�ļ�����ch-000.txt��Ŀ��·����../html/story/ch-000.html
#   ����Դ�ļ����½ڣ���Ҫ��ͬһ�ļ����£��Ա�����ǰ��Ŀ¼
#   �½ڱ����ռ��һ��

# һЩhtml����Ҫ��Ԫ��
para_begin = "    <p>"
para_end = "</p>\n"
html_space = "&nbsp;"

# �����ļ���
dest_file_ext = "ch-[r: ch-code].html"

# һЩ��Ҫ���½�Ԫ��Ϣ
# �������
ch-num = ''
# �������
ch-code = ''
# ���к�����ŵı���
ch-name = ''

# һЩ��Ҫ��Ŀ¼Ԫ��Ϣ
pre_ch_code = ''
pre_ch_name = ''
next_ch_code = ''
next_ch_name = ''

formulation_path = "ch-template.html"

if $PROGRAM_NAME == __FILE__
  #�Ϸ��Լ��
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

  # ��ȡģ��
  formulation = IO.read(formulation_path, encoding: Encoding::GB18030)
  # ��ȡ���²�ת������Ϊһ��html�ո�ռλ
  para = IO.readlines(source_path, encoding: Encoding::GB18030)
  para.each do |l|
    if l.end_with? "\n"
      l.chop!
    end
  end
  para.map! { |l| l == "" ? html_space : l }
  # �����½ڱ����뺺�����
  ch-name = para.shift
  ch-num = ch-name.chr
  # ������Ĳ��ֵ�html��ʽ
  para.map! { |l| para_begin + l + para_end }

  # ����Ԫ�ļ��������½����ֱ��

  # ����Ԫ�ļ�������ǰ���½����ֱ��

  # ����ǰ���½����ֱ�Ŷ�ȡ���½ڱ��⣬�������ļ���Դ�ļ�ͬ·��

  # �滻д��

  # д��
  parts = formulation.split(date_flag)
  IO.write(dest_path, (parts[0] + date_flag), mode: "a", encoding: Encoding::GB18030)
  IO.write(dest_path, Time.now, mode: "a", encoding: Encoding::GB18030)

  parts = parts[1].split(headline_flag, 2)#����2��ּ��ʹ������ֻ�ӵ�һ��headline_flag�����ѳ����롣
  IO.write(dest_path, (parts[0] + headline_flag), mode: "a", encoding: Encoding::GB18030)
  IO.write(dest_path, para[0], mode: "a", encoding: Encoding::GB18030)
  para.delete_at 0

  parts = parts[1].split(text_flag)
  IO.write(dest_path, (parts[0] + text_flag), mode: "a", encoding: Encoding::GB18030)
  para.each do |l|
    IO.write(dest_path, (para_begin + l + para_end), mode: "a", encoding: Encoding::GB18030)
  end

  IO.write(dest_path, parts[1], mode: "a", encoding: Encoding::GB18030)
  #������д

  exit 0
end