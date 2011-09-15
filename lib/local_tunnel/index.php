<?php

$links = array(
  "Ten" => "http://ten.com.au/api/rest/session?key=movideoNetwork10&applicationalias=main-player",
  "OneHd" => "http://api.v2.movideo.com/rest/session?key=movideoOneHd&applicationalias=onehd-cutv-universal-flash",
  "Eleven" => "http://api.movideo.com/rest/session?key=movideoEleven&applicationalias=eleven-twix-flash&includeApplication=true",
  "Neighbours" => "http://api.movideo.com/rest/session?key=movideoNeighbours&applicationalias=neighbours-universal-flash",
  "Stargate Universe" => "http://api.v2.movideo.com/rest/session?key=movideoEleven&applicationalias=eleven-stargate",
  "Masterchef" => "http://api.v2.movideo.com/rest/session?key=movideoMasterChef&applicationalias=masterchef-2011",
  "The 7PM Project" => "http://api.v2.movideo.com/rest/session?key=movideo7pmProject&applicationalias=7pmproject-universal-flash",
  "Ready Steady Cook" => "http://api.v2.movideo.com/rest/session?key=movideo10&applicationalias=ready-steady-cook",
  "The Biggest Loser" => "",
  "The Circle" => "",
  "The Renovators" => "http://api.v2.movideo.com/rest/session\?key\=movideoRenovators\&applicationalias\=renovators-universal-flash"
);

import_request_variables('G', 'get_parameter_');


function get_url_contents($url){
        $crl = curl_init();
        $timeout = 5;
        curl_setopt ($crl, CURLOPT_URL,$url);
        curl_setopt ($crl, CURLOPT_RETURNTRANSFER, 1);
        // curl_setopt ($crl, CURLOPT_HEADER, 1);
        curl_setopt ($crl, CURLOPT_CONNECTTIMEOUT, $timeout);
        $ret = curl_exec($crl);
        curl_close($crl);
        return $ret;
}

if(array_search($get_parameter_link, $links))
{
  echo get_url_contents($get_parameter_link);
}
else
{
  echo "Unknown: ";
  echo $get_parameter_link;
}
?>

