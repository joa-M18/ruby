module RN
  module Models
    module Note
		require_relative 'Book'
		class Note
			def initialize(title,book)
				@note_title = title
				@note_book = book
				@note_content = ""
				if self.exist?
					@note_content = File.read(File.join(BOOKS_PATH,book,title))
				end
			end
			
			def create
				if self.exist?
					return false
				else
					@note_content = self.load_data
					self.save
					return true
				end
			end
			
			def edit
				if self.exist?
					puts("Texto Original")
					puts(@note_content)
					@note_content = load_data
					self.save
					return true
				else
					return false
				end
			end
			
			def load_data
				puts("Comienze a escribir aqui, finalize con una linea %END% ")
				stuf = ""
				linea = STDIN.gets.chomp
				while linea != "%END%" do
					stuf = stuf + linea + "\n"
					linea = STDIN.gets.chomp
				end
				return stuf
			end
			
			def to_string
				puts ("Libro: "+@note_book+" - Titulo: "+@note_title)
			end
			
			def title
				return @note_title
			end
			
			def book
				return @note_book
			end
			
			def content
				return @note_content
			end
			
			def exist?
				if RN::Models::Book::Book.new(@note_book).have_note?(@note_title)
					return true
				else
					return false
				end
			end
			
			def show
				if self.exist?
					puts(@note_content)
					return true
				else
					return false
				end
			end
			
			def change_name(name)
				@note_title = name
			end
			
			def delete
				File.delete(File.join(BOOKS_PATH,@note_book,@note_title))
			end
			
			def save
				file = File.new(File.join(BOOKS_PATH, @note_book,@note_title),"w")
				file.puts(@note_content)
				file.close
			end
			
			def self.retitle(old_title,new_title,book)
				old_note = self.new(old_title,book)
				new_note = self.new(new_title,book)
				if (old_note.exist? && (not new_note.exist?))
					old_note.delete
					old_note.change_name(new_title)
					old_note.save
					return true
				else
					return false
				end
			end
		end
    end
  end
end
