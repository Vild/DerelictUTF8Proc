module derelict.utf8proc.types;

alias utf8proc_int8_t = byte;
alias utf8proc_uint8_t = ubyte;
alias utf8proc_int16_t = short;
alias utf8proc_uint16_t = ushort;
alias utf8proc_int32_t = int;
alias utf8proc_uint32_t = uint;
alias utf8proc_size_t = size_t;
alias utf8proc_ssize_t = ptrdiff_t;
alias utf8proc_bool = bool;

/** The MAJOR version number (increased when backwards API compatibility is broken). */
enum UTF8PROC_VERSION_MAJOR = 2;
/** The MINOR version number (increased when new functionality is added in a backwards-compatible manner). */
enum UTF8PROC_VERSION_MINOR = 1;
/** The PATCH version (increased for fixes that do not change the API). */
enum UTF8PROC_VERSION_PATCH = 1;

/**
 * Option flags used by several functions in the library.
 */
enum utf8proc_option_t
{
	/** The given UTF-8 input is NULL terminated. */
	UTF8PROC_NULLTERM = (1 << 0),
	/** Unicode Versioning Stability has to be respected. */
	UTF8PROC_STABLE = (1 << 1),
	/** Compatibility decomposition (i.e. formatting information is lost). */
	UTF8PROC_COMPAT = (1 << 2),
	/** Return a result with decomposed characters. */
	UTF8PROC_COMPOSE = (1 << 3),
	/** Return a result with decomposed characters. */
	UTF8PROC_DECOMPOSE = (1 << 4),
	/** Strip "default ignorable characters" such as SOFT-HYPHEN or ZERO-WIDTH-SPACE. */
	UTF8PROC_IGNORE = (1 << 5),
	/** Return an error, if the input contains unassigned codepoints. */
	UTF8PROC_REJECTNA = (1 << 6),
	/**
   * Indicating that NLF-sequences (LF, CRLF, CR, NEL) are representing a
   * line break, and should be converted to the codepoint for line
   * separation (LS).
   */
	UTF8PROC_NLF2LS = (1 << 7),
	/**
   * Indicating that NLF-sequences are representing a paragraph break, and
   * should be converted to the codepoint for paragraph separation
   * (PS).
   */
	UTF8PROC_NLF2PS = (1 << 8),
	/** Indicating that the meaning of NLF-sequences is unknown. */
	UTF8PROC_NLF2LF = (UTF8PROC_NLF2LS | UTF8PROC_NLF2PS),
	/** Strips and/or convers control characters.
   *
   * NLF-sequences are transformed into space, except if one of the
   * NLF2LS/PS/LF options is given. HorizontalTab (HT) and FormFeed (FF)
   * are treated as a NLF-sequence in this case.  All other control
   * characters are simply removed.
   */
	UTF8PROC_STRIPCC = (1 << 9),
	/**
   * Performs unicode case folding, to be able to do a case-insensitive
   * string comparison.
   */
	UTF8PROC_CASEFOLD = (1 << 10),
	/**
   * Inserts 0xFF bytes at the beginning of each sequence which is
   * representing a single grapheme cluster (see UAX#29).
   */
	UTF8PROC_CHARBOUND = (1 << 11),
	/** Lumps certain characters together.
   *
   * E.g. HYPHEN U+2010 and MINUS U+2212 to ASCII "-". See lump.md for details.
   *
   * If NLF2LF is set, this includes a transformation of paragraph and
   * line separators to ASCII line-feed (LF).
   */
	UTF8PROC_LUMP = (1 << 12),
	/** Strips all character markings.
   *
   * This includes non-spacing, spacing and enclosing (i.e. accents).
   * @note This option works only with @ref UTF8PROC_COMPOSE or
   *       @ref UTF8PROC_DECOMPOSE
   */
	UTF8PROC_STRIPMARK = (1 << 13),
}

