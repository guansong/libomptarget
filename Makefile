##===- Makefile --------------------------------------------*- Makefile -*-===##
# 
#                     The LLVM Compiler Infrastructure
#
# This file is distributed under the University of Illinois Open Source
# License. See LICENSE.TXT for details.
# 
##===----------------------------------------------------------------------===##
#
# Build a preleminary version of libomptarget.so
#
##===----------------------------------------------------------------------===##

CPP_FILES := $(wildcard src/*.cpp)
INC_FILES := $(wildcard src/*.h)
OBJ_FILES := $(subst src/,obj/,$(CPP_FILES:.cpp=.o))

CC := g++
CFLAGS := -c -fPIC -I src/ -std=c++11 -Wall
LDFLAGS := -shared -lelf -ldl

ifdef OMPTARGET_DEBUG
CFLAGS += -g -DOMPTARGET_DEBUG
endif

all : lib/libomptarget.so build_rtls

lib/libomptarget.so : $(OBJ_FILES)
	@ mkdir -p lib
	$(CC) $(LDFLAGS) -o $@ $(OBJ_FILES)

obj/%.o: src/%.cpp $(INC_FILES)
	@ mkdir -p obj
	$(CC) $(CFLAGS) $< -o $@

clean: clean_rtls
	rm -rf obj
	rm -rf lib

build_rtls:
	make -C RTLs

clean_rtls:
	make -C RTLs clean

tag:
	find . -type d -a ! \( -type d -empty \) -a ! \( -name \.git -prune \) -a ! \( -name lib -prune \) -a ! \( -name obj -prune \) -exec sh -c "cd \"{}\"; if test ! -f .keep; then ctags --extra=+q --fields=+ani --C++-kinds=+p *; fi" \;
	ctags --file-scope=no -R

cleantag:
	find . -type d -a ! \( -type d -empty \) -a ! \( -name \.git -prune \) -a ! \( -name lib -prune \) -a ! \( -name obj -prune \) -exec sh -c "cd \"{}\"; rm -f tags" \;

