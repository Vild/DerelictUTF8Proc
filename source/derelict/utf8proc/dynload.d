module derelict.utf8proc.dynload;

import derelict.utf8proc.types;

version (Derelict_Static)
{
}
else version (DerelictUTF8Proc_Static)
{
}
else
{
	version = DerelictUTF8Proc_Dynamic;
}

version (DerelictUTF8Proc_Dynamic)  : public import derelict.utf8proc.types;
import derelict.util.exception, derelict.util.loader, derelict.util.system;

extern (C) @nogc nothrow
{
	alias da_utf8proc_utf8class = const(utf8proc_int8_t[256])*;
	alias da_utf8proc_version = const char* function();
	alias da_utf8proc_errmsg = const char* function(utf8proc_ssize_t errcode);
	alias da_utf8proc_iterate = utf8proc_ssize_t function(const utf8proc_uint8_t* str,
			utf8proc_ssize_t strlen, utf8proc_int32_t* codepoint_ref);
	alias da_utf8proc_codepoint_valid = utf8proc_bool function(utf8proc_int32_t codepoint);
	alias da_utf8proc_encode_char = utf8proc_ssize_t function(utf8proc_int32_t codepoint,
			utf8proc_uint8_t* dst);
	alias da_utf8proc_get_property = const utf8proc_property_t* function(utf8proc_int32_t codepoint);
	alias da_utf8proc_decompose_char = utf8proc_ssize_t function(utf8proc_int32_t codepoint,
			utf8proc_int32_t* dst, utf8proc_ssize_t bufsize, utf8proc_option_t options,
			int* last_boundclass);
	alias da_utf8proc_decompose = utf8proc_ssize_t function(const utf8proc_uint8_t* str,
			utf8proc_ssize_t strlen, utf8proc_int32_t* buffer,
			utf8proc_ssize_t bufsize, utf8proc_option_t options);
	alias da_utf8proc_decompose_custom = utf8proc_ssize_t function(
			const utf8proc_uint8_t* str, utf8proc_ssize_t strlen, utf8proc_int32_t* buffer,
			utf8proc_ssize_t bufsize, utf8proc_option_t options,
			utf8proc_custom_func custom_func, void* custom_data);
	alias da_utf8proc_normalize_utf32 = utf8proc_ssize_t function(
			utf8proc_int32_t* buffer, utf8proc_ssize_t length, utf8proc_option_t options);
	alias da_utf8proc_reencode = utf8proc_ssize_t function(utf8proc_int32_t* buffer,
			utf8proc_ssize_t length, utf8proc_option_t options);
	alias da_utf8proc_grapheme_break_stateful = utf8proc_bool function(
			utf8proc_int32_t codepoint1, utf8proc_int32_t codepoint2, utf8proc_int32_t* state);
	alias da_utf8proc_grapheme_break = utf8proc_bool function(utf8proc_int32_t codepoint1,
			utf8proc_int32_t codepoint2);
	alias da_utf8proc_tolower = utf8proc_int32_t function(utf8proc_int32_t c);
	alias da_utf8proc_toupper = utf8proc_int32_t function(utf8proc_int32_t c);
	alias da_utf8proc_totitle = utf8proc_int32_t function(utf8proc_int32_t c);
	alias da_utf8proc_charwidth = int function(utf8proc_int32_t codepoint);
	alias da_utf8proc_category = utf8proc_category_t function(utf8proc_int32_t codepoint);
	alias da_utf8proc_category_string = const char* function(utf8proc_int32_t codepoint);
	alias da_utf8proc_map = utf8proc_ssize_t function(const utf8proc_uint8_t* str,
			utf8proc_ssize_t strlen, utf8proc_uint8_t** dstptr, utf8proc_option_t options);
	alias da_utf8proc_map_custom = utf8proc_ssize_t function(const utf8proc_uint8_t* str,
			utf8proc_ssize_t strlen, utf8proc_uint8_t** dstptr,
			utf8proc_option_t options, utf8proc_custom_func custom_func, void* custom_data);
	alias da_utf8proc_NFD = utf8proc_uint8_t* function(const utf8proc_uint8_t* str);
	alias da_utf8proc_NFC = utf8proc_uint8_t* function(const utf8proc_uint8_t* str);
	alias da_utf8proc_NFKD = utf8proc_uint8_t* function(const utf8proc_uint8_t* str);
	alias da_utf8proc_NFKC = utf8proc_uint8_t* function(const utf8proc_uint8_t* str);
}

