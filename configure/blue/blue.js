function FindProxyForURL(url, host) {
	if( shExpMatch(host,"*vapwn.fr") == true && shExpMatch(host,"*conf.vapwn.fr") == false )
		return "SOCKS 127.0.0.1:1080";
	else
		return "DIRECT";
}