enum UTF8PROC_NULLTERM = utf8proc_option_t.UTF8PROC_NULLTERM;
enum UTF8PROC_STABLE = utf8proc_option_t.UTF8PROC_STABLE;
enum UTF8PROC_COMPAT = utf8proc_option_t.UTF8PROC_COMPAT;
enum UTF8PROC_COMPOSE = utf8proc_option_t.UTF8PROC_COMPOSE;
enum UTF8PROC_DECOMPOSE = utf8proc_option_t.UTF8PROC_DECOMPOSE;
enum UTF8PROC_IGNORE = utf8proc_option_t.UTF8PROC_IGNORE;
enum UTF8PROC_REJECTNA = utf8proc_option_t.UTF8PROC_REJECTNA;
enum UTF8PROC_NLF2LS = utf8proc_option_t.UTF8PROC_NLF2LS;
enum UTF8PROC_NLF2PS = utf8proc_option_t.UTF8PROC_NLF2PS;
enum UTF8PROC_NLF2LF = utf8proc_option_t.UTF8PROC_NLF2LF;
enum UTF8PROC_STRIPCC = utf8proc_option_t.UTF8PROC_STRIPCC;
enum UTF8PROC_CASEFOLD = utf8proc_option_t.UTF8PROC_CASEFOLD;
enum UTF8PROC_CHARBOUND = utf8proc_option_t.UTF8PROC_CHARBOUND;
enum UTF8PROC_LUMP = utf8proc_option_t.UTF8PROC_LUMP;
enum UTF8PROC_STRIPMARK = utf8proc_option_t.UTF8PROC_STRIPMARK;

/** Memory could not be allocated. */
enum UTF8PROC_ERROR_NOMEM = -1;
/** The given string is too long to be processed. */
enum UTF8PROC_ERROR_OVERFLOW = -2;
/** The given string is not a legal UTF-8 string. */
enum UTF8PROC_ERROR_INVALIDUTF8 = -3;
/** The @ref UTF8PROC_REJECTNA flag was set and an unassigned codepoint was found. */
enum UTF8PROC_ERROR_NOTASSIGNED = -4;
/** Invalid options have been used. */
enum UTF8PROC_ERROR_INVALIDOPTS = -5;

/** Holds the value of a property. */
alias utf8proc_propval_t = utf8proc_int16_t;

/** Struct containing information about a codepoint. */
alias utf8proc_property_t = utf8proc_property_struct;
struct utf8proc_property_struct
{
	import std.bitmanip : bitfields;

align(4):
	/**
   * Unicode category.
   * @see utf8proc_category_t.
   */
	utf8proc_propval_t category;
	utf8proc_propval_t combining_class;
	/**
   * Bidirectional class.
   * @see utf8proc_bidi_class_t.
   */
	utf8proc_propval_t bidi_class;
	/**
   * @anchor Decomposition type.
   * @see utf8proc_decomp_type_t.
   */
	utf8proc_propval_t decomp_type;
	utf8proc_uint16_t decomp_seqindex;
	utf8proc_uint16_t casefold_seqindex;
	utf8proc_uint16_t uppercase_seqindex;
	utf8proc_uint16_t lowercase_seqindex;
	utf8proc_uint16_t titlecase_seqindex;
	utf8proc_uint16_t comb_index;

	//dfmt off
	mixin(bitfields!(
		bool, "bidi_mirrored", 1,
		bool, "comp_exclusion", 1,
		bool, "ignorable", 1,
		bool, "control_boundary", 1,
		uint, "charwidth", 2,
		uint, "pad", 2,
		uint, "boundclass", 8,
	));
	// dfmt on
}

