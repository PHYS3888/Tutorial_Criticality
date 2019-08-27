You will find a Matlab script `forestFireModel.m`, we will need to implement the five rules inside this script to make the forest-fire model.

1. Find where it says Rule 1 in the script, here we need to implement the initial conditions: 1) Initially each site is randomly assigned to be a tree, a burning tree or empty.
Hint: Define empty ground as 0, a tree as 1, and a burning tree as 2, using 3*rand we can map uniform distribution to 3 states and floor this for a uniform sampling of 0, 1 and 2
2. Find Rule 2 in the script, we want to implement: 2) A burning tree becomes an empty site in the next time-step.
We can do this indirectly by starting our state as all empty and mapping across the fires and trees from the previous time-step.
3. Find Rule 3 in the script, we want to implement: 3) an empty site grows a tree with probability `p`.
_Hint_: we want to randomly grow trees with probability `p` only on the empty ground (=0).
4. Find Rule 4 in the script, we want to implement: 4) a tree becomes a burning tree in the next time-step if at least one of its neighbours is burning.
Here we first find all the fires from the previous time-step using this you should check if their neighbours are a tree (=1) and if so set this tree on fire (=2).
5. Finally, find Rule 5 in the script, we want to implement: 5) a tree becomes a burning tree during a time step with probability `f` if no neighbour is burning.
Similar to above we want to randomly alight trees (=1) with probability `f`.
