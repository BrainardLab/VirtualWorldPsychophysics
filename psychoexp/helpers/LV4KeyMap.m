classdef LV4KeyMap
	properties
		Key
	end
	
	methods
		function obj = LV4KeyMap(keyVal)
			obj.Key = keyVal;
		end
	end
	
	enumeration
		Left ('d')
		Right ('k')
	end
end