/** Unicode categories. */
enum utf8proc_category_t
{
	UTF8PROC_CATEGORY_CN = 0, /**< Other, not assigned */
	UTF8PROC_CATEGORY_LU = 1, /**< Letter, uppercase */
	UTF8PROC_CATEGORY_LL = 2, /**< Letter, lowercase */
	UTF8PROC_CATEGORY_LT = 3, /**< Letter, titlecase */
	UTF8PROC_CATEGORY_LM = 4, /**< Letter, modifier */
	UTF8PROC_CATEGORY_LO = 5, /**< Letter, other */
	UTF8PROC_CATEGORY_MN = 6, /**< Mark, nonspacing */
	UTF8PROC_CATEGORY_MC = 7, /**< Mark, spacing combining */
	UTF8PROC_CATEGORY_ME = 8, /**< Mark, enclosing */
	UTF8PROC_CATEGORY_ND = 9, /**< Number, decimal digit */
	UTF8PROC_CATEGORY_NL = 10, /**< Number, letter */
	UTF8PROC_CATEGORY_NO = 11, /**< Number, other */
	UTF8PROC_CATEGORY_PC = 12, /**< Punctuation, connector */
	UTF8PROC_CATEGORY_PD = 13, /**< Punctuation, dash */
	UTF8PROC_CATEGORY_PS = 14, /**< Punctuation, open */
	UTF8PROC_CATEGORY_PE = 15, /**< Punctuation, close */
	UTF8PROC_CATEGORY_PI = 16, /**< Punctuation, initial quote */
	UTF8PROC_CATEGORY_PF = 17, /**< Punctuation, final quote */
	UTF8PROC_CATEGORY_PO = 18, /**< Punctuation, other */
	UTF8PROC_CATEGORY_SM = 19, /**< Symbol, math */
	UTF8PROC_CATEGORY_SC = 20, /**< Symbol, currency */
	UTF8PROC_CATEGORY_SK = 21, /**< Symbol, modifier */
	UTF8PROC_CATEGORY_SO = 22, /**< Symbol, other */
	UTF8PROC_CATEGORY_ZS = 23, /**< Separator, space */
	UTF8PROC_CATEGORY_ZL = 24, /**< Separator, line */
	UTF8PROC_CATEGORY_ZP = 25, /**< Separator, paragraph */
	UTF8PROC_CATEGORY_CC = 26, /**< Other, control */
	UTF8PROC_CATEGORY_CF = 27, /**< Other, format */
	UTF8PROC_CATEGORY_CS = 28, /**< Other, surrogate */
	UTF8PROC_CATEGORY_CO = 29, /**< Other, private use */



}

enum UTF8PROC_CATEGORY_CN = utf8proc_category_t.UTF8PROC_CATEGORY_CN;
enum UTF8PROC_CATEGORY_LU = utf8proc_category_t.UTF8PROC_CATEGORY_LU;
enum UTF8PROC_CATEGORY_LL = utf8proc_category_t.UTF8PROC_CATEGORY_LL;
enum UTF8PROC_CATEGORY_LT = utf8proc_category_t.UTF8PROC_CATEGORY_LT;
enum UTF8PROC_CATEGORY_LM = utf8proc_category_t.UTF8PROC_CATEGORY_LM;
enum UTF8PROC_CATEGORY_LO = utf8proc_category_t.UTF8PROC_CATEGORY_LO;
enum UTF8PROC_CATEGORY_MN = utf8proc_category_t.UTF8PROC_CATEGORY_MN;
enum UTF8PROC_CATEGORY_MC = utf8proc_category_t.UTF8PROC_CATEGORY_MC;
enum UTF8PROC_CATEGORY_ME = utf8proc_category_t.UTF8PROC_CATEGORY_ME;
enum UTF8PROC_CATEGORY_ND = utf8proc_category_t.UTF8PROC_CATEGORY_ND;
enum UTF8PROC_CATEGORY_NL = utf8proc_category_t.UTF8PROC_CATEGORY_NL;
enum UTF8PROC_CATEGORY_NO = utf8proc_category_t.UTF8PROC_CATEGORY_NO;
enum UTF8PROC_CATEGORY_PC = utf8proc_category_t.UTF8PROC_CATEGORY_PC;
enum UTF8PROC_CATEGORY_PD = utf8proc_category_t.UTF8PROC_CATEGORY_PD;
enum UTF8PROC_CATEGORY_PS = utf8proc_category_t.UTF8PROC_CATEGORY_PS;
enum UTF8PROC_CATEGORY_PE = utf8proc_category_t.UTF8PROC_CATEGORY_PE;
enum UTF8PROC_CATEGORY_PI = utf8proc_category_t.UTF8PROC_CATEGORY_PI;
enum UTF8PROC_CATEGORY_PF = utf8proc_category_t.UTF8PROC_CATEGORY_PF;
enum UTF8PROC_CATEGORY_PO = utf8proc_category_t.UTF8PROC_CATEGORY_PO;
enum UTF8PROC_CATEGORY_SM = utf8proc_category_t.UTF8PROC_CATEGORY_SM;
enum UTF8PROC_CATEGORY_SC = utf8proc_category_t.UTF8PROC_CATEGORY_SC;
enum UTF8PROC_CATEGORY_SK = utf8proc_category_t.UTF8PROC_CATEGORY_SK;
enum UTF8PROC_CATEGORY_SO = utf8proc_category_t.UTF8PROC_CATEGORY_SO;
enum UTF8PROC_CATEGORY_ZS = utf8proc_category_t.UTF8PROC_CATEGORY_ZS;
enum UTF8PROC_CATEGORY_ZL = utf8proc_category_t.UTF8PROC_CATEGORY_ZL;
enum UTF8PROC_CATEGORY_ZP = utf8proc_category_t.UTF8PROC_CATEGORY_ZP;
enum UTF8PROC_CATEGORY_CC = utf8proc_category_t.UTF8PROC_CATEGORY_CC;
enum UTF8PROC_CATEGORY_CF = utf8proc_category_t.UTF8PROC_CATEGORY_CF;
enum UTF8PROC_CATEGORY_CS = utf8proc_category_t.UTF8PROC_CATEGORY_CS;
enum UTF8PROC_CATEGORY_CO = utf8proc_category_t.UTF8PROC_CATEGORY_CO;

