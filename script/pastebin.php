#!/usr/bin/php
<?php
$today			= ' Sun Sep 27 19:05:52 JST 2015 '; // (vim) :r !date (emacs) C-u M-! date
$api_dev_key		= 'a4582d751f7b2b5a3121936cbe5e45bf';
$api_user_key		= '9430d755a9448dd561e6694d94f2ab69';
$api_user_name		= 'w3game';
$api_user_password	= 'jfieow';
// Default Value
$api_paste_expire_date	= 'N'; // Never 10M 1H 1D 1W 2W 1M
$api_paste_format	= 'text';
$api_paste_private	= '1'; // 0=public 1=unlisted 2=private
$api_results_limit	= '100';

$api_user_name		= urlencode($api_user_name);
$api_user_password	= urlencode($api_user_password);

$options = getopt("e:i:m:p:s:t:dhlvy", array("default", "help", "list"));
foreach (array_keys($options) as $opts) switch ($opts) {
	case 'd':
		print_default_settings();
		exit(1);
	case 'h':
		print_help_message();
		exit(1);
	case 'l':
		list_paste_title($options, $api_dev_key, $api_user_key, $api_results_limit);
		exit(0);
	case 'v':
		print_version_message();
		exit(1);
	case 'y':
		list_paste_syntax();
		exit(0);
	case 'default':
		print_default_settings();
		exit(1);
	case 'help':
		print_help_message();
		exit(1);
	case 'list':
		list_paste_title();
		exit(0);
	default:
		send_paste_contents($options, $api_dev_key, $api_paste_expire_date, $api_paste_format, $api_paste_private, $api_user_key);
		exit(0);
}

function send_paste_contents($options, $api_dev_key, $api_paste_expire_date, $api_paste_format, $api_paste_private, $api_user_key) { 
	pickout_filename_argv($options);
	$default = array("e" => $api_paste_expire_date, "i" => $GLOBALS['argv'][1], "p" => $api_paste_private, "s" => $api_paste_format);
	$options = array_merge($default, $options);

	$api_paste_code		= file_get_contents($options["i"]);
	$api_paste_expire_date	= $options["e"];
	$api_paste_format	= $options["s"];
	$api_paste_name		= $options["t"];
	$api_paste_private	= $options["p"];

	$api_paste_code		= urlencode($api_paste_code);
	$api_paste_name		= urlencode($api_paste_name);
	
	$api_fields = 'api_option=paste&api_user_key='.$api_user_key.'&api_paste_private='.$api_paste_private.'&api_paste_name='.$api_paste_name.'&api_paste_expire_date='.$api_paste_expire_date.'&api_paste_format='.$api_paste_format.'&api_dev_key='.$api_dev_key.'&api_paste_code='.$api_paste_code.'';
	// api_fields = 'api_dev_key='.$api_dev_key.'&api_user_name='.$api_user_name.'&api_user_password='.$api_user_password.'';
	// api_fields = 'api_option=trends&api_dev_key='.$api_dev_key.'';
	$url = 'http://pastebin.com/api/api_post.php';
	// $url = 'http://pastebin.com/api/api_login.php';

	$ch = curl_init($url);

	curl_setopt($ch, CURLOPT_POST, true);
	curl_setopt($ch, CURLOPT_POSTFIELDS, $api_fields);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
	curl_setopt($ch, CURLOPT_VERBOSE, 1);
	curl_setopt($ch, CURLOPT_NOBODY, 0);
	
	$response = curl_exec($ch);
	echo $response;
}

function pickout_filename_argv($options)
{
	foreach( $options as $o => $a )
	{
		// Look for all occurrences of option in argv and remove if found :
		// ----------------------------------------------------------------
		// Look for occurrences of -o (simple option with no value) or -o<val> (no space in between):
		while($k=array_search("-".$o.$a,$GLOBALS['argv']))
		{    // If found remove from argv:
			if($k)
				unset($GLOBALS['argv'][$k]);
		}
		// Look for remaining occurrences of -o <val> (space in between):
		while($k=array_search("-".$o,$GLOBALS['argv']))
		{    // If found remove both option and value from argv:
			if($k)
			{    unset($GLOBALS['argv'][$k]);
				unset($GLOBALS['argv'][$k+1]);
			}
		}
	}
	// Reindex :
	$GLOBALS['argv']=array_merge($GLOBALS['argv']);
}

