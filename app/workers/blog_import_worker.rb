class BlogImportWorker
  include Sidekiq::Worker

  def perform(user_id, file_content)
    batch_size = 5000
    blogs_to_insert = []
    total_records = 0
    import_count = 0

    ActiveRecord::Base.transaction do
      SmarterCSV.process(StringIO.new(file_content), chunk_size: batch_size) do |chunk|
        total_records += chunk.size

        chunk.each do |row|
          blog = Blog.new row
          blogs_to_insert << blog
        end

        blog_import_result = Blog.import(blogs_to_insert, validate: true)
        import_count += blog_import_result.ids.size
        blogs_to_insert.clear
      end
    end

    logger.info "Imported #{import_count} out of #{total_records} records."
  end
end
