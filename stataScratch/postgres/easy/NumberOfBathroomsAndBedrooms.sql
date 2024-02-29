/*
Find the average number of bathrooms and bedrooms for each city’s property types. 

Output the result along with the city name and the property type.

airbnb_search_details:
Unnamed: 0:             int
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


SELECT
    city,
    property_type,
    AVG(bathrooms) AS n_bathrooms_avg,
    AVG(bedrooms) AS n_bedrooms_avg
FROM airbnb_search_details
GROUP BY city, property_type
;