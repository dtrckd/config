// curl --socks5 127.0.0.1:1080 --cookie cookies.txt "wiki.vapwn.fr/doku.php?id=cuda_install&do=export_raw"
function FindProxyForURL(url, host) {
	if( shExpMatch(host,"*vapwn.fr") == true && shExpMatch(host,"*conf.vapwn.fr") == false )
		return "SOCKS 127.0.0.1:1080";
	else
		return "DIRECT";
}
