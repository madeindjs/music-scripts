install:
	cp music-library-export.sh /usr/local/bin/music-library-export
	chmod u+x music-library-export /usr/local/bin/music-library-export
	pandoc music-library-export.md -t man | gzip > /usr/local/man/music-library-export.1.gz

uninstall:
	rm  /usr/local/bin/music-library-export /usr/local/man/music-library-export.1


