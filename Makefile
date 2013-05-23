targets = flowchart-basic.png
all: $(targets)

%.png: %.txt
	ditaa -s 1.7 -o $<

clean:
	$(RM) $(targets)
