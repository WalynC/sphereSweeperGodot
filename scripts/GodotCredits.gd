extends RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	#https://godotforums.org/d/34833-complying-with-licenses-why-only-freetype-enet-and-mbed-require-attribution/10
	var license_text = "\n\n\nGODOT LICENSE\n\n" + Engine.get_license_text()

	var components = Engine.get_copyright_info()
	license_text += "\n\n\nTHIRD PARTY LIBRARIES\n\nWe are required to display license text for the following libraries included in the Godot Engine:"
	var license_list = {}
	for component in components:
		var name = component.name
		license_text += "\n" + name + "\n"
		for part in component.parts:
			license_list[part.license] = true
			license_text += "  License: " + part.license + "\n"
			for line in part.copyright:
				license_text += "  Copyright " + line + "\n"

	var licenses = Engine.get_license_info()
	for k in licenses:
		if license_list.has(k):
			license_text += "\n\n\nLICENSE: " + k + "\n\n" + licenses[k]
	
	text = license_text
