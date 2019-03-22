#===============
# User settings
#===============

# Install Paths
PREFIX := /usr/local
INSTALL_DIR := ${PREFIX}/games/amph

# Libraries
USE_LIB_XPM := TRUE

SDL_CONFIG := sdl-config
SDL_HEADERS := $(shell $(SDL_CONFIG) --cflags)
SDL_LIBS := $(shell $(SDL_CONFIG) --libs)

#=======================================================
# You should not have to change anything below

# Useful directories

MYCODEDIR := ./src

# Directories to search for header files

SEARCHDIRS := -I${MYCODEDIR} ${SDL_HEADERS}

# makemake variables

LINKER       := g++
DEPENDFLAGS  := -g  ${SEARCHDIRS}
TOUCHHEADERS := ${MYCODEDIR}/*.h

# C

CC     := gcc
CFLAGS  = ${DEPENDFLAGS}

# C++

CXX      := g++
CXXFLAGS  = ${DEPENDFLAGS} -O9 -funroll-loops -fomit-frame-pointer -ffast-math -Wcast-align

%.o : %.cpp
	${CXX} ${CPPFLAGS} -c $< ${CXXFLAGS} -o $@

%.o : %.cxx
	${CXX} ${CPPFLAGS} -c $< ${CXXFLAGS}

# C preprocessor (C, C++, FORTRAN)
CPPFLAGS = -DINSTALL_DIR="\"${INSTALL_DIR}\""

ifeq ($(USE_LIB_XPM), TRUE)
    CPPFLAGS := $(CPPFLAGS) -D_USE_LIB_XPM 
endif

# Allow unaligned memory access on IA-32
ifeq ($(HOSTTYPE),i386)
	CPPFLAGS := $(CPPFLAGS) -D__OPT_MEM_ACCESS__
endif

# linker

LOADLIBES := -lm $(SDL_LIBS)

ifeq ($(USE_LIB_XPM),TRUE)
    LOADLIBES := $(LOADLIBES) -lXpm -lXt
endif

LDFLAGS   = -L/usr/lib -L/usr/local/lib -L/usr/X11R6/lib 

.PHONY : default
default : amph

.PHONY : install
install: amph
	@./mkinstalldirs ${INSTALL_DIR}
	@install -c ./amph ${INSTALL_DIR}
	@strip ${INSTALL_DIR}/amph
	@ln -s ${INSTALL_DIR}/amph ${PREFIX}/bin/amph

# This is what makemake added


# amph

amph : ./src/Element.o ./src/File.o ./src/Gifload.o ./src/Graphfil.o ./src/Gui.o ./src/Appl.o ./src/Bullet.o ./src/Clut.o ./src/ConstVal.o ./src/Creeper.o ./src/Item.o ./src/Level.o ./src/Main.o ./src/Monster.o ./src/Monstrxx.o ./src/Object.o ./src/ObjInfo.o ./src/Player.o ./src/Pltform.o ./src/Shape.o ./src/ShapeLd.o ./src/Surface.o ./src/Thing.o ./src/Weapon.o ./src/System.o ./src/SndSys.o ./src/SoundList.o
	${LINKER} ${LDFLAGS} -o $@ ${filter-out %.a %.so, $^} ${LOADLIBES}


# target for making everything

.PHONY : all
all: amph


# target for removing all object files

.PHONY : tidy
tidy::
	@${RM} core ./src/Appl.o ./src/Bullet.o ./src/Clut.o ./src/ConstVal.o ./src/Creeper.o ./src/Element.o ./src/File.o ./src/Gifload.o ./src/Graphfil.o ./src/Gui.o ./src/Item.o ./src/Level.o ./src/Main.o ./src/Monster.o ./src/Monstrxx.o ./src/ObjInfo.o ./src/Object.o ./src/Player.o ./src/Pltform.o ./src/Shape.o ./src/ShapeLd.o ./src/SndSys.o ./src/SoundList.o ./src/Surface.o ./src/System.o ./src/Thing.o ./src/Weapon.o

# target for removing all object files

.PHONY : clean
clean:: tidy
	@${RM} amph

# list of all source files

MM_ALL_SOURCES := ./src/Appl.cpp ./src/Bullet.cpp ./src/Clut.cpp ./src/ConstVal.cpp ./src/Creeper.cpp ./src/Element.cpp ./src/File.cpp ./src/Gifload.cpp ./src/Graphfil.cpp ./src/Gui.cpp ./src/Item.cpp ./src/Level.cpp ./src/Main.cpp ./src/Monster.cpp ./src/Monstrxx.cpp ./src/ObjInfo.cpp ./src/Object.cpp ./src/Player.cpp ./src/Pltform.cpp ./src/Shape.cpp ./src/ShapeLd.cpp ./src/SndSys.cpp ./src/SoundList.cpp ./src/Surface.cpp ./src/System.cpp ./src/Thing.cpp ./src/Weapon.cpp


# target for checking a source file

CHECKSYNTAXFILE := ${basename ${filter %${CHECKSTRING}, ${MM_ALL_SOURCES}}}

.PHONY : checksyntax
checksyntax:
  ifneq (${CHECKSYNTAXFILE},)
	@${MAKE} ${addsuffix .o, ${CHECKSYNTAXFILE}}
  else
	@echo No target to make ${CHECKSTRING}
  endif


# target for touching appropriate source files

.PHONY : touch
touch:
	@echo
	@echo Please ignore \"file arguments missing\" errors
	@echo
	@echo   `grep -l ${TOUCHSTRING} ${MM_ALL_SOURCES}`
	@-touch `grep -l ${TOUCHSTRING} ${MM_ALL_SOURCES}`
	@echo
	@echo   `grep -l ${TOUCHSTRING} ${TOUCHHEADERS}`
	@-touch `grep -l ${TOUCHSTRING} ${TOUCHHEADERS}`


# target for calculating dependencies

.PHONY : jdepend
jdepend:
	@makemake -depend Makefile -- ${DEPENDFLAGS} -- ./src/Appl.cpp ./src/Appl.o ./src/Bullet.cpp ./src/Bullet.o ./src/Clut.cpp ./src/Clut.o ./src/ConstVal.cpp ./src/ConstVal.o ./src/Creeper.cpp ./src/Creeper.o ./src/Element.cpp ./src/Element.o ./src/File.cpp ./src/File.o ./src/Gifload.cpp ./src/Gifload.o ./src/Graphfil.cpp ./src/Graphfil.o ./src/Gui.cpp ./src/Gui.o ./src/Item.cpp ./src/Item.o ./src/Level.cpp ./src/Level.o ./src/Main.cpp ./src/Main.o ./src/Monster.cpp ./src/Monster.o ./src/Monstrxx.cpp ./src/Monstrxx.o ./src/ObjInfo.cpp ./src/ObjInfo.o ./src/Object.cpp ./src/Object.o ./src/Player.cpp ./src/Player.o ./src/Pltform.cpp ./src/Pltform.o ./src/Shape.cpp ./src/Shape.o ./src/ShapeLd.cpp ./src/ShapeLd.o ./src/SndSys.cpp ./src/SndSys.o ./src/SoundList.cpp ./src/SoundList.o ./src/Surface.cpp ./src/Surface.o ./src/System.cpp ./src/System.o ./src/Thing.cpp ./src/Thing.o ./src/Weapon.cpp ./src/Weapon.o


# DO NOT DELETE THIS LINE -- makemake depends on it.

./src/Appl.o: ./src/AmpHead.hpp ./src/Appl.hpp ./src/Bullet.hpp ./src/Clut.hpp ./src/ConstVal.hpp ./src/Element.hpp ./src/File.hpp ./src/Graphfil.hpp ./src/Gui.hpp ./src/Level.hpp ./src/Monster.hpp ./src/ObjInfo.hpp ./src/Object.hpp ./src/Player.hpp ./src/Pltform.hpp ./src/Shape.hpp ./src/ShapeLd.hpp ./src/SndSys.hpp ./src/SoundList.hpp ./src/Surface.hpp ./src/System.hpp ./src/Thing.hpp ./src/Weapon.hpp /usr/include/limits.h /usr/include/math.h /usr/include/stdio.h /usr/include/stdlib.h

./src/Bullet.o: ./src/AmpHead.hpp ./src/Appl.hpp ./src/Bullet.hpp ./src/Clut.hpp ./src/ConstVal.hpp ./src/Element.hpp ./src/File.hpp ./src/Graphfil.hpp ./src/Level.hpp ./src/Monster.hpp ./src/ObjInfo.hpp ./src/Object.hpp ./src/Pltform.hpp ./src/Shape.hpp ./src/ShapeLd.hpp ./src/SndSys.hpp ./src/SoundList.hpp ./src/Surface.hpp ./src/System.hpp ./src/Thing.hpp ./src/Weapon.hpp /usr/include/limits.h /usr/include/math.h /usr/include/stdio.h /usr/include/stdlib.h

./src/Clut.o: ./src/AmpHead.hpp ./src/Clut.hpp ./src/ConstVal.hpp ./src/Element.hpp ./src/File.hpp ./src/Graphfil.hpp ./src/Level.hpp ./src/ObjInfo.hpp ./src/Object.hpp ./src/Pltform.hpp ./src/Shape.hpp ./src/ShapeLd.hpp ./src/Surface.hpp ./src/System.hpp ./src/Thing.hpp /usr/include/limits.h /usr/include/math.h /usr/include/stdio.h /usr/include/stdlib.h

./src/ConstVal.o: ./src/AmpHead.hpp ./src/ConstVal.hpp ./src/System.hpp /usr/include/limits.h /usr/include/math.h /usr/include/stdio.h /usr/include/stdlib.h /usr/include/string.h

./src/Creeper.o: ./src/AmpHead.hpp ./src/Creeper.hpp ./src/File.hpp ./src/Graphfil.hpp ./src/Monster.hpp ./src/ObjInfo.hpp ./src/Object.hpp ./src/Shape.hpp ./src/SoundList.hpp ./src/Surface.hpp ./src/System.hpp ./src/Thing.hpp ./src/Weapon.hpp /usr/include/limits.h /usr/include/math.h /usr/include/stdio.h /usr/include/stdlib.h

./src/Element.o: ./src/AmpHead.hpp ./src/Appl.hpp ./src/Bullet.hpp ./src/ConstVal.hpp ./src/Element.hpp ./src/File.hpp ./src/Graphfil.hpp ./src/Gui.hpp ./src/Level.hpp ./src/Monster.hpp ./src/ObjInfo.hpp ./src/Object.hpp ./src/Player.hpp ./src/Pltform.hpp ./src/Shape.hpp ./src/ShapeLd.hpp ./src/SndSys.hpp ./src/SoundList.hpp ./src/Surface.hpp ./src/System.hpp ./src/Thing.hpp ./src/Weapon.hpp /usr/include/limits.h /usr/include/math.h /usr/include/stdio.h /usr/include/stdlib.h

./src/File.o: ./src/AmpHead.hpp ./src/File.hpp ./src/System.hpp /usr/include/limits.h /usr/include/math.h /usr/include/stdio.h /usr/include/stdlib.h

./src/Gifload.o: ./src/AmpHead.hpp ./src/Appl.hpp ./src/Bullet.hpp ./src/ConstVal.hpp ./src/Element.hpp ./src/File.hpp ./src/Graphfil.hpp ./src/Level.hpp ./src/ObjInfo.hpp ./src/Object.hpp ./src/Pltform.hpp ./src/Shape.hpp ./src/ShapeLd.hpp ./src/Surface.hpp ./src/System.hpp ./src/Thing.hpp /usr/include/limits.h /usr/include/math.h /usr/include/stdio.h /usr/include/stdlib.h /usr/include/string.h

./src/Graphfil.o: ./src/AmpHead.hpp ./src/Appl.hpp ./src/Bullet.hpp ./src/ConstVal.hpp ./src/Element.hpp ./src/File.hpp ./src/Graphfil.hpp ./src/Level.hpp ./src/ObjInfo.hpp ./src/Object.hpp ./src/Pltform.hpp ./src/Shape.hpp ./src/ShapeLd.hpp ./src/Surface.hpp ./src/System.hpp ./src/Thing.hpp /usr/include/limits.h /usr/include/math.h /usr/include/stdio.h /usr/include/stdlib.h /usr/include/string.h

./src/Gui.o: ./src/AmpHead.hpp ./src/Appl.hpp ./src/Bullet.hpp ./src/Clut.hpp ./src/ConstVal.hpp ./src/Element.hpp ./src/File.hpp ./src/Graphfil.hpp ./src/Gui.hpp ./src/Level.hpp ./src/Monster.hpp ./src/ObjInfo.hpp ./src/Object.hpp ./src/Player.hpp ./src/Pltform.hpp ./src/Shape.hpp ./src/ShapeLd.hpp ./src/SndSys.hpp ./src/SoundList.hpp ./src/Surface.hpp ./src/System.hpp ./src/Thing.hpp ./src/Weapon.hpp /usr/include/limits.h /usr/include/math.h /usr/include/stdio.h /usr/include/stdlib.h

./src/Item.o: ./src/AmpHead.hpp ./src/Appl.hpp ./src/Bullet.hpp ./src/Clut.hpp ./src/ConstVal.hpp ./src/Element.hpp ./src/File.hpp ./src/Graphfil.hpp ./src/Item.hpp ./src/Level.hpp ./src/ObjInfo.hpp ./src/Object.hpp ./src/Pltform.hpp ./src/Shape.hpp ./src/ShapeLd.hpp ./src/SndSys.hpp ./src/SoundList.hpp ./src/Surface.hpp ./src/System.hpp ./src/Thing.hpp /usr/include/limits.h /usr/include/math.h /usr/include/stdio.h /usr/include/stdlib.h

./src/Level.o: ./src/AmpHead.hpp ./src/Appl.hpp ./src/Bullet.hpp ./src/ConstVal.hpp ./src/Element.hpp ./src/File.hpp ./src/Graphfil.hpp ./src/Gui.hpp ./src/Level.hpp ./src/Monster.hpp ./src/ObjInfo.hpp ./src/Object.hpp ./src/Player.hpp ./src/Pltform.hpp ./src/Shape.hpp ./src/ShapeLd.hpp ./src/SoundList.hpp ./src/Surface.hpp ./src/System.hpp ./src/Thing.hpp ./src/Weapon.hpp /usr/include/limits.h /usr/include/math.h /usr/include/stdio.h /usr/include/stdlib.h /usr/include/time.h

./src/Main.o: ./src/AmpHead.hpp ./src/Appl.hpp ./src/Bullet.hpp ./src/Clut.hpp ./src/ConstVal.hpp ./src/Element.hpp ./src/File.hpp ./src/Graphfil.hpp ./src/Gui.hpp ./src/Level.hpp ./src/Monster.hpp ./src/ObjInfo.hpp ./src/Object.hpp ./src/Player.hpp ./src/Pltform.hpp ./src/Shape.hpp ./src/ShapeLd.hpp ./src/SndSys.hpp ./src/SoundList.hpp ./src/Surface.hpp ./src/System.hpp ./src/Thing.hpp ./src/Weapon.hpp /usr/include/limits.h /usr/include/math.h /usr/include/stdio.h /usr/include/stdlib.h

./src/Monster.o: ./src/AmpHead.hpp ./src/Appl.hpp ./src/Bullet.hpp ./src/ConstVal.hpp ./src/Element.hpp ./src/File.hpp ./src/Graphfil.hpp ./src/Level.hpp ./src/Monster.hpp ./src/ObjInfo.hpp ./src/Object.hpp ./src/Pltform.hpp ./src/Shape.hpp ./src/ShapeLd.hpp ./src/SoundList.hpp ./src/Surface.hpp ./src/System.hpp ./src/Thing.hpp ./src/Weapon.hpp /usr/include/limits.h /usr/include/math.h /usr/include/stdio.h /usr/include/stdlib.h

./src/Monstrxx.o: ./src/AmpHead.hpp ./src/Appl.hpp ./src/Bullet.hpp ./src/ConstVal.hpp ./src/Element.hpp ./src/File.hpp ./src/Graphfil.hpp ./src/Level.hpp ./src/Monster.hpp ./src/Monstrxx.hpp ./src/ObjInfo.hpp ./src/Object.hpp ./src/Pltform.hpp ./src/Shape.hpp ./src/ShapeLd.hpp ./src/SoundList.hpp ./src/Surface.hpp ./src/System.hpp ./src/Thing.hpp ./src/Weapon.hpp /usr/include/limits.h /usr/include/math.h /usr/include/stdio.h /usr/include/stdlib.h

./src/ObjInfo.o: ./src/AmpHead.hpp ./src/Appl.hpp ./src/Bullet.hpp ./src/ConstVal.hpp ./src/Element.hpp ./src/File.hpp ./src/Graphfil.hpp ./src/Item.hpp ./src/Level.hpp ./src/Monster.hpp ./src/Monstrxx.hpp ./src/ObjInfo.hpp ./src/Object.hpp ./src/Player.hpp ./src/Pltform.hpp ./src/Shape.hpp ./src/ShapeDes.hpp ./src/ShapeLd.hpp ./src/SoundList.hpp ./src/Surface.hpp ./src/System.hpp ./src/Thing.hpp ./src/Weapon.hpp /usr/include/limits.h /usr/include/math.h /usr/include/stdio.h /usr/include/stdlib.h

./src/Object.o: ./src/AmpHead.hpp ./src/Appl.hpp ./src/Bullet.hpp ./src/ConstVal.hpp ./src/Element.hpp ./src/File.hpp ./src/Graphfil.hpp ./src/Level.hpp ./src/ObjInfo.hpp ./src/Object.hpp ./src/Pltform.hpp ./src/Shape.hpp ./src/ShapeLd.hpp ./src/Surface.hpp ./src/System.hpp ./src/Thing.hpp /usr/include/limits.h /usr/include/math.h /usr/include/stdio.h /usr/include/stdlib.h

./src/Player.o: ./src/AmpHead.hpp ./src/Appl.hpp ./src/Bullet.hpp ./src/ConstVal.hpp ./src/Element.hpp ./src/File.hpp ./src/Graphfil.hpp ./src/Gui.hpp ./src/Item.hpp ./src/Level.hpp ./src/Monster.hpp ./src/ObjInfo.hpp ./src/Object.hpp ./src/Player.hpp ./src/Pltform.hpp ./src/Shape.hpp ./src/ShapeDes.hpp ./src/ShapeLd.hpp ./src/SndSys.hpp ./src/SoundList.hpp ./src/Surface.hpp ./src/System.hpp ./src/Thing.hpp ./src/Weapon.hpp /usr/include/limits.h /usr/include/math.h /usr/include/stdio.h /usr/include/stdlib.h

./src/Pltform.o: ./src/AmpHead.hpp ./src/Appl.hpp ./src/Bullet.hpp ./src/ConstVal.hpp ./src/Element.hpp ./src/File.hpp ./src/Graphfil.hpp ./src/Level.hpp ./src/Monster.hpp ./src/ObjInfo.hpp ./src/Object.hpp ./src/Player.hpp ./src/Pltform.hpp ./src/Shape.hpp ./src/ShapeLd.hpp ./src/SndSys.hpp ./src/SoundList.hpp ./src/Surface.hpp ./src/System.hpp ./src/Thing.hpp ./src/Weapon.hpp /usr/include/limits.h /usr/include/math.h /usr/include/stdio.h /usr/include/stdlib.h

./src/Shape.o: ./src/AmpHead.hpp ./src/Appl.hpp ./src/Bullet.hpp ./src/Clut.hpp ./src/ConstVal.hpp ./src/Element.hpp ./src/File.hpp ./src/Graphfil.hpp ./src/Level.hpp ./src/ObjInfo.hpp ./src/Object.hpp ./src/Pltform.hpp ./src/Shape.hpp ./src/ShapeLd.hpp ./src/Surface.hpp ./src/System.hpp ./src/Thing.hpp /usr/include/limits.h /usr/include/math.h /usr/include/stdio.h /usr/include/stdlib.h

./src/ShapeLd.o: ./src/AmpHead.hpp ./src/Appl.hpp ./src/Bullet.hpp ./src/Clut.hpp ./src/ConstVal.hpp ./src/Element.hpp ./src/File.hpp ./src/Graphfil.hpp ./src/Level.hpp ./src/ObjInfo.hpp ./src/Object.hpp ./src/Pltform.hpp ./src/Shape.hpp ./src/ShapeDes.hpp ./src/ShapeLd.hpp ./src/Surface.hpp ./src/System.hpp ./src/Thing.hpp /usr/include/limits.h /usr/include/math.h /usr/include/stdio.h /usr/include/stdlib.h

./src/SndSys.o: ./src/AmpHead.hpp ./src/ConstVal.hpp ./src/Element.hpp ./src/File.hpp ./src/Graphfil.hpp ./src/Level.hpp ./src/ObjInfo.hpp ./src/Object.hpp ./src/Pltform.hpp ./src/Shape.hpp ./src/ShapeLd.hpp ./src/SndSys.hpp ./src/SoundList.hpp ./src/Surface.hpp ./src/System.hpp ./src/Thing.hpp /usr/include/limits.h /usr/include/math.h /usr/include/stdio.h /usr/include/stdlib.h

./src/SoundList.o: ./src/AmpHead.hpp ./src/SoundList.hpp ./src/System.hpp /usr/include/limits.h /usr/include/math.h /usr/include/stdio.h /usr/include/stdlib.h

./src/Surface.o: ./src/AmpHead.hpp ./src/Clut.hpp ./src/ConstVal.hpp ./src/Graphfil.hpp ./src/Shape.hpp ./src/ShapeLd.hpp ./src/Surface.hpp ./src/System.hpp /usr/include/limits.h /usr/include/math.h /usr/include/stdio.h /usr/include/stdlib.h

./src/System.o: ./src/AmpHead.hpp ./src/Graphfil.hpp ./src/System.hpp /usr/include/X11/xpm.h /usr/include/fcntl.h /usr/include/limits.h /usr/include/math.h /usr/include/stdio.h /usr/include/stdlib.h /usr/include/string.h /usr/include/sys/stat.h /usr/include/sys/time.h /usr/include/sys/types.h /usr/include/unistd.h

./src/Thing.o: ./src/AmpHead.hpp ./src/Appl.hpp ./src/Bullet.hpp ./src/ConstVal.hpp ./src/Element.hpp ./src/File.hpp ./src/Graphfil.hpp ./src/Level.hpp ./src/ObjInfo.hpp ./src/Object.hpp ./src/Pltform.hpp ./src/Shape.hpp ./src/ShapeLd.hpp ./src/Surface.hpp ./src/System.hpp ./src/Thing.hpp /usr/include/limits.h /usr/include/math.h /usr/include/stdio.h /usr/include/stdlib.h

./src/Weapon.o: ./src/AmpHead.hpp ./src/Appl.hpp ./src/Bullet.hpp ./src/ConstVal.hpp ./src/Element.hpp ./src/File.hpp ./src/Graphfil.hpp ./src/Level.hpp ./src/ObjInfo.hpp ./src/Object.hpp ./src/Pltform.hpp ./src/Shape.hpp ./src/ShapeLd.hpp ./src/SndSys.hpp ./src/SoundList.hpp ./src/Surface.hpp ./src/System.hpp ./src/Thing.hpp ./src/Weapon.hpp /usr/include/limits.h /usr/include/math.h /usr/include/stdio.h /usr/include/stdlib.h