__gshared
{
	da_utf8proc_utf8class utf8proc_utf8class;
	da_utf8proc_version utf8proc_version;
	da_utf8proc_errmsg utf8proc_errmsg;
	da_utf8proc_iterate utf8proc_iterate;
	da_utf8proc_codepoint_valid utf8proc_codepoint_valid;
	da_utf8proc_encode_char utf8proc_encode_char;
	da_utf8proc_get_property utf8proc_get_property;
	da_utf8proc_decompose_char utf8proc_decompose_char;
	da_utf8proc_decompose utf8proc_decompose;
	da_utf8proc_decompose_custom utf8proc_decompose_custom;
	da_utf8proc_normalize_utf32 utf8proc_normalize_utf32;
	da_utf8proc_reencode utf8proc_reencode;
	da_utf8proc_grapheme_break_stateful utf8proc_grapheme_break_stateful;
	da_utf8proc_grapheme_break utf8proc_grapheme_break;
	da_utf8proc_tolower utf8proc_tolower;
	da_utf8proc_toupper utf8proc_toupper;
	da_utf8proc_totitle utf8proc_totitle;
	da_utf8proc_charwidth utf8proc_charwidth;
	da_utf8proc_category utf8proc_category;
	da_utf8proc_category_string utf8proc_category_string;
	da_utf8proc_map utf8proc_map;
	da_utf8proc_map_custom utf8proc_map_custom;
	da_utf8proc_NFD utf8proc_NFD;
	da_utf8proc_NFC utf8proc_NFC;
	da_utf8proc_NFKD utf8proc_NFKD;
	da_utf8proc_NFKC utf8proc_NFKC;
}

class DerelictUTF8ProcLoader : SharedLibLoader
{
	this()
	{
		super(libNames);
	}

	protected override void loadSymbols()
	{
		utf8proc_utf8class = cast(da_utf8proc_utf8class) loadSymbol("utf8proc_utf8class");
		bindFunc(cast(void**)&utf8proc_version, "utf8proc_version");
		bindFunc(cast(void**)&utf8proc_errmsg, "utf8proc_errmsg");
		bindFunc(cast(void**)&utf8proc_iterate, "utf8proc_iterate");
		bindFunc(cast(void**)&utf8proc_codepoint_valid, "utf8proc_codepoint_valid");
		bindFunc(cast(void**)&utf8proc_encode_char, "utf8proc_encode_char");
		bindFunc(cast(void**)&utf8proc_get_property, "utf8proc_get_property");
		bindFunc(cast(void**)&utf8proc_decompose_char, "utf8proc_decompose_char");
		bindFunc(cast(void**)&utf8proc_decompose, "utf8proc_decompose");
		bindFunc(cast(void**)&utf8proc_decompose_custom, "utf8proc_decompose_custom");
		bindFunc(cast(void**)&utf8proc_normalize_utf32, "utf8proc_normalize_utf32");
		bindFunc(cast(void**)&utf8proc_reencode, "utf8proc_reencode");
		bindFunc(cast(void**)&utf8proc_grapheme_break_stateful, "utf8proc_grapheme_break_stateful");
		bindFunc(cast(void**)&utf8proc_grapheme_break, "utf8proc_grapheme_break");
		bindFunc(cast(void**)&utf8proc_tolower, "utf8proc_tolower");
		bindFunc(cast(void**)&utf8proc_toupper, "utf8proc_toupper");
		bindFunc(cast(void**)&utf8proc_totitle, "utf8proc_totitle");
		bindFunc(cast(void**)&utf8proc_charwidth, "utf8proc_charwidth");
		bindFunc(cast(void**)&utf8proc_category, "utf8proc_category");
		bindFunc(cast(void**)&utf8proc_category_string, "utf8proc_category_string");
		bindFunc(cast(void**)&utf8proc_map, "utf8proc_map");
		bindFunc(cast(void**)&utf8proc_map_custom, "utf8proc_map_custom");
		bindFunc(cast(void**)&utf8proc_NFD, "utf8proc_NFD");
		bindFunc(cast(void**)&utf8proc_NFC, "utf8proc_NFC");
		bindFunc(cast(void**)&utf8proc_NFKD, "utf8proc_NFKD");
		bindFunc(cast(void**)&utf8proc_NFKC, "utf8proc_NFKC");
	}
}

__gshared DerelictUTF8ProcLoader DerelictUTF8Proc;

shared static this()
{
	DerelictUTF8Proc = new DerelictUTF8ProcLoader();
}

private:
static if (Derelict_OS_Windows)
	enum libNames = "libutf8proc.dll";
else static if (Derelict_OS_Mac)
	enum libNames = "libutf8proc.dylib";
else static if (Derelict_OS_Posix)
	enum libNames = "libutf8proc.so";
else
	static assert(0, "Need to implement utf8proc libNames for this operating system.");
