class_name SaveManager

static var pathString := "user://saves/"
static var fileName := "save.json"
static var saveData := SaveData.new()

static func verify_save_directory(path : String):
	DirAccess.make_dir_absolute(path)

static func save_data():
	verify_save_directory(pathString)
	var path = pathString + fileName
	var file = FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE, "walyn is a winner")
	if file == null:
		print("err")
		print(FileAccess.get_open_error())
		return
	
	var data = JSON.stringify(saveData.ToData())
	file.store_string(data)
	file.close()

static func load_data():
	verify_save_directory(pathString)
	var path = pathString + fileName
	if FileAccess.file_exists(path):
		var file = FileAccess.open_encrypted_with_pass(path, FileAccess.READ, "walyn is a winner")
		if (file == null):
			print(FileAccess.get_open_error())
			return
		var content = file.get_as_text()
		file.close()
		var data = JSON.parse_string(content)
		if data == null:
			printerr("cannot parse %s as json_string: (%s)"%[path, content])
			return
		else:
			saveData.LoadFromData(data)
	else:
		printerr("cannot open non-existent file at %s" %[path])
