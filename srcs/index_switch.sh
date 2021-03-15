#!/bin/bash

if grep "autoindex on" etc/nginx/sites-available/default ; then
	sed -i 's/autoindex on/autoindex off/g' etc/nginx/sites-available/default ;
	echo "autoindex off" ;
else
	sed -i 's/autoindex off/autoindex on/g' etc/nginx/sites-available/default ;
	echo "autoindex on" ;

fi

service nginx restart
