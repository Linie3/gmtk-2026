extends Node

var instruction_page: bool = true

func load_directory(path: String, extension: String, type_hint: String) -> Dictionary[StringName, Resource]:
	var resources: Dictionary[StringName, Resource] = {}
	var dir := DirAccess.open(path)
	
	if not dir:
		push_error("Failed to open directory at path: %s" % path)
		return resources
	
	for subfolder_name in dir.get_directories():
		var scene_path := path.path_join(subfolder_name).path_join(subfolder_name + "." + extension)
		
		if ResourceLoader.exists(scene_path, type_hint):
			var loaded_resource := ResourceLoader.load(scene_path, type_hint, ResourceLoader.CACHE_MODE_IGNORE)
			resources[subfolder_name] = loaded_resource
		else:
			push_warning("No matching resource of type '%s' found for folder '%s' at '%s'" % [type_hint, subfolder_name, scene_path])
			
	return resources
