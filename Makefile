ifndef CXXFLAGS
    CXXFLAGS=-O2 -DNDEBUG -Wall
endif

ifndef CXX
    CXX=g++
endif

ifndef PREFIX
    PREFIX=/usr
endif

BIN=$(DESTDIR)$(PREFIX)/bin

# For 'make man': sudo apt-get install xsltproc docbook-xsl docbook-xml on Linux
DB2MAN=/usr/share/sgml/docbook/stylesheet/xsl/nwalsh/manpages/docbook.xsl
XP=xsltproc -''-nonet -''-param man.charmap.use.subset "0"
MAN_SOURCE=man/cppcheck.1.xml


###### Object Files

LIBOBJ =     lib/checkautovariables.o \
              lib/checkbufferoverrun.o \
              lib/checkclass.o \
              lib/checkexceptionsafety.o \
              lib/checkmemoryleak.o \
              lib/checknullpointer.o \
              lib/checkobsoletefunctions.o \
              lib/checkother.o \
              lib/checkpostfixoperator.o \
              lib/checkstl.o \
              lib/checkuninitvar.o \
              lib/checkunusedfunctions.o \
              lib/cppcheck.o \
              lib/errorlogger.o \
              lib/executionpath.o \
              lib/filelister.o \
              lib/filelister_unix.o \
              lib/filelister_win32.o \
              lib/mathlib.o \
              lib/path.o \
              lib/preprocessor.o \
              lib/settings.o \
              lib/symboldatabase.o \
              lib/timer.o \
              lib/token.o \
              lib/tokenize.o

CLIOBJ =     cli/cmdlineparser.o \
              cli/cppcheckexecutor.o \
              cli/main.o \
              cli/threadexecutor.o

TESTOBJ =     test/options.o \
              test/testautovariables.o \
              test/testbufferoverrun.o \
              test/testcharvar.o \
              test/testclass.o \
              test/testcmdlineparser.o \
              test/testconstructors.o \
              test/testcppcheck.o \
              test/testdivision.o \
              test/testerrorlogger.o \
              test/testexceptionsafety.o \
              test/testincompletestatement.o \
              test/testmathlib.o \
              test/testmemleak.o \
              test/testnullpointer.o \
              test/testobsoletefunctions.o \
              test/testoptions.o \
              test/testother.o \
              test/testpath.o \
              test/testpostfixoperator.o \
              test/testpreprocessor.o \
              test/testrunner.o \
              test/testsettings.o \
              test/testsimplifytokens.o \
              test/teststl.o \
              test/testsuite.o \
              test/testthreadexecutor.o \
              test/testtoken.o \
              test/testtokenize.o \
              test/testuninitvar.o \
              test/testunusedfunctions.o \
              test/testunusedprivfunc.o \
              test/testunusedvar.o \
              test/tinyxml/tinystr.o \
              test/tinyxml/tinyxml.o \
              test/tinyxml/tinyxmlerror.o \
              test/tinyxml/tinyxmlparser.o


###### Targets

cppcheck:	$(LIBOBJ)	$(CLIOBJ)
	$(CXX) $(CXXFLAGS) -o cppcheck $(CLIOBJ) $(LIBOBJ) $(LDFLAGS)

all:	cppcheck	testrunner

testrunner:	$(TESTOBJ)	$(LIBOBJ)	cli/threadexecutor.o	cli/cmdlineparser.o	cli/cppcheckexecutor.o
	$(CXX) $(CXXFLAGS) -o testrunner $(TESTOBJ) $(LIBOBJ) cli/threadexecutor.o cli/cmdlineparser.o cli/cppcheckexecutor.o $(LDFLAGS)

test:	all
	./testrunner

check:	all
	./testrunner -g -q

dmake:	tools/dmake.cpp
	$(CXX) -o dmake tools/dmake.cpp lib/filelister*.cpp

