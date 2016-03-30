
all: development-process.svg release-sequence.svg

development-process.svg: development-process.diag
	blockdiag -o development-process.svg -T SVG development-process.diag

release-sequence.svg: release-sequence.diag
	seqdiag -o release-sequence.svg -T svg release-sequence.diag
