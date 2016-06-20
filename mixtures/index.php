<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd"> 
<html>
<head>
  <title>Pure Mixtures</title>
  <meta charset="UTF-8" />
  <link rel="stylesheet" href="css/highlight_md.css" />
  <link rel="stylesheet" href="css/git_md.css" />
  <!--<link rel="stylesheet" href="css/pure.css" />-->
  <link rel="stylesheet" href="css/split_screen.css" />
  <meta http-equiv=3D"content-type" content=3D"text/html; charset=3Dutf=-8">
</head>

<body>
    <?php
    $URI = parse_url($_SERVER['REQUEST_URI']);
    $page = pathinfo($URI['path'])['filename'];
    parse_str(html_entity_decode($URI['query']), $q );
    $q = $q['q'];
    if (empty($q))
    { 
        $q = 'tags_all';
    }
    ?>

    <div id="c_menu">
        <?php include("./menu.php"); ?> 
    </div>

    <div id="c_content" >
        <?php readfile("html/".$q.".html"); ?> 
    </div>
</body>

</html>

