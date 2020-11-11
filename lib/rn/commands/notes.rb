module RN
  module Commands
    module Notes
	
      class Create < Dry::CLI::Command
        desc 'Create a note'

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
			file = File.new(File.join(BOOKS_PATH, "global",title),"w")
			stuf = STDIN.gets.chomp
			file.puts(stuf)
			file.close
			puts(title + " fue creado con exito")
		  elsif File.exists?(File.join(BOOKS_PATH,book,title))
			file = File.new(File.join(BOOKS_PATH, book,title),"w")
			stuf = STDIN.gets.chomp
			file.puts(stuf)
			file.close
			puts(title + " fue creado con exito")
		  else
			puts("Libro " + book + " no existe")
		  end
        end
      end

      class Delete < Dry::CLI::Command
        desc 'Delete a note'

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
			if File.exists?(File.join(BOOKS_PATH,"global",title))
			  File.delete(File.join(BOOKS_PATH,"global",title))
			  puts("%s fue borrado" %[title])
			else
			  puts("No existe este archivo")
			end
		  elsif File.exists?(File.join(BOOKS_PATH,book,title))
			File.delete(File.join(BOOKS_PATH,book,title))
			puts("%s fue borrado" %[title])
		  else
			puts("No existe este archivo")
		  end
        end
      end

      class Edit < Dry::CLI::Command
        desc 'Edit the content a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Edits a note titled "todo" from the global book',
          '"New note" --book "My book" # Edits a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Edits a note titled "thoughts" from the book "Memoires"'
        ]

        def call(title:, **options)
          book = options[:book]
          if book.nil? and File.exists?(File.join(BOOKS_PATH,"global",title))
			file = File.open(File.join(BOOKS_PATH, "global",title),"w")
			stuf = STDIN.gets.chomp
			file.puts(stuf)
			file.close
			puts(title + " fue editado con exito")
		  elsif File.exists?(File.join(BOOKS_PATH,book,title))
			file = File.open(File.join(BOOKS_PATH, book,title),"w")
			stuf = STDIN.gets.chomp
			file.puts(stuf)
			file.close
			puts(title + " fue editado con exito")
		  else
			puts("No existe el archivo")
		  end
        end
      end

      class Retitle < Dry::CLI::Command
        desc 'Retitle a note'

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
			if File.exists?(File.join(BOOKS_PATH,"global",old_title))
			  FileUtils.mv(File.join(BOOKS_PATH,"global",old_title),File.join(BOOKS_PATH,"global",new_title))
			  puts("Nombre cambiado exitosamente")
			else
			  puts("No existe este archivo")
			end
		  elsif File.exists?(File.join(BOOKS_PATH,book,old_title))
			FileUtils.mv(File.join(BOOKS_PATH,book,old_title),File.join(BOOKS_PATH,book,new_title))
			puts("Nombre cambiado exitosamente")
		  else
			puts("No existe este archivo")
		  end
        end
      end

      class List < Dry::CLI::Command
        desc 'List notes'

        option :book, type: :string, desc: 'Book'
        option :global, type: :boolean, default: false, desc: 'List only notes from the global book'

        example [
          '                 # Lists notes from all books (including the global book)',
          '--global         # Lists notes from the global book',
          '--book "My book" # Lists notes from the book named "My book"',
          '--book Memoires  # Lists notes from the book named "Memoires"'
        ]

        def call(**options)
          book = options[:book]
          global = options[:global]
          warn "TODO: Implementar listado de las notas del libro '#{book}' (global=#{global}).\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
        end
      end

      class Show < Dry::CLI::Command
        desc 'Show a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Shows a note titled "todo" from the global book',
          '"New note" --book "My book" # Shows a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Shows a note titled "thoughts" from the book "Memoires"'
        ]

        def call(title:, **options)
          book = options[:book]
          if book.nil? and File.exists?(File.join(BOOKS_PATH,"global",title))
            stuf =File.read(File.join(BOOKS_PATH,"global",title))
            puts(stuf)
          elsif File.exists?(File.join(BOOKS_PATH,book,title))
			stuf = File.read(File.join(BOOKS_PATH,book,tilte))
			puts(stuf)
		  else
			puts("No existe el archivo")
		  end
        end
      end
    end
  end
end
