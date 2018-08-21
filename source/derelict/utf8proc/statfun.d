module derelict.utf8proc.statfun;

version (Derelict_Static) version = DerelictUTF8Proc_Static;
version (DerelictUTF8Proc_Static)  : public import derelict.utf8proc.types;

extern (C) @nogc nothrow
{
	/**
 * Array containing the byte lengths of a UTF-8 encoded codepoint based
 * on the first byte.
 */
	extern const utf8proc_int8_t[256] utf8proc_utf8class;

	/**
 * Returns the utf8proc API version as a string MAJOR.MINOR.PATCH
 * (http://semver.org format), possibly with a "-dev" suffix for
 * development versions.
 */
	extern const(char)* utf8proc_version();

	/**
 * Returns an informative error string for the given utf8proc error code
 * (e.g. the error codes returned by @ref utf8proc_map).
 */
	extern const(char)* utf8proc_errmsg(utf8proc_ssize_t errcode);

	/**
 * Reads a single codepoint from the UTF-8 sequence being pointed to by `str`.
 * The maximum number of bytes read is `strlen`, unless `strlen` is
 * negative (in which case up to 4 bytes are read).
 *
 * If a valid codepoint could be read, it is stored in the variable
 * pointed to by `codepoint_ref`, otherwise that variable will be set to -1.
 * In case of success, the number of bytes read is returned; otherwise, a
 * negative error code is returned.
 */
	extern utf8proc_ssize_t utf8proc_iterate(const utf8proc_uint8_t* str,
			utf8proc_ssize_t strlen, utf8proc_int32_t* codepoint_ref);

	/**
 * Check if a codepoint is valid (regardless of whether it has been
 * assigned a value by the current Unicode standard).
 *
 * @return 1 if the given `codepoint` is valid and otherwise return 0.
 */
	extern utf8proc_bool utf8proc_codepoint_valid(utf8proc_int32_t codepoint);

	/**
 * Encodes the codepoint as an UTF-8 string in the byte array pointed
 * to by `dst`. This array must be at least 4 bytes long.
 *
 * In case of success the number of bytes written is returned, and
 * otherwise 0 is returned.
 *
 * This function does not check whether `codepoint` is valid Unicode.
 */
	extern utf8proc_ssize_t utf8proc_encode_char(utf8proc_int32_t codepoint, utf8proc_uint8_t* dst);

	/**
 * Look up the properties for a given codepoint.
 *
 * @param codepoint The Unicode codepoint.
 *
 * @returns
 * A pointer to a (constant) struct containing information about
 * the codepoint.
 * @par
 * If the codepoint is unassigned or invalid, a pointer to a special struct is
 * returned in which `category` is 0 (@ref UTF8PROC_CATEGORY_CN).
 */
	extern const(utf8proc_property_t)* utf8proc_get_property(utf8proc_int32_t codepoint);

	/** Decompose a codepoint into an array of codepoints.
 *
 * @param codepoint the codepoint.
 * @param dst the destination buffer.
 * @param bufsize the size of the destination buffer.
 * @param options one or more of the following flags:
 * - @ref UTF8PROC_REJECTNA  - return an error `codepoint` is unassigned
 * - @ref UTF8PROC_IGNORE    - strip "default ignorable" codepoints
 * - @ref UTF8PROC_CASEFOLD  - apply Unicode casefolding
 * - @ref UTF8PROC_COMPAT    - replace certain codepoints with their
 *                             compatibility decomposition
 * - @ref UTF8PROC_CHARBOUND - insert 0xFF bytes before each grapheme cluster
 * - @ref UTF8PROC_LUMP      - lump certain different codepoints together
 * - @ref UTF8PROC_STRIPMARK - remove all character marks
 * @param last_boundclass
 * Pointer to an integer variable containing
 * the previous codepoint's boundary class if the @ref UTF8PROC_CHARBOUND
 * option is used.  Otherwise, this parameter is ignored.
 *
 * @return
 * In case of success, the number of codepoints written is returned; in case
 * of an error, a negative error code is returned (@ref utf8proc_errmsg).
 * @par
 * If the number of written codepoints would be bigger than `bufsize`, the
 * required buffer size is returned, while the buffer will be overwritten with
 * undefined data.
 */
	extern utf8proc_ssize_t utf8proc_decompose_char(utf8proc_int32_t codepoint,
			utf8proc_int32_t* dst, utf8proc_ssize_t bufsize, utf8proc_option_t options,
			int* last_boundclass);

	/**
 * The same as @ref utf8proc_decompose_char, but acts on a whole UTF-8
 * string and orders the decomposed sequences correctly.
 *
 * If the @ref UTF8PROC_NULLTERM flag in `options` is set, processing
 * will be stopped, when a NULL byte is encounted, otherwise `strlen`
 * bytes are processed.  The result (in the form of 32-bit unicode
 * codepoints) is written into the buffer being pointed to by
 * `buffer` (which must contain at least `bufsize` entries).  In case of
 * success, the number of codepoints written is returned; in case of an
 * error, a negative error code is returned (@ref utf8proc_errmsg).
 * See @ref utf8proc_decompose_custom to supply additional transformations.
 *
 * If the number of written codepoints would be bigger than `bufsize`, the
 * required buffer size is returned, while the buffer will be overwritten with
 * undefined data.
 */
	extern utf8proc_ssize_t utf8proc_decompose(const utf8proc_uint8_t* str, utf8proc_ssize_t strlen,
			utf8proc_int32_t* buffer, utf8proc_ssize_t bufsize, utf8proc_option_t options);

	/**
 * The same as @ref utf8proc_decompose, but also takes a `custom_func` mapping function
 * that is called on each codepoint in `str` before any other transformations
 * (along with a `custom_data` pointer that is passed through to `custom_func`).
 * The `custom_func` argument is ignored if it is `NULL`.  See also @ref utf8proc_map_custom.
 */
	extern utf8proc_ssize_t utf8proc_decompose_custom(const utf8proc_uint8_t* str,
			utf8proc_ssize_t strlen, utf8proc_int32_t* buffer,
			utf8proc_ssize_t bufsize, utf8proc_option_t options,
			utf8proc_custom_func custom_func, void* custom_data);

	/**
 * Normalizes the sequence of `length` codepoints pointed to by `buffer`
 * in-place (i.e., the result is also stored in `buffer`).
 *
 * @param buffer the (native-endian UTF-32) unicode codepoints to re-encode.
 * @param length the length (in codepoints) of the buffer.
 * @param options a bitwise or (`|`) of one or more of the following flags:
 * - @ref UTF8PROC_NLF2LS  - convert LF, CRLF, CR and NEL into LS
 * - @ref UTF8PROC_NLF2PS  - convert LF, CRLF, CR and NEL into PS
 * - @ref UTF8PROC_NLF2LF  - convert LF, CRLF, CR and NEL into LF
 * - @ref UTF8PROC_STRIPCC - strip or convert all non-affected control characters
 * - @ref UTF8PROC_COMPOSE - try to combine decomposed codepoints into composite
 *                           codepoints
 * - @ref UTF8PROC_STABLE  - prohibit combining characters that would violate
 *                           the unicode versioning stability
 *
 * @return
 * In case of success, the length (in codepoints) of the normalized UTF-32 string is
 * returned; otherwise, a negative error code is returned (@ref utf8proc_errmsg).
 *
 * @warning The entries of the array pointed to by `str` have to be in the
 *          range `0x0000` to `0x10FFFF`. Otherwise, the program might crash!
 */
	extern utf8proc_ssize_t utf8proc_normalize_utf32(utf8proc_int32_t* buffer,
			utf8proc_ssize_t length, utf8proc_option_t options);

	/**
 * Reencodes the sequence of `length` codepoints pointed to by `buffer`
 * UTF-8 data in-place (i.e., the result is also stored in `buffer`).
 * Can optionally normalize the UTF-32 sequence prior to UTF-8 conversion.
 *
 * @param buffer the (native-endian UTF-32) unicode codepoints to re-encode.
 * @param length the length (in codepoints) of the buffer.
 * @param options a bitwise or (`|`) of one or more of the following flags:
 * - @ref UTF8PROC_NLF2LS  - convert LF, CRLF, CR and NEL into LS
 * - @ref UTF8PROC_NLF2PS  - convert LF, CRLF, CR and NEL into PS
 * - @ref UTF8PROC_NLF2LF  - convert LF, CRLF, CR and NEL into LF
 * - @ref UTF8PROC_STRIPCC - strip or convert all non-affected control characters
 * - @ref UTF8PROC_COMPOSE - try to combine decomposed codepoints into composite
 *                           codepoints
 * - @ref UTF8PROC_STABLE  - prohibit combining characters that would violate
 *                           the unicode versioning stability
 * - @ref UTF8PROC_CHARBOUND - insert 0xFF bytes before each grapheme cluster
 *
 * @return
 * In case of success, the length (in bytes) of the resulting nul-terminated
 * UTF-8 string is returned; otherwise, a negative error code is returned
 * (@ref utf8proc_errmsg).
 *
 * @warning The amount of free space pointed to by `buffer` must
 *          exceed the amount of the input data by one byte, and the
 *          entries of the array pointed to by `str` have to be in the
 *          range `0x0000` to `0x10FFFF`. Otherwise, the program might crash!
 */
	extern utf8proc_ssize_t utf8proc_reencode(utf8proc_int32_t* buffer,
			utf8proc_ssize_t length, utf8proc_option_t options);

	/**
 * Given a pair of consecutive codepoints, return whether a grapheme break is
 * permitted between them (as defined by the extended grapheme clusters in UAX#29).
 *
 * @param state Beginning with Version 29 (Unicode 9.0.0), this algorithm requires
 *              state to break graphemes. This state can be passed in as a pointer
 *              in the `state` argument and should initially be set to 0. If the
 *              state is not passed in (i.e. a null pointer is passed), UAX#29 rules
 *              GB10/12/13 which require this state will not be applied, essentially
 *              matching the rules in Unicode 8.0.0.
 *
 * @warning If the state parameter is used, `utf8proc_grapheme_break_stateful` must
 *          be called IN ORDER on ALL potential breaks in a string.
 */
	extern utf8proc_bool utf8proc_grapheme_break_stateful(utf8proc_int32_t codepoint1,
			utf8proc_int32_t codepoint2, utf8proc_int32_t* state);

	/**
 * Same as @ref utf8proc_grapheme_break_stateful, except without support for the
 * Unicode 9 additions to the algorithm. Supported for legacy reasons.
 */
	extern utf8proc_bool utf8proc_grapheme_break(utf8proc_int32_t codepoint1,
			utf8proc_int32_t codepoint2);

	/**
 * Given a codepoint `c`, return the codepoint of the corresponding
 * lower-case character, if any; otherwise (if there is no lower-case
 * variant, or if `c` is not a valid codepoint) return `c`.
 */
	extern utf8proc_int32_t utf8proc_tolower(utf8proc_int32_t c);

	/**
 * Given a codepoint `c`, return the codepoint of the corresponding
 * upper-case character, if any; otherwise (if there is no upper-case
 * variant, or if `c` is not a valid codepoint) return `c`.
 */
	extern utf8proc_int32_t utf8proc_toupper(utf8proc_int32_t c);

	/**
 * Given a codepoint `c`, return the codepoint of the corresponding
 * title-case character, if any; otherwise (if there is no title-case
 * variant, or if `c` is not a valid codepoint) return `c`.
 */
	extern utf8proc_int32_t utf8proc_totitle(utf8proc_int32_t c);

	/**
 * Given a codepoint, return a character width analogous to `wcwidth(codepoint)`,
 * except that a width of 0 is returned for non-printable codepoints
 * instead of -1 as in `wcwidth`.
 *
 * @note
 * If you want to check for particular types of non-printable characters,
 * (analogous to `isprint` or `iscntrl`), use @ref utf8proc_category. */
	extern int utf8proc_charwidth(utf8proc_int32_t codepoint);

	/**
 * Return the Unicode category for the codepoint (one of the
 * @ref utf8proc_category_t constants.)
 */
	extern utf8proc_category_t utf8proc_category(utf8proc_int32_t codepoint);

	/**
 * Return the two-letter (nul-terminated) Unicode category string for
 * the codepoint (e.g. `"Lu"` or `"Co"`).
 */
	extern const(char)* utf8proc_category_string(utf8proc_int32_t codepoint);

	/**
 * Maps the given UTF-8 string pointed to by `str` to a new UTF-8
 * string, allocated dynamically by `malloc` and returned via `dstptr`.
 *
 * If the @ref UTF8PROC_NULLTERM flag in the `options` field is set,
 * the length is determined by a NULL terminator, otherwise the
 * parameter `strlen` is evaluated to determine the string length, but
 * in any case the result will be NULL terminated (though it might
 * contain NULL characters with the string if `str` contained NULL
 * characters). Other flags in the `options` field are passed to the
 * functions defined above, and regarded as described.  See also
 * @ref utfproc_map_custom to supply a custom codepoint transformation.
 *
 * In case of success the length of the new string is returned,
 * otherwise a negative error code is returned.
 *
 * @note The memory of the new UTF-8 string will have been allocated
 * with `malloc`, and should therefore be deallocated with `free`.
 */
	extern utf8proc_ssize_t utf8proc_map(const utf8proc_uint8_t* str,
			utf8proc_ssize_t strlen, utf8proc_uint8_t** dstptr, utf8proc_option_t options);

	/**
 * Like @ref utf8proc_map, but also takes a `custom_func` mapping function
 * that is called on each codepoint in `str` before any other transformations
 * (along with a `custom_data` pointer that is passed through to `custom_func`).
 * The `custom_func` argument is ignored if it is `NULL`.
 */
	extern utf8proc_ssize_t utf8proc_map_custom(const utf8proc_uint8_t* str,
			utf8proc_ssize_t strlen, utf8proc_uint8_t** dstptr,
			utf8proc_option_t options, utf8proc_custom_func custom_func, void* custom_data);

	/** @name Unicode normalization
 *
 * Returns a pointer to newly allocated memory of a NFD, NFC, NFKD or NFKC
 * normalized version of the null-terminated string `str`.  These
 * are shortcuts to calling @ref utf8proc_map with @ref UTF8PROC_NULLTERM
 * combined with @ref UTF8PROC_STABLE and flags indicating the normalization.
 */
	/** @{ */
	/** NFD normalization (@ref UTF8PROC_DECOMPOSE). */
	extern utf8proc_uint8_t* utf8proc_NFD(const utf8proc_uint8_t* str);
	/** NFC normalization (@ref UTF8PROC_COMPOSE). */
	extern utf8proc_uint8_t* utf8proc_NFC(const utf8proc_uint8_t* str);
	/** NFKD normalization (@ref UTF8PROC_DECOMPOSE and @ref UTF8PROC_COMPAT). */
	extern utf8proc_uint8_t* utf8proc_NFKD(const utf8proc_uint8_t* str);
	/** NFKC normalization (@ref UTF8PROC_COMPOSE and @ref UTF8PROC_COMPAT). */
	extern utf8proc_uint8_t* utf8proc_NFKC(const utf8proc_uint8_t* str);
	/** @} */
}
