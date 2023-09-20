/*
You are given a table, BST, containing two columns: N and P, where N represents the value of a node in Binary Tree, and P is the parent of N.

Write a query to find the node type of Binary Tree ordered by the value of the node. Output one of the following for each node:
- Root: If node is root node.
- Leaf: If node is leaf node.
- Inner: If node is neither root nor leaf node.
*/

SELECT
    N,
    CASE
        -- If node has no parent, then can only be the root
        WHEN P IS NULL
            THEN 'Root'
        -- If the node is a parent of some other node/has children,
        --  since we already found the root, it must be an inner node
        WHEN N IN (SELECT P FROM BST)
            THEN 'Inner'
        -- Otherwise, the only node type left is leaf (no children)
        ELSE 'Leaf'
    END
FROM BST
ORDER BY N ASC
;