RN -- V1.2.0

Comandos:

#Parten de $ruby bin/rn

-Version:
	#version	//aliases ['v','-v','--version']
		imprime la version del programa

-Config:
	#save_folder [**arg]
		##Proximamente
-Books: 
books //aliases['b']
El libro por defecto se llama global y este no puede ser eliminado ni modificado
	#create [**arg]
		-Recive como argumento un titulo de libro y lo crea
		-Debe ser un nombre que este disponible
		example [
        		'"My book" # Creates a new book named "My book"',
        		'Memoires  # Creates a new book named "Memoires"'
        		]
	#delete [**arg]
		-Recive como argumento un titulo de un libro, si existe es
		eliminado
		-Si recive 
		example [
	          '--global  # Deletes all notes from the global book',
	          '"My book" # Deletes a book named "My book" and all of its notes',
	          'Memoires  # Deletes a book named "Memoires" and all of its notes'
	        ]
	#list
		-Lista todos los libros
		example [
                    # Lists every available book'
        	]
	#rename [**arg]
		-Recive un nombre viejo(debe existir) y nombre nuevo (disponible)
		para una libro
		example [
         	 '"My book" "Our book"         # Renames the book "My book" to "Our book"',
         	 'Memoires Memories            # Renames the book "Memoires" to "Memories"',
         	 '"TODO - Name this book" Wiki # Renames the book "TODO - Name this book" to "Wiki"'
        	]
-Notes: 
notes //aliases['n']
El ingreso de datos se termina ingresando una linea con solo '%END%'
	#create [**arg]
		-Recibe el nombre de una nota y opcionalmente el libro al que
		pertenesca, ambas deben ser validas y crea la nota
		example [
  		   'todo                        # Creates a note titled "todo" in the global book',
    		   '"New note" --book "My book" # Creates a note titled "New note" in the book "My book"',
   		   'thoughts --book Memoires    # Creates a note titled "thoughts" in the book "Memoires"'
   		]
	#delete [**arg]
		-Recibe el nombre de una nota y opcionalmente el libro al que
		pertenece, ambas deben ser validas y elimina la nota
		example [
   		       'todo                        # Deletes a note titled "todo" from the global book',
   		       '"New note" --book "My book" # Deletes a note titled "New note" from the book "My book"',
        	       'thoughts --book Memoires    # Deletes a note titled "thoughts" from the book "Memoires"'
  	        ]	
	#retitle [**arg]
		--Recibe nombre viejo y nuevo de una nota y opcionalmente el libro al 
		que pertenece, ambas deben ser validas, y actualiza el nombre
		example [
        	  'todo TODO                                 # Changes the title of the note titled "todo" from the global book to "TODO"',
     		  '"New note" "Just a note" --book "My book" # Changes the title of the note titled "New note" from the book "My book" to "Just a note"',
          	  'thoughts thinking --book Memoires         # Changes the title of the note titled "thoughts" from the book "Memoires" to "thinking"'
        	]
	#edit [**arg]
		-Recibe el nombre de una nota y opcionalmente el libro al que
		pertenece, ambas deben ser validas, y edita la nota
		example [
	          'todo                        # Edits a note titled "todo" from the global book',
	          '"New note" --book "My book" # Edits a note titled "New note" from the book "My book"',
	          'thoughts --book Memoires    # Edits a note titled "thoughts" from the book "Memoires"'
		]
	#list[**arg]
		-Puede recibir nombre de un libro o el argumento del libro global, y
		lista sus notas, listando todas si no hay argumentos
		example [
	          '                 # Lists notes from all books (including the global book)',
          	  '--global         # Lists notes from the global book',
          	  '--book "My book" # Lists notes from the book named "My book"',
          	  '--book Memoires  # Lists notes from the book named "Memoires"'
        	]
	#show[**arg]
		-Recibe el nombre de una nota y opcionalmente un libro al que
		pertenece, estos deben ser validos y muestra el contenido de la nota
		example [
         	 'todo                        # Shows a note titled "todo" from the global book',
         	 '"New note" --book "My book" # Shows a note titled "New note" from the book "My book"',
         	 'thoughts --book Memoires    # Shows a note titled "thoughts" from the book "Memoires"'
        	]
-Export: 
export //aliases['e']
Utiliza gema redcarpet para convertir a html texto formateado en Markdown
	#to_html [**arg]
		-Puede recibir un titulo de libro y uno de nota, exportando a html
		las notas correspondientes, todas en caso de no haber parametros
	example [
  	  '								#Export all notes to HTML'
	  '--book libro1					#Export all notes in "libro1" to HTML'
	  '--title titulo1				#Export note "titulo1" from global to HTML'
	  '--book libro1 --title titulo1	#Export note "titulo1" from book "libro1" to HTML'
	]
	#to_pdf [**arg]
		##proximamente
