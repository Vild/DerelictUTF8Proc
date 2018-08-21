module derelict.utf8proc.utf8proc;

version (Derelict_Static) version = DerelictUTF8Proc_Static;

public:
	version (DerelictUTF8Proc_Static)
		import derelict.utf8proc.statfun;
	else
		import derelict.utf8proc.dynload;