/** Bidirectional character classes. */
enum utf8proc_bidi_class_t
{
	UTF8PROC_BIDI_CLASS_L = 1, /**< Left-to-Right */
	UTF8PROC_BIDI_CLASS_LRE = 2, /**< Left-to-Right Embedding */
	UTF8PROC_BIDI_CLASS_LRO = 3, /**< Left-to-Right Override */
	UTF8PROC_BIDI_CLASS_R = 4, /**< Right-to-Left */
	UTF8PROC_BIDI_CLASS_AL = 5, /**< Right-to-Left Arabic */
	UTF8PROC_BIDI_CLASS_RLE = 6, /**< Right-to-Left Embedding */
	UTF8PROC_BIDI_CLASS_RLO = 7, /**< Right-to-Left Override */
	UTF8PROC_BIDI_CLASS_PDF = 8, /**< Pop Directional Format */
	UTF8PROC_BIDI_CLASS_EN = 9, /**< European Number */
	UTF8PROC_BIDI_CLASS_ES = 10, /**< European Separator */
	UTF8PROC_BIDI_CLASS_ET = 11, /**< European Number Terminator */
	UTF8PROC_BIDI_CLASS_AN = 12, /**< Arabic Number */
	UTF8PROC_BIDI_CLASS_CS = 13, /**< Common Number Separator */
	UTF8PROC_BIDI_CLASS_NSM = 14, /**< Nonspacing Mark */
	UTF8PROC_BIDI_CLASS_BN = 15, /**< Boundary Neutral */
	UTF8PROC_BIDI_CLASS_B = 16, /**< Paragraph Separator */
	UTF8PROC_BIDI_CLASS_S = 17, /**< Segment Separator */
	UTF8PROC_BIDI_CLASS_WS = 18, /**< Whitespace */
	UTF8PROC_BIDI_CLASS_ON = 19, /**< Other Neutrals */
	UTF8PROC_BIDI_CLASS_LRI = 20, /**< Left-to-Right Isolate */
	UTF8PROC_BIDI_CLASS_RLI = 21, /**< Right-to-Left Isolate */
	UTF8PROC_BIDI_CLASS_FSI = 22, /**< First Strong Isolate */
	UTF8PROC_BIDI_CLASS_PDI = 23, /**< Pop Directional Isolate */



}

