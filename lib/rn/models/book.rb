#proximamente
module RN
	module Models
		module Book
			class Book
			  def initialize(name)
				@book_name=name
				@book_notes = []
				if self.exist?
					Dir.entries(File.join(BOOKS_PATH,name))[2..].each do |file|
						@book_notes << file
					end
				end
			  end
			  
			  def exist?
				if File.exists?(File.join(BOOKS_PATH,@book_name))
					return true
				else
					return false
				end
			  end
			  
			  def not_global?
				if @book_name != "global"
					return true
				else
					return false
				end
			  end
			  
			  def to_string
				puts "Cuaderno: #@book_name"
			  end
			  
			  def self.list
				Dir.entries(BOOKS_PATH)[2..].each do |file|
					book = self.new(file)
					book.to_string
				end
			  end
			  
			  def self.create(name)
				name = name.gsub(/[^0-9A-Za-z.\-_ ]/, '')
				book = self.new(name)
				if book.exist?
					return false
				else
					Dir.mkdir(File.join(BOOKS_PATH,name))
					return true
				end
			  end
			  
			  def self.delete(name)
				book = self.new(name)
				if book.exist? && book.not_global?
					FileUtils.rm_rf(File.join(BOOKS_PATH,name))
					return true
				else
					return false
				end
			  end
			  
			  def self.empty_global
				Dir.entries(File.join(BOOKS_PATH,"global")).each do |file|
				  begin
					File.delete(File.join(BOOKS_PATH,"global",file))
					puts(file + " fue eliminado")
				  rescue
				  end
				end
			  end
			  
			  def self.rename(old_name,new_name)
				new_name = new_name.gsub(/[^0-9A-Za-z.\-_ ]/, '')
				old_name = old_name.gsub(/[^0-9A-Za-z.\-_ ]/, '')
				old_book = self.new(old_name)
				new_book = self.new(new_name)
				if (old_book.exist? && old_book.not_global? && (not new_book.exist?))
					FileUtils.mv(File.join(BOOKS_PATH,old_name),File.join(BOOKS_PATH,new_name))
					return true
				else
					return false
				end
			  end
			  
			  def have_note?(name)
				if @book_notes.include?(name)
					return true
				else
					return false
				end
			  end
			  
			  def notes
				return @book_notes
			  end
			  
			end
		end
	end
end
