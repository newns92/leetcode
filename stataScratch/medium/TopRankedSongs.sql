/*
Find songs that have ranked in the top position. Output the track name and the number of times it ranked at the top. 

Sort your records by the number of times the song was in the top position in descending order.

spotify_worldwide_daily_song_ranking
id:         int
position:   int
trackname:  varchar
artist:     varchar
streams:    int
url:        varchar
date:       datetime
region:     varchar
*/


-- -- TESTING TO SEE IF SONGS ACTUALLY SHOW UP MORE THAN ONCE
-- SELECT
--     trackname,
--     COUNT(trackname)
-- FROM spotify_worldwide_daily_song_ranking
-- GROUP BY trackname
-- ORDER BY COUNT(trackname) DESC
-- LIMIT 5
-- ;

SELECT
    trackname,
    COUNT(trackname) AS times_top1
FROM spotify_worldwide_daily_song_ranking
WHERE position = 1
GROUP BY trackname
ORDER BY times_top1 DESC
-- LIMIT 5
;