enum UTF8PROC_BIDI_CLASS_L = utf8proc_bidi_class_t.UTF8PROC_BIDI_CLASS_L;
enum UTF8PROC_BIDI_CLASS_LRE = utf8proc_bidi_class_t.UTF8PROC_BIDI_CLASS_LRE;
enum UTF8PROC_BIDI_CLASS_LRO = utf8proc_bidi_class_t.UTF8PROC_BIDI_CLASS_LRO;
enum UTF8PROC_BIDI_CLASS_R = utf8proc_bidi_class_t.UTF8PROC_BIDI_CLASS_R;
enum UTF8PROC_BIDI_CLASS_AL = utf8proc_bidi_class_t.UTF8PROC_BIDI_CLASS_AL;
enum UTF8PROC_BIDI_CLASS_RLE = utf8proc_bidi_class_t.UTF8PROC_BIDI_CLASS_RLE;
enum UTF8PROC_BIDI_CLASS_RLO = utf8proc_bidi_class_t.UTF8PROC_BIDI_CLASS_RLO;
enum UTF8PROC_BIDI_CLASS_PDF = utf8proc_bidi_class_t.UTF8PROC_BIDI_CLASS_PDF;
enum UTF8PROC_BIDI_CLASS_EN = utf8proc_bidi_class_t.UTF8PROC_BIDI_CLASS_EN;
enum UTF8PROC_BIDI_CLASS_ES = utf8proc_bidi_class_t.UTF8PROC_BIDI_CLASS_ES;
enum UTF8PROC_BIDI_CLASS_ET = utf8proc_bidi_class_t.UTF8PROC_BIDI_CLASS_ET;
enum UTF8PROC_BIDI_CLASS_AN = utf8proc_bidi_class_t.UTF8PROC_BIDI_CLASS_AN;
enum UTF8PROC_BIDI_CLASS_CS = utf8proc_bidi_class_t.UTF8PROC_BIDI_CLASS_CS;
enum UTF8PROC_BIDI_CLASS_NSM = utf8proc_bidi_class_t.UTF8PROC_BIDI_CLASS_NSM;
enum UTF8PROC_BIDI_CLASS_BN = utf8proc_bidi_class_t.UTF8PROC_BIDI_CLASS_BN;
enum UTF8PROC_BIDI_CLASS_B = utf8proc_bidi_class_t.UTF8PROC_BIDI_CLASS_B;
enum UTF8PROC_BIDI_CLASS_S = utf8proc_bidi_class_t.UTF8PROC_BIDI_CLASS_S;
enum UTF8PROC_BIDI_CLASS_WS = utf8proc_bidi_class_t.UTF8PROC_BIDI_CLASS_WS;
enum UTF8PROC_BIDI_CLASS_ON = utf8proc_bidi_class_t.UTF8PROC_BIDI_CLASS_ON;
enum UTF8PROC_BIDI_CLASS_LRI = utf8proc_bidi_class_t.UTF8PROC_BIDI_CLASS_LRI;
enum UTF8PROC_BIDI_CLASS_RLI = utf8proc_bidi_class_t.UTF8PROC_BIDI_CLASS_RLI;
enum UTF8PROC_BIDI_CLASS_FSI = utf8proc_bidi_class_t.UTF8PROC_BIDI_CLASS_FSI;
enum UTF8PROC_BIDI_CLASS_PDI = utf8proc_bidi_class_t.UTF8PROC_BIDI_CLASS_PDI;

/** Decomposition type. */
enum utf8proc_decomp_type_t
{
	UTF8PROC_DECOMP_TYPE_FONT = 1, /**< Font */
	UTF8PROC_DECOMP_TYPE_NOBREAK = 2, /**< Nobreak */
	UTF8PROC_DECOMP_TYPE_INITIAL = 3, /**< Initial */
	UTF8PROC_DECOMP_TYPE_MEDIAL = 4, /**< Medial */
	UTF8PROC_DECOMP_TYPE_FINAL = 5, /**< Final */
	UTF8PROC_DECOMP_TYPE_ISOLATED = 6, /**< Isolated */
	UTF8PROC_DECOMP_TYPE_CIRCLE = 7, /**< Circle */
	UTF8PROC_DECOMP_TYPE_SUPER = 8, /**< Super */
	UTF8PROC_DECOMP_TYPE_SUB = 9, /**< Sub */
	UTF8PROC_DECOMP_TYPE_VERTICAL = 10, /**< Vertical */
	UTF8PROC_DECOMP_TYPE_WIDE = 11, /**< Wide */
	UTF8PROC_DECOMP_TYPE_NARROW = 12, /**< Narrow */
	UTF8PROC_DECOMP_TYPE_SMALL = 13, /**< Small */
	UTF8PROC_DECOMP_TYPE_SQUARE = 14, /**< Square */
	UTF8PROC_DECOMP_TYPE_FRACTION = 15, /**< Fraction */
	UTF8PROC_DECOMP_TYPE_COMPAT = 16, /**< Compat */



}