function list_paste_title($options, $api_dev_key, $api_user_key, $api_results_limit) { 
	$default = array("m" => $api_results_limit);
	$options = array_merge($default, $options);

	$api_results_limit	= $options["m"];

	$api_fields = 'api_option=list&api_user_key='.$api_user_key.'&api_dev_key='.$api_dev_key.'&api_results_limit='.$api_results_limit.'';
	$url = 'http://pastebin.com/api/api_post.php';
	$ch = curl_init($url);
	
	curl_setopt($ch, CURLOPT_POST, true);
	curl_setopt($ch, CURLOPT_POSTFIELDS, $api_fields);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
	curl_setopt($ch, CURLOPT_VERBOSE, 1);
	curl_setopt($ch, CURLOPT_NOBODY, 0);
	
	$response = curl_exec($ch);
	echo $response;
}

function print_default_settings() {
	global $api_paste_expire_date, $api_paste_format, $api_paste_private, $api_results_limit;
	print 
"-e $api_paste_expire_date (Never 10M 1H 1D 1W 2W 1M)
-s $api_paste_format
-p $api_paste_private (0=public 1=unlisted 2=private)
-m $api_results_limit
";
}

function print_help_message() {
	echo
"command options filename\n
-d, --default	show DEFAULT settings
-e [value]	Expire date (Never 10M 1H 1D 1W 2W 1M)
-h, --help	this Help
-i [filename]	Input file
-l, --list	LISTing pastes
-m [value]	liMitation of listing pastes
-p [value]	Private (0=public 1=unlisted 2=private)
-s [value]	Syntax
-y		sYntax listing
-t [title]	Title
-v		last modified date
";
}

function print_version_message() {
	global $today;
	print "last modified at $today";
}

