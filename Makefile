#
# Generated by the NeXT Project Builder.
#
# NOTE: Do NOT change this file -- Project Builder maintains it.
#
# Put all of your customizations in files called Makefile.preamble
# and Makefile.postamble (both optional), and Makefile will include them.
#

NAME = BoxV

PROJECTVERSION = 1.1
LANGUAGE = English

LOCAL_RESOURCES = Info.rtf Localizable.strings

GLOBAL_RESOURCES = Default.table Display.modes

TOOLS = BoxV_reloc.tproj

OTHERSRCS = Makefile Makefile.postamble Makefile.preamble

MAKEFILEDIR = /NextDeveloper/Makefiles/app
MAKEFILE = bundle.make
INSTALLDIR = /usr/Devices
INSTALLFLAGS = -c -s -m 755
SOURCEMODE = 444

BUNDLE_EXTENSION = config




-include Makefile.preamble

include $(MAKEFILEDIR)/$(MAKEFILE)

-include Makefile.postamble

-include Makefile.dependencies