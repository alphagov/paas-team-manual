require 'govuk_tech_docs'
require 'html-proofer'

activate :directory_indexes
after_build do |builder|
  begin
    HTMLProofer.check_directory(config[:build_dir], {
        :assume_extension => true,
        :allow_hash_href => true,
        :disable_external => true,
    }).run
  rescue RuntimeError => e
    puts e
  end
end

GovukTechDocs.configure(self)
