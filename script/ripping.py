#!/usr/bin/python
import os, sys, traceback
import DiscID, CDDB
import time

# The LISTFILE stuff is to keep a record of which CDs have been ripped already - I didn't want any mistakes or duplicates
LISTFILE = "rippedcd.lst"
os.system( 'touch ' + LISTFILE )            # Make sure it exists

# Handle problem characters - just replaces every first string with the matching second string
def safe( name ):
        badchars = [('?', ''), ('\\', ''), ('/', ''), (':', '-'), ('"', "'")]
        for x in badchars:
                name = name.replace( x[0], x[1] )
        return name

# I'm almost positive there is a 'right' way to do this...
def direxists( name ):
        try:
                os.stat( name )
                return 1
        except:
                return 0

# Function that checks the CD serial against those in LISTFILE and aborts if necessary
def check_cd():
        try:
                dev = DiscID.open()
                id = DiscID.disc_id(dev)
                dev.close()
                idhex = id[0].__hex__()
                try:
                        f = open(LISTFILE, 'r')
                except:
                        print os.getcwd()
                for line in f:
                        if line.strip('\n') == idhex:
                                print idhex, "CD already ripped"
                                f.close()
                                return 0
                f.close()
                return id
        except:
                inf = sys.exc_info()
                traceback.print_tb( inf[2] )
                return 0

details = check_cd()
if details:
        try:
                # Get the track and album names - may need some alterations for abnormal CDDB entries
                cddb = CDDB.query( details )
                cddb = cddb[1]
                if type(cddb) == type([]):
                        cddb = cddb[0]
                names = CDDB.read( cddb['category'], cddb['disc_id'] )
                names = names[1]
                titles = [ safe(x.strip()) for x in names['DTITLE'].split(' / ', 1) ]
                if len(titles) == 1:
                        titles = ['Various'] + titles
                n = 0
                while names.has_key( 'TTITLE%d' % n ):
                        titles.append(safe(names['TTITLE%d' % n]))
                        n+=1

                # I have flac and ogg directories already created - adjust for your needs
                dir1 = 'flac/' + titles[0]
                dir2 = 'ogg/' + titles[0]
                if not direxists( dir1 ):
                        print "*%s* does not exist" % dir1
                        os.mkdir( dir1 )
                if not direxists( dir2 ):
                        print "*%s* does not exist" % dir2
                        os.mkdir( dir2 )
                dir1 += '/' + titles[1]
                dir2 += '/' + titles[1]
                if not direxists( dir1 ):
                        print "*%s* does not exist" % dir1
                        os.mkdir( dir1 )
                if not direxists( dir2 ):
                        print "*%s* does not exist" % dir2
                        os.mkdir( dir2 )
                for x in range( 1, len(titles)-1 ):
                        # Build command line...
                        cmd = "cdda2wav -Q -q -D /dev/cdrom -t %d - " % x
                        cmd += " | flac --best -c -s -"
                        # This is silly, but it saves me escaping spaces on the command line
                        finput = os.popen( cmd )
                        fname = dir1 + "/%02d - %s.flac" % (x, titles[x+1])
                        foutput = open( fname, 'w' )
                        foutput.write( finput.read() )
                        finput.close()
                        foutput.close()
                        # First command creates the FLAC file, this recompresses to OGG without using the CD again (faster)
                        cmd = "flac -d -c -s \"%s\"" % fname
                        cmd += " | oggenc -Q -b 192 - 2>/dev/null"
                        finput = os.popen( cmd )
                        fname = dir2 + "/%02d - %s.ogg" % (x, titles[x+1])
                        foutput = open( fname, 'w' )
                        foutput.write( finput.read() )
                        finput.close()
                        foutput.close()
                # Add the CD serial to LISTFILE
                f = open(LISTFILE, 'a')
                f.write(details[0].__hex__() + "\n")
                f.flush()
                f.close()
        except:
                traceback.print_exc()
