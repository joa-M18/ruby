module RN
  module Commands
    module Notes
		require_relative '../Models/Note'
		
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
			book = 'global'
		  end
		  if RN::Models::Book::Book.new(book).exist?
			if RN::Models::Note::Note.new(title,book).create
				puts "Nota creada exitosamente"
			else
				puts "nombre invalido"
			end
		  else
			puts "cuaderno inexistente"
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
			book = 'global'
          end
          note = RN::Models::Note::Note.new(title,book)
          if note.exist?
			note.delete
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
			
        def call(title:, **options)
          book = options[:book]
          if book.nil? 
			book = 'global'
		  end
		  if RN::Models::Note::Note.new(title,book).edit
			puts "Nota editada exitosamente"
		  else
			puts "Nota inexistente"
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
			book = "global"
		  end
		  if RN::Models::Note::Note.retitle(old_title,new_title,book)
			puts "Nombre cambiado exitosamente"
		  else
			puts "Operacion fallida"
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

		
		
        def call(**options)
			book = options[:book]
			global = options[:global]
			notes = []
			if global
				RN::Models::Book::Book.new('global').notes.each do |note|
					notes << RN::Models::Note::Note.new(note,'global')
				end
			elsif book
				RN::Models::Book::Book.new(book).notes.each do |note|
					notes << RN::Models::Note::Note.new(note,book)
				end
			else
				Dir.entries(BOOKS_PATH)[2..].each do |file|
					book = RN::Models::Book::Book.new(file)
					book.notes.each do |note|
						notes << RN::Models::Note::Note.new(note,file)
					end
				end
			end
			notes.each do |note|
				puts note.to_string
			end
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
          if book.nil?
			book = "global"
          end
          note = RN::Models::Note::Note.new(title,book)
          if note.show
          else
			puts("No existe el archivo")
		  end
        end
      end
    end
  end
end
