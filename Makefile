# Makefile - create STL files from OpenSCAD source
# Andrew Ho (andrew@zeuscat.com)

ifeq ($(shell uname), Darwin)
  OPENSCAD = /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD
else
  OPENSCAD = openscad
endif

TARGETS = mandrel.stl

all: $(TARGETS)

mandrel.stl: mandrel.scad
	$(OPENSCAD) -o mandrel.stl mandrel.scad

clean:
	@rm -f $(TARGETS)
