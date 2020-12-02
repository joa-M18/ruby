module RN
	module Commands
		module Export
			require 'redcarpet'
			
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
				def exp(path,name)
					if File.exists?(path)
						file = File.new(File.join(File.expand_path("../../..",path),name + ".html"),"w")
						txt = File.read(path)
						stuf = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new).render(txt)
						file.puts(stuf)
						file.close
						puts("%s se ha exportado a formato HTML" %[name])
					else
						puts("%s no existe"%[name])
					end
				end
				
				
				def call(**options)
					book = options[:book]
					title = options[:title]
					if book.nil? and title.nil?
						Dir.entries(BOOKS_PATH)[2..].each do |libro|
							Dir.entries(File.join(BOOKS_PATH,libro))[2..].each do |nota|
								exp(File.join(BOOKS_PATH,libro,nota),libro + " - " + nota)
							end
						end
					elsif book.nil?
						exp(File.join(BOOKS_PATH,"global",title),"global - " + title)
					else
						if title.nil?
							Dir.entries(File.join(BOOKS_PATH,book))[2..].each do |nota|
								exp(File.join(BOOKS_PATH,book,nota),book + " - " + nota)
							end
						else
							exp(File.join(BOOKS_PATH,book,title),book + " - " + title)
						end
					end
				end
			end
		
		end
	end
end
