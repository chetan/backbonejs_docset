#!/usr/bin/env ruby

# tokens.rb - generates token list from backbone documentation
# Chetan Sarva <csarva@pixelcop.net>
#
# usage: tokens.rb
#
# will output Tokens.xml in the current directory

xml = File.open("Tokens.xml", "w")
html = File.open("Documents/html/toc.html").read()

# grab categories
cats = []
html.scan(%r{<a class="toc_title" href="#(.*?)">}).each do |c|
  cats << c.first
end

# grab sections
links = html.scan(%r{<a href="#(.*?)-(.*?)">(.*?)</a>})
inc = %w{Events Model Collection View Router History Sync Utility}
sections = {}
links.each do |l|
  next if not inc.include? l.first  
  sections[l.first] ||= []
  sections[l.first] << l.slice(1,2)  
end


# dump xml
xml.puts <<-EOF
<?xml version="1.0" encoding="UTF-8"?>
<Tokens version="1.0">
<File path=\"html/index.html\">
EOF

# cats
cats.each_with_index do |c, i|
  if c == "" then
    xml.puts "<Token><TokenIdentifier>//apple_ref/cpp/cat/01 Backbone.js</TokenIdentifier><Anchor>logo</Anchor></Token>"
    next
  end
  
  xml.puts "<Token><TokenIdentifier>//apple_ref/cpp/cat/#{(i+1).to_s.rjust(2, '0')} #{c.capitalize}</TokenIdentifier><Anchor>#{c}</Anchor></Token>"
end


# sections
inc.each do |i|
  toks = []
  sections[i].each do |m|
    name = m.last.gsub(%r{constructor / }, '')
    tok = "//apple_ref/cpp/instm/#{i}.#{name}"
    toks << tok
    anchor = "#{i}-#{m.first}"
    xml.puts "<Token><TokenIdentifier>#{tok}</TokenIdentifier><Anchor>#{anchor}</Anchor></Token>"
  end
  
  tok = "//apple_ref/cpp/cl/#{i}"
  xml.puts "<Token>"
  xml.puts "<TokenIdentifier>#{tok}</TokenIdentifier><Anchor>#{i}</Anchor>"
  xml.puts "<RelatedTokens>"
  
  toks.each do |t|
    xml.puts "<TokenIdentifier>#{t}</TokenIdentifier>"
  end
  
  xml.puts "</RelatedTokens>"
  xml.puts "</Token>"
end

xml.puts "</File>\n</Tokens>"