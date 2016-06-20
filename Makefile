BD = mixtures
HTML_FILES = index.php menu.php css html
WEB_LOCAL = /var/www/
WEB_AMA = /media/Synology/home/www/mixtures/

all: html

html: md
	$(info Building Markdown...)
	./mixtures/md2web.py

md: ;

web_local: html
	$(info Web Local in $(WEB_LOCAL)) 
	@cp -rv $(addprefix $(BD)/, $(HTML_FILES)) $(WEB_LOCAL)

web_ama: html
	$(info Web Local in $(WEB_AMA)) 
	@cp -rv $(addprefix $(BD)/, $(HTML_FILES))  $(WEB_AMA)

clean: ;
