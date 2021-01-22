
all: development-process.svg release-sequence.svg audit-bosh.svg audit-cloudfoundry.svg

development-process.svg: development-process.diag
	blockdiag -o development-process.svg -T SVG development-process.diag

release-sequence.svg: release-sequence.diag
	seqdiag -o release-sequence.svg -T svg release-sequence.diag

audit-bosh.svg: audit-bosh.dot
	dot -Tsvg audit-bosh.dot -oaudit-bosh.svg

audit-cloudfoundry.svg: audit-cloudfoundry.dot
	dot -Tsvg audit-cloudfoundry.dot -oaudit-cloudfoundry.svg
