/*
Assume there are 3 Spotify tables: artists, songs, and global_song_rank, which contain information about the artists, songs, and music charts, respectively.

Write a query to find the top 5 artists whose songs appear most frequently in the Top 10 of the global_song_rank table. 

Display the top 5 artist names in ascending order, along with their song appearance ranking.

Assumptions:
- If two or more artists have the same number of song appearances, they should be assigned the same ranking, and the rank numbers should be continuous (i.e. 1, 2, 2, 3, 4, 5).
- For instance, if both Ed Sheeran and Bad Bunny appear in the Top 10 five times, they should both be ranked 1st and the next artist should be ranked 2nd.

artists:
Column Name	    Type
artist_id	    integer
artist_name	    varchar

songs:
Column Name	    Type
song_id	        integer
artist_id	    integer

global_song_rank:
Column Name	    Type
day	            integer (1-52)
song_id	        integer
rank	        integer (1-1,000,000)
*/


-- ATTEMPT 1: 2 CTE's, COUNT and DENSE_RANK
With Top10Counts AS (
  SELECT
    artists.artist_name AS artist_name,
    -- songs.song_id AS song_id,
    -- global_song_rank.rank AS song_rank
    COUNT(songs.song_id) AS top10_count
  FROM artists
  LEFT JOIN songs ON
    artists.artist_id = songs.artist_id
  LEFT JOIN global_song_rank ON
    songs.song_id = global_song_rank.song_id
  -- appears in Top 10
  WHERE global_song_rank.rank <= 10
  GROUP BY artists.artist_name
),

Rankings AS (
  SELECT
    artist_name,
    -- NOTE: If 2+ artists have the same number of song appearances, they should 
    --  be assigned the same ranking, and the rank numbers should be continuous
    --    - i.e. 1, 2, 2, 3, 4, 5    
    DENSE_RANK() OVER(ORDER BY top10_count DESC) AS artist_rank
  FROM Top10Counts
)

SELECT
  artist_name,
  artist_rank
FROM Rankings
WHERE artist_rank <= 5
ORDER BY artist_rank ASC, artist_name ASC
;


-- GIVEN SOLUTION: Only 1 CTE, using COUNT() *withing* DENSE_RANK()
With Top10Counts AS (
  SELECT
    artists.artist_name AS artist_name,
    -- songs.song_id AS song_id,
    -- global_song_rank.rank AS song_rank
    -- NOTE: If 2+ artists have the same number of song appearances, they should 
    --  be assigned the same ranking, and the rank numbers should be continuous
    --    - i.e. 1, 2, 2, 3, 4, 5
    DENSE_RANK() OVER(ORDER BY COUNT(songs.song_id) DESC) AS artist_rank
  FROM artists
  LEFT JOIN songs ON
    artists.artist_id = songs.artist_id
  LEFT JOIN global_song_rank ON
    songs.song_id = global_song_rank.song_id
  -- appears in Top 10
  WHERE global_song_rank.rank <= 10
  GROUP BY artists.artist_name
)

SELECT
  artist_name,
  artist_rank
FROM Top10Counts
WHERE artist_rank <= 5
ORDER BY artist_rank ASC, artist_name ASC
;