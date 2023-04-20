class_name FileManager extends Node

# This function will save a variable to a file
# @param path: The path of the file
# @param variable: The variable to save
static func save(path, variable):
	# Open the file for writing
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		# Return false if the file can't be opened
		return false
	# Convert the variable to a string
	var strvar = var_to_str(variable)
	# Write the string to the file
	file.store_string(strvar)
	# Return true if the file was successfully written
	return true

static func load(path):
	# Open the file for reading.
	var file = FileAccess.open(path, FileAccess.READ)
	# If the file could not be opened, return null.
	if file == null:
		return null
	# Read the file contents into a string.
	var strvar = file.get_as_text()
	# Convert the string into a variable.
	var varialbe = str_to_var(strvar)
	# Return the variable.
	return varialbe


# get_files_in_dir: Returns an array of the file paths in a directory.
# @param path: The path to the directory to search.
# @param extension: Only return files with this extension.
# @param ignore_filenames: An array of filenames to ignore.
# @param recursive: Whether or not to search sub-directories.
# @param include_dir: Whether or not to include the directory in the file paths returned.
# @return An array of file paths.
static func get_files_in_dir(path:String, extension := '',ignore_filenames:Array[String]=[] ,recursive := false, include_dir := true):
	var dir = DirAccess.open(path) # Open the directory.
	var file_paths :Array[String]= []
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir(): # If the current file is a directory.
				if recursive:
					var sub_paths = get_files_in_dir(path + "/" + file_name, extension, ignore_filenames, recursive, include_dir)
					file_paths.append_array(sub_paths)
			else: # If the current file is not a directory.
				if file_name.ends_with(extension): # If the file has the specified extension.
					if ignore_filenames.find(file_name) == -1: # If the file is not in the ignore list.
						if include_dir:
							file_paths.append(path+'/'+file_name)
						else:
							file_paths.append(file_name)

			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		printerr("An error occurred when trying to access the path.")
	return file_paths
