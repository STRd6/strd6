require 'rubygems'
require 'open-uri'
require 'hpricot'
require 'cgi'

UTOR_PATH = "C:\\Program Files\\uTorrent\\uTorrent.exe"
TOR_DIR = File.expand_path(File.dirname(__FILE__)) + "/tor/"

def get_doc(url)
  response = ''
  
  open(url, "User-Agent" => "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9) Gecko/2008052906 Firefox/3.0") do |f|
    puts "Fetched document: #{f.base_uri}"
    puts "\t Content Type: #{f.content_type}\n"
    puts "\t Charset: #{f.charset}\n"
    puts "\t Content-Encoding: #{f.content_encoding}\n"
    puts "\t Last Modified: #{f.last_modified}\n\n"
    
    response = f.read
  end

  return response
end

def download_torrent(url)
  response = ''
  
  open(url, "User-Agent" => "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9) Gecko/2008052906 Firefox/3.0") do |f|
    puts "Fetched document: #{f.base_uri}"
    if f.content_type == 'application/x-bittorrent'
      # Save the response body
      response = f.read
    else
      response = false
    end
  end

  return response
end

def get_tor_from_page(url, title)
  doc = Hpricot get_doc(url)
  
  elements = doc/'/html/body/div[4]/dl/dt/a'
  
  elements.each do |element|
    href = element['href']
    
    case href
    when /mininova/
      puts href
      tor_url = href.gsub('tor', 'get')
      
      if torrent = download_torrent(tor_url)
        File.open("#{TOR_DIR}#{title}", 'wb') do |f|
          f << torrent
        end
        return true
      end
    end
    
  end
  
  return false
end

def get_search_results(query)
  query = CGI.escape(query)
  url = "http://www.torrentz.com/search?q=#{query}"
  doc = Hpricot get_doc(url)
  elements = doc/'/html/body/div[4]/dl'
  
  #TODO: Iterate
  first = elements.first
  
  title_zone = (first/'dt/a').first
  puts title_zone
  
  title = title_zone.inner_text.gsub(/( )+/, '_') + ".torrent"
  href = title_zone['href']
  
  age = (first/'dd/span.a').inner_text
  size = (first/'dd/span.s').inner_text
  seeds = (first/'dd/span.u').inner_text
  peers = (first/'dd/span.d').inner_text
  
  #TODO: Hueristics
  
  puts "Title: #{title}"
  puts "Age: #{age}"
  puts "Size: #{size}"
  puts "Seeds: #{seeds}"
  puts "Peers: #{peers}"
  
  puts "href='#{href}'"
  
  get_tor_from_page "http://www.torrentz.com#{href}", title
  return title
end

def run_utor(title)
  command = "\"#{UTOR_PATH}\" \"#{TOR_DIR}#{title}\""
  puts command
  `#{command}`
end

#get_tor_from_page 'http://www.torrentz.com/b212d595df25d950d9b007619ccd134e1ad49cfa'

if $PROGRAM_NAME == __FILE__
  title = get_search_results ARGV.join(' ')
  run_utor(title)
end