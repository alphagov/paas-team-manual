require 'govuk_tech_docs'
require 'html-proofer'

activate :directory_indexes
activate :relative_assets
set :relative_links, true

after_build do |builder|
  begin
    HTMLProofer.check_directory(config[:build_dir], {
        :assume_extension => true,
        :allow_hash_href => true,
        :disable_external => true,
        :url_swap => { config[:tech_docs]['host'] => '' },
    }).run
  rescue RuntimeError => e
    raise e unless e.to_s =~ /HTML-Proofer found .* failure/
    puts e
    exit 1
  end
end

GovukTechDocs.configure(self)
