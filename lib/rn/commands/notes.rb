module RN
  module Commands
    module Notes
		
		def note_exist?(book,title)
			if book.nil?
				return false
			elsif File.exists?(File.join(BOOKS_PATH,book,title))
				return true
			else
				return false
			end
		end
      
		def load_data
			print("Comienze a escribir aqui, finalize con una linea %END% ")
			stuf = ""
			linea = STDIN.gets.chomp
			while linea != "%END%" do
				stuf = stuf + linea + "\n"
				linea = STDIN.gets.chomp
			end
			return stuf
		end
		
      class Create < Dry::CLI::Command
        desc 'Create a note'
		include Notes

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Creates a note titled "todo" in the global book',
          '"New note" --book "My book" # Creates a note titled "New note" in the book "My book"',
          'thoughts --book Memoires    # Creates a note titled "thoughts" in the book "Memoires"'
        ]

        def call(title:, **options)
          book = options[:book]
          title = title.gsub(/[^0-9A-Za-z.\-_ ]/, '')
          if book.nil?
			if note_exist?("global",title)
				puts("Ya existe una nota con ese nombre")
			else
				file = File.new(File.join(BOOKS_PATH, "global",title),"w")
				stuf = load_data
				file.puts(stuf)
				file.close
				puts(title + " fue creado con exito")
			end
		  elsif File.exists?(File.join(BOOKS_PATH,book))
			if note_exist?(book,title)
				puts("Ya esite una nota con ese nombre")
			else
				file = File.new(File.join(BOOKS_PATH, book,title),"w")
				stuf = load_data
				file.puts(stuf)
				file.close
				puts(title + " fue creado con exito")
			end
		  else
			puts("Libro " + book + " no existe")
		  end
        end
      end

      class Delete < Dry::CLI::Command
        desc 'Delete a note'
		include Notes

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Deletes a note titled "todo" from the global book',
          '"New note" --book "My book" # Deletes a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Deletes a note titled "thoughts" from the book "Memoires"'
        ]

        def call(title:, **options)
          book = options[:book]
          if book.nil?
			if note_exist?("global",title)
			  File.delete(File.join(BOOKS_PATH,"global",title))
			  puts("%s fue borrado" %[title])
			else
			  puts("No existe este archivo")
			end
		  elsif note_exist?(book,title)
			File.delete(File.join(BOOKS_PATH,book,title))
			puts("%s fue borrado" %[title])
		  else
			puts("No existe este archivo")
		  end
        end
      end

      class Edit < Dry::CLI::Command
        desc 'Edit the content a note'
		include Notes
		
		
        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Edits a note titled "todo" from the global book',
          '"New note" --book "My book" # Edits a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Edits a note titled "thoughts" from the book "Memoires"'
        ]

		def edit_data(path)
			puts("Texto Original")
			puts(File.read(path))
			file = File.open(path,"w")
			stuf = load_data
			file.puts(stuf)
			file.close
		end	
			
        def call(title:, **options)
          book = options[:book]
          if book.nil? and note_exist?("global",title)
			edit_data(File.join(BOOKS_PATH,"global",title))
			puts(title + " fue editado con exito")
		  elsif note_exist?(book,title)
			edit_data(File.join(BOOKS_PATH,book,title))
			puts(title + " fue editado con exito")
		  else
			puts("No existe el archivo")
		  end
        end
      end

      class Retitle < Dry::CLI::Command
        desc 'Retitle a note'
		include Notes
		
        argument :old_title, required: true, desc: 'Current title of the note'
        argument :new_title, required: true, desc: 'New title for the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo TODO                                 # Changes the title of the note titled "todo" from the global book to "TODO"',
          '"New note" "Just a note" --book "My book" # Changes the title of the note titled "New note" from the book "My book" to "Just a note"',
          'thoughts thinking --book Memoires         # Changes the title of the note titled "thoughts" from the book "Memoires" to "thinking"'
        ]

        def call(old_title:, new_title:, **options)
          new_title = new_title.gsub(/[^0-9A-Za-z.\-_ ]/, '')
          book = options[:book]
          if book.nil?
			if note_exist?("global",old_title)
			  if note_exist?("global",new_title)
				puts("Ya existe una nota con ese nombre")
			  else
				FileUtils.mv(File.join(BOOKS_PATH,"global",old_title),File.join(BOOKS_PATH,"global",new_title))
				puts("Nombre cambiado exitosamente")
			  end
			else
			  puts("No existe este archivo")
			end
		  elsif note_exist?(book,old_title)
			if note_exist?(book,new_title)
				puts("Ya existe una nota con ese nombre")
			else
				FileUtils.mv(File.join(BOOKS_PATH,book,old_title),File.join(BOOKS_PATH,book,new_title))
				puts("Nombre cambiado exitosamente")
			end
		  else
			puts("No existe este archivo")
		  end
        end
      end

      class List < Dry::CLI::Command
        desc 'List notes'
		include Notes
		
        option :book, type: :string, desc: 'Book'
        option :global, type: :boolean, default: false, desc: 'List only notes from the global book'

        example [
          '                 # Lists notes from all books (including the global book)',
          '--global         # Lists notes from the global book',
          '--book "My book" # Lists notes from the book named "My book"',
          '--book Memoires  # Lists notes from the book named "Memoires"'
        ]

		def add_notes(notes,book)
			if File.exists?(File.join(BOOKS_PATH,book))
				notes.append(book + ":")
				if Dir.entries(File.join(BOOKS_PATH,book)).length() == 2
						notes[-1].concat(" <libro vacio>")
				else
					Dir.entries(File.join(BOOKS_PATH,book))[2..].each do |nota|
						notes.append("	" + nota)
					end
				end
			else
				puts("Libro: \"%s\" no existe" %[book])
			end
			return notes
		end	
		
        def call(**options)
			book = options[:book]
			global = options[:global]
			notes = []
			if not (global or book)
				Dir.entries(BOOKS_PATH)[2..].each do |libro|
					notes = add_notes(notes,libro)
				end
			else
				if global
					notes = add_notes(notes,"global")
				end
				if book
					notes = add_notes(notes,book)
				end
			end
			puts(notes)
        end
      end

      class Show < Dry::CLI::Command
        desc 'Show a note'
		include Notes
        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Shows a note titled "todo" from the global book',
          '"New note" --book "My book" # Shows a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Shows a note titled "thoughts" from the book "Memoires"'
        ]
        
			
        def call(title:, **options)
          book = options[:book]
          if book.nil? and note_exist?("global",title)
            stuf =File.read(File.join(BOOKS_PATH,"global",title))
            puts(stuf)
          elsif note_exist?(book,title)
			stuf = File.read(File.join(BOOKS_PATH,book,title))
			puts(stuf)
		  else
			puts("No existe el archivo")
		  end
        end
      end
    end
  end
end
