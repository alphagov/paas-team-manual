require 'govuk_tech_docs'
require 'html-proofer'

activate :directory_indexes
page '/google*.html', directory_index: false

after_build do |builder|
  begin
    HTMLProofer.check_directory(config[:build_dir], {
        :assume_extension => true,
        :allow_hash_href => true,
        :disable_external => true,
        :swap_urls => { config[:tech_docs]['host'] => '' },
    }).run
  rescue RuntimeError => e
    raise e unless e.to_s =~ /HTML-Proofer found .* failure/
    puts e
    exit 1
  end
end

GovukTechDocs.configure(self)

set :layout, 'custom'
