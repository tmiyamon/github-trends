class Parser

  SECTIONS = [
    'Most Watched Today',
    'Most Watched This Week',
    'Most Watched This Month',
    'Most Watched Overall',
    'Most Forked Today',
    'Most Forked This Week',
    'Most Forked This Month',
    'Most Forked Overall'
  ]

  def initialize(url)
    @doc = Nokogiri::HTML(open(url))
  end

  SECTIONS.each do |section|
    define_method section.downcase.gsub(' ', '_') do
      fetch_repos(section)
    end
  end

  def trending_repos
    section_name = 'Trending Repos'
    elements = @doc.xpath("//h2[contains(.,'#{section_name}')]/following-sibling::ol/li/h3")
    
    extract_repos(elements) 
  end

  private

  def fetch_repos(section_name)
    elements = @doc.xpath("//h3[contains(.,'#{section_name}')]/following-sibling::ul/li")
    
   extract_repos(elements) 
  end

  def extract_repos(elements)
    elements.map { |element| element.xpath('a').children.map { |text| text.to_s } }
    
  end
end
