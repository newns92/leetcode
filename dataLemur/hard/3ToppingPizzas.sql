/*
You’re a consultant for a major pizza chain that will be running a promotion where all 3-topping pizzas will be sold for a fixed price, 
and are trying to understand the costs involved.

Given a list of pizza toppings, consider all the possible 3-topping pizzas, and print out the total cost of those 3 toppings. 
Sort the results with the highest total cost on the top followed by pizza toppings in ascending order.

Break ties by listing the ingredients in alphabetical order, starting from the first ingredient, followed by the second and third.

P.S. Be careful with the spacing (or lack of) between each ingredient. Refer to our Example Output.

Notes:
- Do not display pizzas where a topping is repeated. For example, ‘Pepperoni,Pepperoni,Onion Pizza’.
- Ingredients must be listed in alphabetical order. For example, 'Chicken,Onions,Sausage'. 'Onion,Sausage,Chicken' is not acceptable.

pizza_toppings:
Column Name	        Type
topping_name	    varchar(255)
ingredient_cost	    decimal(10,2)
*/

-- ATTEMPT 1: INNER JOIN
-- https://stackoverflow.com/questions/31070337/return-all-possible-combinations-of-values-within-a-single-column-in-sql
SELECT 
  CONCAT_WS(',', 
    pizza_toppings1.topping_name,
    pizza_toppings2.topping_name,
    pizza_toppings3.topping_name
  ) AS pizza,
  SUM(pizza_toppings1.ingredient_cost
    + pizza_toppings2.ingredient_cost
    + pizza_toppings3.ingredient_cost
  ) AS total_cost
FROM pizza_toppings pizza_toppings1
JOIN pizza_toppings pizza_toppings2 ON
  -- use < to ensure no duplication of the ingredients across each row
  --  ingredients are arranged in an alphabetical manner from left to right.
  pizza_toppings1.topping_name < pizza_toppings2.topping_name
JOIN pizza_toppings pizza_toppings3 ON 
  pizza_toppings1.topping_name < pizza_toppings3.topping_name AND
  pizza_toppings2.topping_name < pizza_toppings3.topping_name
GROUP BY
  pizza_toppings1.topping_name, pizza_toppings2.topping_name, pizza_toppings3.topping_name
ORDER BY 
  SUM(pizza_toppings1.ingredient_cost
    + pizza_toppings2.ingredient_cost
    + pizza_toppings3.ingredient_cost
  ) DESC,
  pizza_toppings1.topping_name, pizza_toppings2.topping_name, pizza_toppings3.topping_name
;