-- Number Of Bathrooms And Bedrooms

-- Find the average number of bathrooms and bedrooms for each city’s property types.
-- Output the result along with the city name and the property type.

/* Fields in airbnb_search_details:
    id:                     int
    price:                  float
    property_type:          varchar
    room_type:              varchar
    amenities:              varchar
    accommodates:           int
    bathrooms:              int
    bed_type:               varchar
    cancellation_policy:    varchar
    cleaning_fee:boolcity:  varchar
    host_identity_verified: varchar
    host_response_rate:     varchar
    host_since:             datetime
    neighbourhood:          varchar
    number_of_reviews:      int
    review_scores_rating:   float
    zipcode:                int
    bedrooms:               int
    beds:                   int
*/

-- -- Inspect
-- SELECT *
-- FROM airbnb_search_details
-- FETCH FIRST 3 ROWS ONLY


SELECT
    city,
    property_type,
    AVG(bathrooms) AS avg_bathrooms,
    AVG(bedrooms) AS avg_bedrooms
FROM airbnb_search_details
GROUP BY
    city,
    property_type