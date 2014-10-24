# Setup local rubyzip in path
$:.unshift File.dirname(__FILE__)+"/rubyzip-1.1.0/lib"
require "zip"

# Fix ruby version 1.8.7 which encodes everything as binary anyway
if RUBY_VERSION <= "1.8.7"
  class String
    def force_encoding(enc)
      self
    end
  end
end

def posterize_color(color)
  r, g, b = color[0..1], color[2..3], color[4..5]
  [ normalize_color_channel(r), 
    normalize_color_channel(g), 
    normalize_color_channel(b)].join.upcase
end

def normalize_color_channel(ch)
  "%02x" % (((ch.to_i(16) / 17).floor + ( (ch.to_i(16) % 17).to_f / 17 ).round) * 17)
end

# Replaces the Solid colors in a flash file xml with the posterized color
def posterize_colors_in_flash_xml(contents)
  contents.split("\n").map do |line|
    if /\<SolidColor color\=/.match line
      line.gsub!(/color\=\"#(.*)\"/) { |c| "color=\"\##{posterize_color($1)}\"" }
    end
    line
  end.join "\n"
end

def posterize_fla_file(path)
  fla_file = Zip::File.open(path)
  xml_files = fla_file.glob("**/*.xml")
  xml_files.each do |file|
    contents = file.get_input_stream.read
    contents_fixed = posterize_colors_in_flash_xml contents
    fla_file.get_output_stream(file.name) {|f| f << contents_fixed }
  end
  fla_file.close
end

if $0 == __FILE__
  if ARGV.length < 1
    abort "Usage: #{__FILE__} [fla_file]"
  end
  fla_path = ARGV[0]
  posterize_fla_file fla_path
end