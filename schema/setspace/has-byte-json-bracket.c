/*
 *  Synopsis:
 *	Byte stream matches perl pattern: /^\s*[.*]\s$/s or /^\s{.*\s*$/s
 *  Usage:
 *  	is-byte-json-rootudigish <BLOB
 *  Exit Status:
 *	0	matches at least one udig in input stream.
 *	1	does not match udig in input stream.
 *	2	bad argument count on command line
 *	3	bad read(0)
 *	4	impossible error
 *  Blame:
 *  	jmscott@setspace.com
 *  	setspace@gmail.com
 */
#include <string.h>
#include <errno.h>
#include <unistd.h>

#define IS_WHITE(c) ((c) == ' ' || (c) == '\n' || (c) == '\t' || (c) == '\r')
#define IS_OPEN(c) ((c) == '[' || (c) == '{')

#define ST_BEFORE_OPEN	0
#define ST_BEFORE_CLOSE	1
#define ST_AFTER_CLOSE	2

#define SLURP		4096

#define EXIT_MATCH	0
#define EXIT_NO_MATCH	1
#define EXIT_BAD_ARGC	2
#define EXIT_BAD_READ	3
#define EXIT_WTF	4

/*
 * Synopsis:
 *  	Safe & simple string concatenator
 * Returns:
 * 	Number of non-null bytes consumed by buffer.
 *  Usage:
 *  	buf[0] = 0
 *  	_strcat(buf, sizeof buf, "hello, world");
 *  	_strcat(buf, sizeof buf, ": ");
 *  	_strcat(buf, sizeof buf, "good bye, cruel world");
 *  	write(2, buf, _strcat(buf, sizeof buf, "\n"));
 */

static int
_strcat(char *tgt, int tgtsize, char *src)
{
	char *tp = tgt;

	//  find null terminated end of target buffer
	while (*tp++)
		--tgtsize;
	--tp;

	//  copy non-null src bytes, leaving room for trailing null
	while (--tgtsize > 0 && *src)
		*tp++ = *src++;

	// target always null terminated
	*tp = 0;

	return tp - tgt;
}

static void
die(int status, char *msg)
{
	static char ERROR[] = "is-udigish: ERROR: ";
	char buf[256] = {0};

	_strcat(buf, sizeof buf, ERROR);
	_strcat(buf, sizeof buf, msg);

	write(2, buf, _strcat(buf, sizeof buf, "\n"));
	_exit(status);
}

static void
die2(int status, char *msg1, char *msg2)
{
	char msg[256] = {0};

	_strcat(msg, sizeof msg, msg1);
	_strcat(msg, sizeof msg, ": ");
	_strcat(msg, sizeof msg, msg2);

	die(status, msg);
}

static int
_read(unsigned char *buf, ssize_t nbytes)
{
	int nread;
again:
	nread = read(0, buf, nbytes);
	if (nread >= 0)
		return nread;
	if (errno == EINTR)
		goto again;
	die2(EXIT_BAD_READ, "read(0) failed", strerror(errno));

	//*NOTREACHED*/
	return 0;
}

int
main(int argc, char **argv)
{
	unsigned char buf[SLURP];
	int state = ST_BEFORE_OPEN;
	int nread;
	unsigned char c, c_close = 0;

	if (argc != 1)
		die(EXIT_BAD_ARGC, "wrong number of arguments");
	(void)argv;

	while ((nread = _read(buf, sizeof SLURP)) > 0) {

		unsigned char *p, *p_end;

		p = buf;
		p_end = p + nread;

		while (p < p_end) {
			c = *p++;

			switch (state) {
			case ST_BEFORE_OPEN:
				if (IS_WHITE(c))
					continue;
				if (!IS_OPEN(c))
					_exit(1);
				if (c == '[')
					c_close = ']';
				else
					c_close = '}';
				state = ST_BEFORE_CLOSE;
				break;
			case ST_BEFORE_CLOSE:
				if (c == c_close)
					state = ST_AFTER_CLOSE;
				break;
			case ST_AFTER_CLOSE:
				if (IS_WHITE(c) || c == c_close)
					continue;
				state = ST_BEFORE_CLOSE;
				break;
			default:
				die(EXIT_WTF, "impossible scan state");
			}
		}
	}
	_exit(state == ST_AFTER_CLOSE ? 0 : 1);
}