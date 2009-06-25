#define COLUMNS	80
#define LINES	24
#define STDATTR	0x02
#define VIDEO	0x000B8000
static volatile unsigned char	*video;
static volatile unsigned int	x_pos;
static volatile unsigned int	y_pos;
static void cls();
static void printc(char c);


int main() {
	unsigned char *msg = "Wello Horld!";
	int i;

	cls();
	while(*msg != '\0') {
		printc(*msg);
		msg++;
	}

	return;
}

static void cls() {
	int i;

	video = (unsigned char*)VIDEO;
	for(i = 0; i < COLUMNS * LINES * 2; i++)
		*(video + i) = 0;
	
	x_pos = 0;
	y_pos = 0;
}

static void printc(char c) {
	*(video + (x_pos + y_pos * COLUMNS) * 2) = c;
	*(video + (x_pos + y_pos * COLUMNS) * 2 + 1) = STDATTR;

	x_pos++;
	if(x_pos > COLUMNS) {
		x_pos = 0;
		y_pos++;
		if(y_pos > LINES) {
			x_pos = 0;
			y_pos = 0;
		}
	}
}
