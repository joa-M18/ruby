module RN
  module Commands
    module Books
	  
	  class Create < Dry::CLI::Command
        desc 'Create a book'

        argument :name, required: true, desc: 'Name of the book'

        example [
          '"My book" # Creates a new book named "My book"',
          'Memoires  # Creates a new book named "Memoires"'
        ]

        def call(name:, **)
          name = name.gsub(/[^0-9A-Za-z.\-_ ]/, '') 
          if File.exists?(File.join(BOOKS_PATH,name))
			puts("Este libro ya existe")
		  else
			Dir.mkdir(File.join(BOOKS_PATH,name))
			puts(name + " fue creado exitosamente")
		  end
        end
      end

      class Delete < Dry::CLI::Command
        desc 'Delete a book'

        argument :name, required: false, desc: 'Name of the book'
        option :global, type: :boolean, default: false, desc: 'Operate on the global book'

        example [
          '--global  # Deletes all notes from the global book',
          '"My book" # Deletes a book named "My book" and all of its notes',
          'Memoires  # Deletes a book named "Memoires" and all of its notes'
        ]

        def call(name: nil, **options)
          global = options[:global]
          if global
			Dir.entries(File.join(BOOKS_PATH,"global")).each do |file|
			  begin
				File.delete(File.join(BOOKS_PATH,"global",file))
				puts(file + " fue eliminado")
			  rescue
			  end
			end
			puts("Libro global vacio")
		  else
			if(File.exists?(File.join(BOOKS_PATH,name)))
				Dir.entries(File.join(BOOKS_PATH,name)).each do |file|
				  begin
					File.delete(File.join(BOOKS_PATH,name,file))
					puts(file + " fue eliminado")
				  rescue
				  end
				end
				Dir.delete(File.join(BOOKS_PATH,name))
				puts("Libro %s borrado" %[name])
			else
			  puts("no existe")
			end
		  end
        end
      end

      class List < Dry::CLI::Command
        desc 'List books'

        example [
          '          # Lists every available book'
        ]

        def call(*)
		  puts(Dir.entries(BOOKS_PATH))
        end
      end

      class Rename < Dry::CLI::Command
        desc 'Rename a book'

        argument :old_name, required: true, desc: 'Current name of the book'
        argument :new_name, required: true, desc: 'New name of the book'

        example [
          '"My book" "Our book"         # Renames the book "My book" to "Our book"',
          'Memoires Memories            # Renames the book "Memoires" to "Memories"',
          '"TODO - Name this book" Wiki # Renames the book "TODO - Name this book" to "Wiki"'
        ]

        def call(old_name:, new_name:, **)
          new_name = new_name.gsub(/[^0-9A-Za-z.\-_ ]/, '')
          FileUtils.mv(File.join(BOOKS_PATH,old_name),File.join(BOOKS_PATH,new_name)) if File.exists?(File.join(BOOKS_PATH,old_name))
        end
      end
    end
  end
end
