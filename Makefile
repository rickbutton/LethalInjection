SCRIPTING_DIR=addons/sourcemod/scripting
COMPILER=$(SCRIPTING_DIR)/spcomp
OUTPUT_DIR=addons/sourcemod/plugins

$(OUTPUT_DIR)/lethal.smx: $(SCRIPTING_DIR)/lethal.sp
	$(COMPILER) $(SCRIPTING_DIR)/lethal.sp -o$(OUTPUT_DIR)/lethal.smx

all: ($OUTPUT_DIR)/lethal.smx
