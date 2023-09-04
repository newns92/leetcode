/*
Find how many times each artist appeared on the Spotify ranking list
Output the artist name along with the corresponding number of occurrences.
Order records by the number of occurrences in descending order.

spotify_worldwide_daily_song_ranking:
id:         int
position:   int
trackname:  varchar
artist:     varchar
streams:    int
url:        varchar
date:       datetime
region:     varchar
*/

SELECT
    artist,
    COUNT(id)
FROM spotify_worldwide_daily_song_ranking
GROUP BY artist
ORDER BY COUNT(id) DESC
;