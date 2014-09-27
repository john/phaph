class CreateDocumentJob < ActiveJob::Base
  queue_as :urgent

  def perform(*args)
  	document = self.arguments.first
  	user = self.arguments[1]
    
    if document.url.present?
      # generate a pdf
      # pdf_out = `wkhtmltopdf #{@document.url}/#{@document.id}.pdf`

      document.archive_site
    else
      # if a file upload, generate thumbs from pdf,
      # and upload both the pdfs and thumbs to S3
      document.archive_file
    end
      
      # document.create_activity :create, owner: user
  end

end
