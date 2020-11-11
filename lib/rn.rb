module RN
  BOOKS_PATH = File.join(Dir.pwd,".my_rns")
	  
  autoload :VERSION, 'rn/version'
  autoload :Commands, 'rn/commands'

  # Agregar aquí cualquier autoload que sea necesario para que se cargue las clases y
  # módulos del modelo de datos.
  # Por ejemplo:
  # autoload :Note, 'rn/note'
end
