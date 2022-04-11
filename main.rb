require 'nokogiri'
require 'csv'

doc = Nokogiri.HTML5(File.open('/Users/m11o/cov-parser/coverage/index.html'))
doc.css('#content > .file_list_container').each do |link|
  filetype = link.attributes["id"]
  puts filetype

  CSV.open("/Users/m11o/cov-parser/csv/#{filetype}.csv", 'w+') do |csv|
    csv << %w[filename coverage line relevant_line lines_covered lines_missed]
    link.css('.file_list--responsive table.file_list .t-file').each do |file_link|
      filename = file_link.at_css('.t-file__name > a').text
      coverage = file_link.at_css('.t-file__coverage').text.to_f
      line = file_link.at_css('.cell--number:nth-of-type(2)').text
      relevant_line = file_link.at_css('.cell--number:nth-of-type(3)').text
      lines_covered = file_link.at_css('.cell--number:nth-of-type(4)').text
      lines_missed = file_link.at_css('.cell--number:nth-of-type(5)').text
      csv << [filename, coverage, line, relevant_line, lines_covered, lines_missed]
    end
  end
end
