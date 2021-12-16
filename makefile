PORT=usb
MCU=atmega328pb
CFLAGS=-g -Wall -mcall-prologues -mmcu=$(MCU) -Os -B atmega328pb/ -I include/
LDFLAGS=-Wl,-gc-sections -Wl,-relax
PROGRAMMER=xplainedmini
CC=avr-gcc
TARGET=main
OBJECT_FILES=main.o

all: $(TARGET).hex

clean:
	rm -f *.o *.hex *.obj *.hex

%.hex: %.obj
	avr-objcopy -R .eeprom -O ihex $< $@

%.obj: $(OBJECT_FILES)
	$(CC) $(CFLAGS) $(OBJECT_FILES) $(LDFLAGS) -o $@

program: $(TARGET).hex
	avrdude -p $(MCU) -c $(PROGRAMMER) -C m328pb.conf -P $(PORT) -U flash:w:$(TARGET).hex
	make clean
