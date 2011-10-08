['open-uri','set'].each {|lib| require lib}
def crawl(url, visited = {})
  links_found = open(url).inject(Set.new) do |found, line|
    line.scan(/href *= *[\"']([^'"]+)[\"']/) {|m| found << $1 if $1.start_with?("http")} 
    found
  end
  links_found.each {|link| (visited[link] = url; crawl(link, visited)) unless visited[link]}
  visited
end
puts crawl(ARGV[0] || 'http://localhost:4567')

def scrape(url, max_depth, current_depth = 0)
  current_depth += 1
  open(url).inject([url]) do |memo, line|
    begin
      line.scan(/href *= *[\"']([^'"]+)[\"']/) {|m| memo << scrape($1, max_depth, current_depth) unless current_depth > max_depth}
    rescue Exception => ex; end # ignore bad links etc
    memo
  end
end