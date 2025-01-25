require 'date'
require 'optparse'

# 解析命令行参数
options = {
  title: "タイトル",
  date: DateTime.now.new_offset("+09:00"),
  category: "分類",
  tags: "タグ",
  output_dir: "./_posts"
}

OptionParser.new do |opts|
  opts.banner = "Usage: ruby script.rb [options]"

  opts.on("-t", "--title TITLE", "Specify the title") do |t|
    options[:title] = t
  end

  opts.on("-d", "--date DATE", "Specify the date (format: YYYY-MM-DD)") do |d|
    options[:date] = DateTime.parse(d).new_offset("+09:00")
  end

  opts.on("-c", "--category CATEGORY", "Specify categories (comma-separated)") do |c|
    options[:category] = c
  end

  opts.on("-g", "--tags TAGS", "Specify tags (comma-separated)") do |g|
    options[:tags] = g
  end

  opts.on("-o", "--output DIR", "Specify output directory") do |o|
    options[:output_dir] = o
  end
end.parse!

# 处理分类和标签
categories = options[:category].split(',')
tags = options[:tags].split(',')

# 生成 Markdown 文件内容
def generate_markdown(title, date, category, tags)
  <<~MD
  ---
  layout: post
  title: #{title}
  date: #{date.strftime('%Y-%m-%d %H:%M:%S %z')}
  category: [#{category.join(', ')}]
  tag: 
  #{tags.map { |t| "  - #{t}" }.join("\n")}
  ---

  ## {{ page.title }}
  MD
end

markdown_content = generate_markdown(options[:title], options[:date], categories, tags)

# 确保输出目录存在
Dir.mkdir(options[:output_dir]) unless Dir.exist?(options[:output_dir])

# 生成文件名
filename = "#{options[:date].strftime('%Y-%m-%d')}-#{options[:title]}.md"
file_path = File.join(options[:output_dir], filename)

# 写入文件
File.open(file_path, "w") do |file|
  file.puts markdown_content
end

puts "Markdown 文件已生成: #{file_path}"

