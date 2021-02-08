module RN
	module Commands
		module Export
			require 'redcarpet'
			require_relative '../Models/Note'
			
			class To_html < Dry::CLI::Command
				desc 'Export to html'
				
				example [
					'								#Export all notes to HTML',
					'--book libro1					#Export all notes in "libro1" to HTML',
					'--title titulo1				#Export note "titulo1" from global to HTML',
					'--book libro1 --title titulo1	#Export note "titulo1" from book "libro1" to HTML'
				]
				
				option :book, type: :string, desc: 'Book name'
				option :title, type: :string, desc: 'note title'
				def exp(note)
					file = File.new(File.join(File.expand_path("../",BOOKS_PATH),note.book + " - "+ note.title + ".html"),"w")
					puts(note.to_string)
					stuf = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new).render(note.content)
					file.puts(stuf)
					file.close
					puts("%s se ha exportado a formato HTML" %[note.title])
				end
				
				
				def call(**options)
					book = options[:book]
					title = options[:title]
					if book.nil? and title.nil?
						Dir.entries(BOOKS_PATH)[2..].each do |file|
							book = RN::Models::Book::Book.new(file)
							book.notes.each do |name|
								note = RN::Models::Note::Note.new(name,file)
								exp(note)
							end
						end
					else
						if book.nil?
							book = 'global'
						end
						if title.nil?
							RN::Models::Book::Book.new(book).notes.each do |title|
								exp(RN::Models::Note::Note.new(title,book))
							end
						else
							note = RN::Models::Note::Note.new(title,book)
							if note.exist?
								exp(note)
							else
								puts "Nota no existente"
							end
						end
					end
				end
			end
		
		end
	end
end