clean:
	rm -f lib/*.o cli/*.o test/*.o testrunner cppcheck cppcheck.1

man:	man/cppcheck.1

man/cppcheck.1:	$(MAN_SOURCE)

	$(XP) $(DB2MAN) $(MAN_SOURCE)

tags:
	ctags -R --exclude=doxyoutput .

install:	cppcheck
	install -d ${BIN}
	install cppcheck ${BIN}


###### Build

lib/checkautovariables.o: lib/checkautovariables.cpp lib/checkautovariables.h lib/check.h lib/token.h lib/tokenize.h lib/settings.h lib/errorlogger.h
	$(CXX) $(CXXFLAGS) -Ilib -c -o lib/checkautovariables.o lib/checkautovariables.cpp

lib/checkbufferoverrun.o: lib/checkbufferoverrun.cpp lib/checkbufferoverrun.h lib/check.h lib/token.h lib/tokenize.h lib/settings.h lib/errorlogger.h lib/mathlib.h lib/executionpath.h
	$(CXX) $(CXXFLAGS) -Ilib -c -o lib/checkbufferoverrun.o lib/checkbufferoverrun.cpp

lib/checkclass.o: lib/checkclass.cpp lib/checkclass.h lib/check.h lib/token.h lib/tokenize.h lib/settings.h lib/errorlogger.h lib/symboldatabase.h
	$(CXX) $(CXXFLAGS) -Ilib -c -o lib/checkclass.o lib/checkclass.cpp

lib/checkexceptionsafety.o: lib/checkexceptionsafety.cpp lib/checkexceptionsafety.h lib/check.h lib/token.h lib/tokenize.h lib/settings.h lib/errorlogger.h
	$(CXX) $(CXXFLAGS) -Ilib -c -o lib/checkexceptionsafety.o lib/checkexceptionsafety.cpp

lib/checkmemoryleak.o: lib/checkmemoryleak.cpp lib/checkmemoryleak.h lib/check.h lib/token.h lib/tokenize.h lib/settings.h lib/errorlogger.h lib/symboldatabase.h lib/mathlib.h lib/executionpath.h lib/checkuninitvar.h
	$(CXX) $(CXXFLAGS) -Ilib -c -o lib/checkmemoryleak.o lib/checkmemoryleak.cpp

lib/checknullpointer.o: lib/checknullpointer.cpp lib/checknullpointer.h lib/check.h lib/token.h lib/tokenize.h lib/settings.h lib/errorlogger.h lib/executionpath.h lib/mathlib.h
	$(CXX) $(CXXFLAGS) -Ilib -c -o lib/checknullpointer.o lib/checknullpointer.cpp

lib/checkobsoletefunctions.o: lib/checkobsoletefunctions.cpp lib/checkobsoletefunctions.h lib/check.h lib/token.h lib/tokenize.h lib/settings.h lib/errorlogger.h
	$(CXX) $(CXXFLAGS) -Ilib -c -o lib/checkobsoletefunctions.o lib/checkobsoletefunctions.cpp

lib/checkother.o: lib/checkother.cpp lib/checkother.h lib/check.h lib/token.h lib/tokenize.h lib/settings.h lib/errorlogger.h lib/mathlib.h
	$(CXX) $(CXXFLAGS) -Ilib -c -o lib/checkother.o lib/checkother.cpp

lib/checkpostfixoperator.o: lib/checkpostfixoperator.cpp lib/checkpostfixoperator.h lib/check.h lib/token.h lib/tokenize.h lib/settings.h lib/errorlogger.h
	$(CXX) $(CXXFLAGS) -Ilib -c -o lib/checkpostfixoperator.o lib/checkpostfixoperator.cpp

lib/checkstl.o: lib/checkstl.cpp lib/checkstl.h lib/check.h lib/token.h lib/tokenize.h lib/settings.h lib/errorlogger.h lib/executionpath.h
	$(CXX) $(CXXFLAGS) -Ilib -c -o lib/checkstl.o lib/checkstl.cpp

lib/checkuninitvar.o: lib/checkuninitvar.cpp lib/checkuninitvar.h lib/check.h lib/token.h lib/tokenize.h lib/settings.h lib/errorlogger.h lib/mathlib.h lib/executionpath.h lib/checknullpointer.h
	$(CXX) $(CXXFLAGS) -Ilib -c -o lib/checkuninitvar.o lib/checkuninitvar.cpp

lib/checkunusedfunctions.o: lib/checkunusedfunctions.cpp lib/checkunusedfunctions.h lib/check.h lib/token.h lib/tokenize.h lib/settings.h lib/errorlogger.h
	$(CXX) $(CXXFLAGS) -Ilib -c -o lib/checkunusedfunctions.o lib/checkunusedfunctions.cpp

lib/cppcheck.o: lib/cppcheck.cpp lib/cppcheck.h lib/settings.h lib/errorlogger.h lib/checkunusedfunctions.h lib/check.h lib/token.h lib/tokenize.h lib/preprocessor.h lib/filelister.h lib/path.h lib/timer.h
	$(CXX) $(CXXFLAGS) -Ilib -c -o lib/cppcheck.o lib/cppcheck.cpp

lib/errorlogger.o: lib/errorlogger.cpp lib/errorlogger.h lib/path.h
	$(CXX) $(CXXFLAGS) -Ilib -c -o lib/errorlogger.o lib/errorlogger.cpp

lib/executionpath.o: lib/executionpath.cpp lib/executionpath.h lib/token.h
	$(CXX) $(CXXFLAGS) -Ilib -c -o lib/executionpath.o lib/executionpath.cpp

lib/filelister.o: lib/filelister.cpp lib/filelister.h lib/filelister_win32.h lib/filelister_unix.h
	$(CXX) $(CXXFLAGS) -Ilib -c -o lib/filelister.o lib/filelister.cpp

lib/filelister_unix.o: lib/filelister_unix.cpp lib/filelister.h lib/filelister_unix.h
	$(CXX) $(CXXFLAGS) -Ilib -c -o lib/filelister_unix.o lib/filelister_unix.cpp

lib/filelister_win32.o: lib/filelister_win32.cpp lib/filelister.h lib/filelister_win32.h lib/path.h
	$(CXX) $(CXXFLAGS) -Ilib -c -o lib/filelister_win32.o lib/filelister_win32.cpp

lib/mathlib.o: lib/mathlib.cpp lib/mathlib.h lib/tokenize.h
	$(CXX) $(CXXFLAGS) -Ilib -c -o lib/mathlib.o lib/mathlib.cpp

lib/path.o: lib/path.cpp lib/path.h
	$(CXX) $(CXXFLAGS) -Ilib -c -o lib/path.o lib/path.cpp

lib/preprocessor.o: lib/preprocessor.cpp lib/preprocessor.h lib/tokenize.h lib/token.h lib/path.h lib/errorlogger.h lib/settings.h
	$(CXX) $(CXXFLAGS) -Ilib -c -o lib/preprocessor.o lib/preprocessor.cpp

lib/settings.o: lib/settings.cpp lib/settings.h
	$(CXX) $(CXXFLAGS) -Ilib -c -o lib/settings.o lib/settings.cpp

lib/symboldatabase.o: lib/symboldatabase.cpp lib/symboldatabase.h lib/tokenize.h lib/token.h lib/settings.h lib/errorlogger.h lib/check.h
	$(CXX) $(CXXFLAGS) -Ilib -c -o lib/symboldatabase.o lib/symboldatabase.cpp

lib/timer.o: lib/timer.cpp lib/timer.h
	$(CXX) $(CXXFLAGS) -Ilib -c -o lib/timer.o lib/timer.cpp

lib/token.o: lib/token.cpp lib/token.h lib/errorlogger.h lib/check.h lib/tokenize.h lib/settings.h
	$(CXX) $(CXXFLAGS) -Ilib -c -o lib/token.o lib/token.cpp

lib/tokenize.o: lib/tokenize.cpp lib/tokenize.h lib/token.h lib/filelister.h lib/mathlib.h lib/settings.h lib/errorlogger.h lib/check.h lib/path.h lib/symboldatabase.h
	$(CXX) $(CXXFLAGS) -Ilib -c -o lib/tokenize.o lib/tokenize.cpp

cli/cmdlineparser.o: cli/cmdlineparser.cpp lib/cppcheck.h lib/settings.h lib/errorlogger.h lib/checkunusedfunctions.h lib/check.h lib/token.h lib/tokenize.h lib/timer.h cli/cmdlineparser.h
	$(CXX) $(CXXFLAGS) -Ilib -c -o cli/cmdlineparser.o cli/cmdlineparser.cpp

cli/cppcheckexecutor.o: cli/cppcheckexecutor.cpp cli/cppcheckexecutor.h lib/errorlogger.h lib/settings.h lib/cppcheck.h lib/checkunusedfunctions.h lib/check.h lib/token.h lib/tokenize.h cli/threadexecutor.h cli/cmdlineparser.h lib/filelister.h
	$(CXX) $(CXXFLAGS) -Ilib -c -o cli/cppcheckexecutor.o cli/cppcheckexecutor.cpp

cli/main.o: cli/main.cpp cli/cppcheckexecutor.h lib/errorlogger.h lib/settings.h
	$(CXX) $(CXXFLAGS) -Ilib -c -o cli/main.o cli/main.cpp

cli/threadexecutor.o: cli/threadexecutor.cpp cli/threadexecutor.h lib/settings.h lib/errorlogger.h lib/cppcheck.h lib/checkunusedfunctions.h lib/check.h lib/token.h lib/tokenize.h
	$(CXX) $(CXXFLAGS) -Ilib -c -o cli/threadexecutor.o cli/threadexecutor.cpp

test/options.o: test/options.cpp test/options.h
	$(CXX) $(CXXFLAGS) -Ilib -Icli -c -o test/options.o test/options.cpp

test/testautovariables.o: test/testautovariables.cpp lib/tokenize.h lib/checkautovariables.h lib/check.h lib/token.h lib/settings.h lib/errorlogger.h test/testsuite.h test/redirect.h
	$(CXX) $(CXXFLAGS) -Ilib -Icli -c -o test/testautovariables.o test/testautovariables.cpp

test/testbufferoverrun.o: test/testbufferoverrun.cpp lib/tokenize.h lib/checkbufferoverrun.h lib/check.h lib/token.h lib/settings.h lib/errorlogger.h lib/mathlib.h test/testsuite.h test/redirect.h
	$(CXX) $(CXXFLAGS) -Ilib -Icli -c -o test/testbufferoverrun.o test/testbufferoverrun.cpp

test/testcharvar.o: test/testcharvar.cpp lib/tokenize.h lib/checkother.h lib/check.h lib/token.h lib/settings.h lib/errorlogger.h test/testsuite.h test/redirect.h
	$(CXX) $(CXXFLAGS) -Ilib -Icli -c -o test/testcharvar.o test/testcharvar.cpp

test/testclass.o: test/testclass.cpp lib/tokenize.h lib/checkclass.h lib/check.h lib/token.h lib/settings.h lib/errorlogger.h lib/symboldatabase.h test/testsuite.h test/redirect.h
	$(CXX) $(CXXFLAGS) -Ilib -Icli -c -o test/testclass.o test/testclass.cpp

test/testcmdlineparser.o: test/testcmdlineparser.cpp test/testsuite.h lib/errorlogger.h test/redirect.h lib/settings.h
	$(CXX) $(CXXFLAGS) -Ilib -Icli -c -o test/testcmdlineparser.o test/testcmdlineparser.cpp

test/testconstructors.o: test/testconstructors.cpp lib/tokenize.h lib/checkclass.h lib/check.h lib/token.h lib/settings.h lib/errorlogger.h lib/symboldatabase.h test/testsuite.h test/redirect.h
	$(CXX) $(CXXFLAGS) -Ilib -Icli -c -o test/testconstructors.o test/testconstructors.cpp

test/testcppcheck.o: test/testcppcheck.cpp lib/cppcheck.h lib/settings.h lib/errorlogger.h lib/checkunusedfunctions.h lib/check.h lib/token.h lib/tokenize.h test/testsuite.h test/redirect.h lib/path.h test/tinyxml/tinyxml.h test/tinyxml/tinystr.h
	$(CXX) $(CXXFLAGS) -Ilib -Icli -c -o test/testcppcheck.o test/testcppcheck.cpp

test/testdivision.o: test/testdivision.cpp lib/tokenize.h lib/checkother.h lib/check.h lib/token.h lib/settings.h lib/errorlogger.h test/testsuite.h test/redirect.h
	$(CXX) $(CXXFLAGS) -Ilib -Icli -c -o test/testdivision.o test/testdivision.cpp

test/testerrorlogger.o: test/testerrorlogger.cpp test/testsuite.h lib/errorlogger.h test/redirect.h
	$(CXX) $(CXXFLAGS) -Ilib -Icli -c -o test/testerrorlogger.o test/testerrorlogger.cpp

test/testexceptionsafety.o: test/testexceptionsafety.cpp lib/tokenize.h lib/checkexceptionsafety.h lib/check.h lib/token.h lib/settings.h lib/errorlogger.h test/testsuite.h test/redirect.h
	$(CXX) $(CXXFLAGS) -Ilib -Icli -c -o test/testexceptionsafety.o test/testexceptionsafety.cpp

test/testincompletestatement.o: test/testincompletestatement.cpp test/testsuite.h lib/errorlogger.h test/redirect.h lib/tokenize.h lib/checkother.h lib/check.h lib/token.h lib/settings.h
	$(CXX) $(CXXFLAGS) -Ilib -Icli -c -o test/testincompletestatement.o test/testincompletestatement.cpp

test/testmathlib.o: test/testmathlib.cpp lib/mathlib.h test/testsuite.h lib/errorlogger.h test/redirect.h
	$(CXX) $(CXXFLAGS) -Ilib -Icli -c -o test/testmathlib.o test/testmathlib.cpp

test/testmemleak.o: test/testmemleak.cpp lib/tokenize.h lib/checkmemoryleak.h lib/check.h lib/token.h lib/settings.h lib/errorlogger.h lib/symboldatabase.h test/testsuite.h test/redirect.h
	$(CXX) $(CXXFLAGS) -Ilib -Icli -c -o test/testmemleak.o test/testmemleak.cpp

test/testnullpointer.o: test/testnullpointer.cpp lib/tokenize.h lib/checknullpointer.h lib/check.h lib/token.h lib/settings.h lib/errorlogger.h test/testsuite.h test/redirect.h
	$(CXX) $(CXXFLAGS) -Ilib -Icli -c -o test/testnullpointer.o test/testnullpointer.cpp

test/testobsoletefunctions.o: test/testobsoletefunctions.cpp lib/tokenize.h lib/checkobsoletefunctions.h lib/check.h lib/token.h lib/settings.h lib/errorlogger.h test/testsuite.h test/redirect.h
	$(CXX) $(CXXFLAGS) -Ilib -Icli -c -o test/testobsoletefunctions.o test/testobsoletefunctions.cpp

test/testoptions.o: test/testoptions.cpp test/options.h test/testsuite.h lib/errorlogger.h test/redirect.h
	$(CXX) $(CXXFLAGS) -Ilib -Icli -c -o test/testoptions.o test/testoptions.cpp

test/testother.o: test/testother.cpp lib/tokenize.h lib/checkother.h lib/check.h lib/token.h lib/settings.h lib/errorlogger.h test/testsuite.h test/redirect.h
	$(CXX) $(CXXFLAGS) -Ilib -Icli -c -o test/testother.o test/testother.cpp

test/testpath.o: test/testpath.cpp test/testsuite.h lib/errorlogger.h test/redirect.h lib/path.h
	$(CXX) $(CXXFLAGS) -Ilib -Icli -c -o test/testpath.o test/testpath.cpp

test/testpostfixoperator.o: test/testpostfixoperator.cpp lib/tokenize.h lib/checkpostfixoperator.h lib/check.h lib/token.h lib/settings.h lib/errorlogger.h test/testsuite.h test/redirect.h
	$(CXX) $(CXXFLAGS) -Ilib -Icli -c -o test/testpostfixoperator.o test/testpostfixoperator.cpp

test/testpreprocessor.o: test/testpreprocessor.cpp test/testsuite.h lib/errorlogger.h test/redirect.h lib/preprocessor.h lib/tokenize.h lib/token.h lib/settings.h
	$(CXX) $(CXXFLAGS) -Ilib -Icli -c -o test/testpreprocessor.o test/testpreprocessor.cpp

test/testrunner.o: test/testrunner.cpp test/testsuite.h lib/errorlogger.h test/redirect.h test/options.h
	$(CXX) $(CXXFLAGS) -Ilib -Icli -c -o test/testrunner.o test/testrunner.cpp

test/testsettings.o: test/testsettings.cpp lib/settings.h test/testsuite.h lib/errorlogger.h test/redirect.h
	$(CXX) $(CXXFLAGS) -Ilib -Icli -c -o test/testsettings.o test/testsettings.cpp

test/testsimplifytokens.o: test/testsimplifytokens.cpp test/testsuite.h lib/errorlogger.h test/redirect.h lib/tokenize.h lib/token.h lib/settings.h
	$(CXX) $(CXXFLAGS) -Ilib -Icli -c -o test/testsimplifytokens.o test/testsimplifytokens.cpp

test/teststl.o: test/teststl.cpp lib/tokenize.h lib/checkstl.h lib/check.h lib/token.h lib/settings.h lib/errorlogger.h test/testsuite.h test/redirect.h
	$(CXX) $(CXXFLAGS) -Ilib -Icli -c -o test/teststl.o test/teststl.cpp

test/testsuite.o: test/testsuite.cpp test/testsuite.h lib/errorlogger.h test/redirect.h test/options.h
	$(CXX) $(CXXFLAGS) -Ilib -Icli -c -o test/testsuite.o test/testsuite.cpp

test/testthreadexecutor.o: test/testthreadexecutor.cpp lib/cppcheck.h lib/settings.h lib/errorlogger.h lib/checkunusedfunctions.h lib/check.h lib/token.h lib/tokenize.h test/testsuite.h test/redirect.h
	$(CXX) $(CXXFLAGS) -Ilib -Icli -c -o test/testthreadexecutor.o test/testthreadexecutor.cpp

test/testtoken.o: test/testtoken.cpp test/testsuite.h lib/errorlogger.h test/redirect.h lib/tokenize.h lib/token.h lib/settings.h
	$(CXX) $(CXXFLAGS) -Ilib -Icli -c -o test/testtoken.o test/testtoken.cpp

test/testtokenize.o: test/testtokenize.cpp test/testsuite.h lib/errorlogger.h test/redirect.h lib/tokenize.h lib/token.h lib/settings.h
	$(CXX) $(CXXFLAGS) -Ilib -Icli -c -o test/testtokenize.o test/testtokenize.cpp

test/testuninitvar.o: test/testuninitvar.cpp lib/tokenize.h lib/checkuninitvar.h lib/check.h lib/token.h lib/settings.h lib/errorlogger.h test/testsuite.h test/redirect.h
	$(CXX) $(CXXFLAGS) -Ilib -Icli -c -o test/testuninitvar.o test/testuninitvar.cpp

test/testunusedfunctions.o: test/testunusedfunctions.cpp lib/tokenize.h test/testsuite.h lib/errorlogger.h test/redirect.h lib/checkunusedfunctions.h lib/check.h lib/token.h lib/settings.h
	$(CXX) $(CXXFLAGS) -Ilib -Icli -c -o test/testunusedfunctions.o test/testunusedfunctions.cpp

test/testunusedprivfunc.o: test/testunusedprivfunc.cpp lib/tokenize.h lib/checkclass.h lib/check.h lib/token.h lib/settings.h lib/errorlogger.h lib/symboldatabase.h test/testsuite.h test/redirect.h
	$(CXX) $(CXXFLAGS) -Ilib -Icli -c -o test/testunusedprivfunc.o test/testunusedprivfunc.cpp

test/testunusedvar.o: test/testunusedvar.cpp test/testsuite.h lib/errorlogger.h test/redirect.h lib/tokenize.h lib/checkother.h lib/check.h lib/token.h lib/settings.h
	$(CXX) $(CXXFLAGS) -Ilib -Icli -c -o test/testunusedvar.o test/testunusedvar.cpp

test/tinyxml/tinystr.o: test/tinyxml/tinystr.cpp test/tinyxml/tinystr.h
	$(CXX) $(CXXFLAGS) -Ilib -Icli -c -o test/tinyxml/tinystr.o test/tinyxml/tinystr.cpp

test/tinyxml/tinyxml.o: test/tinyxml/tinyxml.cpp test/tinyxml/tinyxml.h test/tinyxml/tinystr.h
	$(CXX) $(CXXFLAGS) -Ilib -Icli -c -o test/tinyxml/tinyxml.o test/tinyxml/tinyxml.cpp

test/tinyxml/tinyxmlerror.o: test/tinyxml/tinyxmlerror.cpp test/tinyxml/tinyxml.h test/tinyxml/tinystr.h
	$(CXX) $(CXXFLAGS) -Ilib -Icli -c -o test/tinyxml/tinyxmlerror.o test/tinyxml/tinyxmlerror.cpp

test/tinyxml/tinyxmlparser.o: test/tinyxml/tinyxmlparser.cpp test/tinyxml/tinyxml.h test/tinyxml/tinystr.h
	$(CXX) $(CXXFLAGS) -Ilib -Icli -c -o test/tinyxml/tinyxmlparser.o test/tinyxml/tinyxmlparser.cpp

