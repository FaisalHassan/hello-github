#  Makefile
#  
#  Copyright 2016 Faisal Hassan <faisal.hassan@globaledgesoft.com>
#  
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#  
#  

default: all

OUTDIR   = $(shell pwd)
LIBDIR   = $(shell pwd)
TARGET   = $(OUTDIR)/hello-github.out
DEMO_LIB = $(LIBDIR)/hello-github.a

COPTS := -g2 -Os -Wall -Werror
DEFINES := \
	-DHELLO_GITHUB_DBG=1

INCLUDES := \
	-I. \
	-I./include

CFLAGS = $(COPTS) $(DEFINES) $(INCLUDES)
CFLAGS += -MMD

CC = gcc
AR = ar
RM = rm -f

CSRCS := $(wildcard *.c)
OBJS := $(CSRCS:%.c=%.o)
DEPS := $(CSRCS:%.c=%.d)
LIBS := $(LIBDIR)/hello-github.a


LDFLAGS = -g $(LIBS)


ifneq ($(MAKECMDGOALS),clean)
  ifneq ($(MAKECMDGOALS),echovars)
    ifdef DEPS
      sinclude $(DEPS)
    endif
  endif
endif

$(DEMO_LIB): $(OBJS)
	@mkdir -p $(LIBDIR)
	$(AR) ru $@ $^

$(TARGET): $(LIBS) $(LDS)
	@mkdir -p $(OUTDIR)
	$(CC) $(LDFLAGS) -o $@

all: $(OBJS) $(DEMO_LIB) $(TARGET)

clean:
	$(foreach d, $(SUBDIRS), make -C $(d) clean;)
	$(RM) *.o
	$(RM) *.d
	$(RM) $(DEMO_LIB)
	$(RM) $(TARGET)


echovars:
	@echo pwd=`pwd`
	@echo TARGET = $(TARGET)
	@echo TARGET = $(TARGET)
	@echo OUTDIR = $(OUTDIR)
	@echo DEMO_LIB = $(DEMO_LIB)
	@echo SUBDIRS = $(SUBDIRS)
	@echo CSRCS = $(CSRCS)
	@echo OBJS = $(OBJS)
	@echo DEPS = $(DEPS)
	@echo LIBS = $(LIBS)
	@echo CC = $(CC) at `which $(CC)`
	@echo CFLAGS = $(CFLAGS)
	@echo LDFLAGS = $(LDFLAGS)