enum UTF8PROC_DECOMP_TYPE_FONT = utf8proc_decomp_type_t.UTF8PROC_DECOMP_TYPE_FONT;
enum UTF8PROC_DECOMP_TYPE_NOBREAK = utf8proc_decomp_type_t.UTF8PROC_DECOMP_TYPE_NOBREAK;
enum UTF8PROC_DECOMP_TYPE_INITIAL = utf8proc_decomp_type_t.UTF8PROC_DECOMP_TYPE_INITIAL;
enum UTF8PROC_DECOMP_TYPE_MEDIAL = utf8proc_decomp_type_t.UTF8PROC_DECOMP_TYPE_MEDIAL;
enum UTF8PROC_DECOMP_TYPE_FINAL = utf8proc_decomp_type_t.UTF8PROC_DECOMP_TYPE_FINAL;
enum UTF8PROC_DECOMP_TYPE_ISOLATED = utf8proc_decomp_type_t.UTF8PROC_DECOMP_TYPE_ISOLATED;
enum UTF8PROC_DECOMP_TYPE_CIRCLE = utf8proc_decomp_type_t.UTF8PROC_DECOMP_TYPE_CIRCLE;
enum UTF8PROC_DECOMP_TYPE_SUPER = utf8proc_decomp_type_t.UTF8PROC_DECOMP_TYPE_SUPER;
enum UTF8PROC_DECOMP_TYPE_SUB = utf8proc_decomp_type_t.UTF8PROC_DECOMP_TYPE_SUB;
enum UTF8PROC_DECOMP_TYPE_VERTICAL = utf8proc_decomp_type_t.UTF8PROC_DECOMP_TYPE_VERTICAL;
enum UTF8PROC_DECOMP_TYPE_WIDE = utf8proc_decomp_type_t.UTF8PROC_DECOMP_TYPE_WIDE;
enum UTF8PROC_DECOMP_TYPE_NARROW = utf8proc_decomp_type_t.UTF8PROC_DECOMP_TYPE_NARROW;
enum UTF8PROC_DECOMP_TYPE_SMALL = utf8proc_decomp_type_t.UTF8PROC_DECOMP_TYPE_SMALL;
enum UTF8PROC_DECOMP_TYPE_SQUARE = utf8proc_decomp_type_t.UTF8PROC_DECOMP_TYPE_SQUARE;
enum UTF8PROC_DECOMP_TYPE_FRACTION = utf8proc_decomp_type_t.UTF8PROC_DECOMP_TYPE_FRACTION;
enum UTF8PROC_DECOMP_TYPE_COMPAT = utf8proc_decomp_type_t.UTF8PROC_DECOMP_TYPE_COMPAT;

/** Boundclass property. (TR29) */
enum utf8proc_boundclass_t
{
	UTF8PROC_BOUNDCLASS_START = 0, /**< Start */
	UTF8PROC_BOUNDCLASS_OTHER = 1, /**< Other */
	UTF8PROC_BOUNDCLASS_CR = 2, /**< Cr */
	UTF8PROC_BOUNDCLASS_LF = 3, /**< Lf */
	UTF8PROC_BOUNDCLASS_CONTROL = 4, /**< Control */
	UTF8PROC_BOUNDCLASS_EXTEND = 5, /**< Extend */
	UTF8PROC_BOUNDCLASS_L = 6, /**< L */
	UTF8PROC_BOUNDCLASS_V = 7, /**< V */
	UTF8PROC_BOUNDCLASS_T = 8, /**< T */
	UTF8PROC_BOUNDCLASS_LV = 9, /**< Lv */
	UTF8PROC_BOUNDCLASS_LVT = 10, /**< Lvt */
	UTF8PROC_BOUNDCLASS_REGIONAL_INDICATOR = 11, /**< Regional indicator */
	UTF8PROC_BOUNDCLASS_SPACINGMARK = 12, /**< Spacingmark */
	UTF8PROC_BOUNDCLASS_PREPEND = 13, /**< Prepend */
	UTF8PROC_BOUNDCLASS_ZWJ = 14, /**< Zero Width Joiner */
	UTF8PROC_BOUNDCLASS_E_BASE = 15, /**< Emoji Base */
	UTF8PROC_BOUNDCLASS_E_MODIFIER = 16, /**< Emoji Modifier */
	UTF8PROC_BOUNDCLASS_GLUE_AFTER_ZWJ = 17, /**< Glue_After_ZWJ */
	UTF8PROC_BOUNDCLASS_E_BASE_GAZ = 18, /**< E_BASE + GLUE_AFTER_ZJW */



}