function list_paste_syntax() {
	echo
"4cs = 4CS
6502acme = 6502 ACME Cross Assembler
6502kickass = 6502 Kick Assembler
6502tasm = 6502 TASM/64TASS
abap = ABAP
actionscript = ActionScript
actionscript3 = ActionScript 3
ada = Ada
aimms = AIMMS
algol68 = ALGOL 68
apache = Apache Log
applescript = AppleScript
apt_sources = APT Sources
arm = ARM
asm = ASM (NASM)
asp = ASP
asymptote = Asymptote
autoconf = autoconf
autohotkey = Autohotkey
autoit = AutoIt
avisynth = Avisynth
awk = Awk
bascomavr = BASCOM AVR
bash = Bash
basic4gl = Basic4GL
dos = Batch
bibtex = BibTeX
blitzbasic = Blitz Basic
b3d = Blitz3D
bmx = BlitzMax
bnf = BNF
boo = BOO
bf = BrainFuck
c = C
c_winapi = C (WinAPI)
c_mac = C for Macs
cil = C Intermediate Language
csharp = C#
cpp = C++
cpp-winapi = C++ (WinAPI)
cpp-qt = C++ (with Qt extensions)
c_loadrunner = C: Loadrunner
caddcl = CAD DCL
cadlisp = CAD Lisp
cfdg = CFDG
chaiscript = ChaiScript
chapel = Chapel
clojure = Clojure
klonec = Clone C
klonecpp = Clone C++
cmake = CMake
cobol = COBOL
coffeescript = CoffeeScript
cfm = ColdFusion
css = CSS
cuesheet = Cuesheet
d = D
dart = Dart
dcl = DCL
dcpu16 = DCPU-16
dcs = DCS
delphi = Delphi
oxygene = Delphi Prism (Oxygene)
diff = Diff
div = DIV
dot = DOT
e = E
ezt = Easytrieve
ecmascript = ECMAScript
eiffel = Eiffel
email = Email
epc = EPC
erlang = Erlang
fsharp = F#
falcon = Falcon
fo = FO Language
f1 = Formula One
fortran = Fortran
freebasic = FreeBasic
freeswitch = FreeSWITCH
gambas = GAMBAS
gml = Game Maker
gdb = GDB
genero = Genero
genie = Genie
gettext = GetText
go = Go
groovy = Groovy
gwbasic = GwBasic
haskell = Haskell
haxe = Haxe
hicest = HicEst
hq9plus = HQ9 Plus
html4strict = HTML
html5 = HTML 5
icon = Icon
idl = IDL
ini = INI file
inno = Inno Script
intercal = INTERCAL
io = IO
ispfpanel = ISPF Panel Definition
j = J
java = Java
java5 = Java 5
javascript = JavaScript
jcl = JCL
jquery = jQuery
json = JSON
julia = Julia
kixtart = KiXtart
latex = Latex
ldif = LDIF
lb = Liberty BASIC
lsl2 = Linden Scripting
lisp = Lisp
llvm = LLVM
locobasic = Loco Basic
logtalk = Logtalk
lolcode = LOL Code
lotusformulas = Lotus Formulas
lotusscript = Lotus Script
lscript = LScript
lua = Lua
m68k = M68000 Assembler
magiksf = MagikSF
make = Make
mapbasic = MapBasic
matlab = MatLab
mirc = mIRC
mmix = MIX Assembler
modula2 = Modula 2
modula3 = Modula 3
68000devpac = Motorola 68000 HiSoft Dev
mpasm = MPASM
mxml = MXML
mysql = MySQL
nagios = Nagios
netrexx = NetRexx
newlisp = newLISP
nginx = Nginx
nimrod = Nimrod
text = None
nsis = NullSoft Installer
oberon2 = Oberon 2
objeck = Objeck Programming Langua
objc = Objective C
ocaml-brief = OCalm Brief
ocaml = OCaml
octave = Octave
pf = OpenBSD PACKET FILTER
glsl = OpenGL Shading
oobas = Openoffice BASIC
oracle11 = Oracle 11
oracle8 = Oracle 8
oz = Oz
parasail = ParaSail
parigp = PARI/GP
pascal = Pascal
pawn = Pawn
pcre = PCRE
per = Per
perl = Perl
perl6 = Perl 6
php = PHP
php-brief = PHP Brief
pic16 = Pic 16
pike = Pike
pixelbender = Pixel Bender
plsql = PL/SQL
postgresql = PostgreSQL
postscript = PostScript
povray = POV-Ray
powershell = Power Shell
powerbuilder = PowerBuilder
proftpd = ProFTPd
progress = Progress
prolog = Prolog
properties = Properties
providex = ProvideX
puppet = Puppet
purebasic = PureBasic
pycon = PyCon
python = Python
pys60 = Python for S60
q = q/kdb+
qbasic = QBasic
qml = QML
rsplus = R
racket = Racket
rails = Rails
rbs = RBScript
rebol = REBOL
reg = REG
rexx = Rexx
robots = Robots
rpmspec = RPM Spec
ruby = Ruby
gnuplot = Ruby Gnuplot
rust = Rust
sas = SAS
scala = Scala
scheme = Scheme
scilab = Scilab
scl = SCL
sdlbasic = SdlBasic
smalltalk = Smalltalk
smarty = Smarty
spark = SPARK
sparql = SPARQL
sqf = SQF
sql = SQL
standardml = StandardML
stonescript = StoneScript
sclang = SuperCollider
swift = Swift
systemverilog = SystemVerilog
tsql = T-SQL
tcl = TCL
teraterm = Tera Term
thinbasic = thinBasic
typoscript = TypoScript
unicon = Unicon
uscript = UnrealScript
ups = UPC
urbi = Urbi
vala = Vala
vbnet = VB.NET
vbscript = VBScript
vedit = Vedit
verilog = VeriLog
vhdl = VHDL
vim = VIM
visualprolog = Visual Pro Log
vb = VisualBasic
visualfoxpro = VisualFoxPro
whitespace = WhiteSpace
whois = WHOIS
winbatch = Winbatch
xbasic = XBasic
xml = XML
xorg_conf = Xorg Config
xpp = XPP
yaml = YAML
z80 = Z80 Assembler
zxbasic = ZXBasic
";
}
?>
