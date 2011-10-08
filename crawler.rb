['open-uri','set'].each {|lib| require lib}
def crawl(url,  max_depth = 10, current_depth = 0, visited = {})
  begin page = open(url); print '.'
  rescue Exception => ex; return visited; end # ignore bad links etc
  links_found = page.inject(Set.new) do |found, line|
    line.scan(/href *= *[\"']([^'"]+)[\"']/) {|m| found << $1 if $1.start_with?("http")} 
    found
  end
  links_found.each {|link| (visited[link] = url; crawl(link, max_depth, current_depth + 1, visited)) unless visited[link] or current_depth >= max_depth}
  visited
end
puts crawl(ARGV[0] || 'http://localhost:4567', ARGV[1].to_i || 10)