enum UTF8PROC_BOUNDCLASS_START = utf8proc_boundclass_t.UTF8PROC_BOUNDCLASS_START;
enum UTF8PROC_BOUNDCLASS_OTHER = utf8proc_boundclass_t.UTF8PROC_BOUNDCLASS_OTHER;
enum UTF8PROC_BOUNDCLASS_CR = utf8proc_boundclass_t.UTF8PROC_BOUNDCLASS_CR;
enum UTF8PROC_BOUNDCLASS_LF = utf8proc_boundclass_t.UTF8PROC_BOUNDCLASS_LF;
enum UTF8PROC_BOUNDCLASS_CONTROL = utf8proc_boundclass_t.UTF8PROC_BOUNDCLASS_CONTROL;
enum UTF8PROC_BOUNDCLASS_EXTEND = utf8proc_boundclass_t.UTF8PROC_BOUNDCLASS_EXTEND;
enum UTF8PROC_BOUNDCLASS_L = utf8proc_boundclass_t.UTF8PROC_BOUNDCLASS_L;
enum UTF8PROC_BOUNDCLASS_V = utf8proc_boundclass_t.UTF8PROC_BOUNDCLASS_V;
enum UTF8PROC_BOUNDCLASS_T = utf8proc_boundclass_t.UTF8PROC_BOUNDCLASS_T;
enum UTF8PROC_BOUNDCLASS_LV = utf8proc_boundclass_t.UTF8PROC_BOUNDCLASS_LV;
enum UTF8PROC_BOUNDCLASS_LVT = utf8proc_boundclass_t.UTF8PROC_BOUNDCLASS_LVT;
enum UTF8PROC_BOUNDCLASS_REGIONAL_INDICATOR = utf8proc_boundclass_t
		.UTF8PROC_BOUNDCLASS_REGIONAL_INDICATOR;
enum UTF8PROC_BOUNDCLASS_SPACINGMARK = utf8proc_boundclass_t.UTF8PROC_BOUNDCLASS_SPACINGMARK;
enum UTF8PROC_BOUNDCLASS_PREPEND = utf8proc_boundclass_t.UTF8PROC_BOUNDCLASS_PREPEND;
enum UTF8PROC_BOUNDCLASS_ZWJ = utf8proc_boundclass_t.UTF8PROC_BOUNDCLASS_ZWJ;
enum UTF8PROC_BOUNDCLASS_E_BASE = utf8proc_boundclass_t.UTF8PROC_BOUNDCLASS_E_BASE;
enum UTF8PROC_BOUNDCLASS_E_MODIFIER = utf8proc_boundclass_t.UTF8PROC_BOUNDCLASS_E_MODIFIER;
enum UTF8PROC_BOUNDCLASS_GLUE_AFTER_ZWJ = utf8proc_boundclass_t.UTF8PROC_BOUNDCLASS_GLUE_AFTER_ZWJ;
enum UTF8PROC_BOUNDCLASS_E_BASE_GAZ = utf8proc_boundclass_t.UTF8PROC_BOUNDCLASS_E_BASE_GAZ;

/**
 * Function pointer type passed to @ref utf8proc_map_custom and
 * @ref utf8proc_decompose_custom, which is used to specify a user-defined
 * mapping of codepoints to be applied in conjunction with other mappings.
 */
alias utf8proc_custom_func = utf8proc_int32_t function(utf8proc_int32_t codepoint, void* data);
