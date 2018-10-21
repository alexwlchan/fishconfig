// https://stackoverflow.com/a/2880929/1558022
function getParameterByName(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}

term = getParameterByName(name = "query", url = window.url);
document.getElementById("title").innerHTML = "&ldquo;" + term + "&rdquo; results";
document.title = term;

var xmlHttp = new XMLHttpRequest();
xmlHttp.open(
  method = "GET",
  url = "https://itunes.apple.com/search?term=" + encodeURIComponent(term),
  async = false
);
xmlHttp.send(null);

obj = JSON.parse(xmlHttp.responseText);
urls = obj.results
  .map(function(row) { return row["artworkUrl100"] });
uniqueUrls = urls.filter(function(item, pos) {
  return urls.indexOf(item) == pos;
});
imageUrls = uniqueUrls.map(function(url) {
  return url.replace("100x100", "600x600")
});

resultsId = document.getElementById("results");

if (imageUrls.length == 0) {
  resultsId.innerHTML = "<p>No artwork found!</p>";
} else {
  resultsId.innerHTML = "";

  for (i = 0; i < imageUrls.length; i++) {
    imageUrl = imageUrls[i];
    resultsId.innerHTML += "<a href=\"" + imageUrl + "\"><img src=\"" + imageUrl + "\"></a>";
  }

  console.log(uniqueUrls);
}
