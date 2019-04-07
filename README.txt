---Basic Instructions for Freecell Game ---

There are 8 tableaus of the 52 playing cards, placed in a random order in each tableau

Objective : 
To stack all the cards suit-wise in the 4 winning piles [top right of the game board] starting from ACE till KING

Rules     :
To achieve this, the player can move around the cards in the tableaus [8 piles of open-faced cards] with the following rules--
            
1. Any card can be moved onto a card of the opposite suit and with face value 1 above the card only
2. Single cards from tableau can be moved into any empty Free Pools [4 piles on top left of the game board] 
3. Only single cards at the bottom of tableau/ ordered cards [i.e. alterating suits and face values in ascending order from bottom] an be moved
4. Single cards can be moved from tableau or free pool to the winning piles, if it is an ace or is the succeeding card of any card currently in the winning pile
5. Cards once placed in winning pile cannot be moved back to tableaus/free pool
6. There is a limit to number of cards from tableau that can be shifted at one time (given by 2^[Num of Empty Tableaus] * [Num of Empty pools + 1]). This is not enforced in this version (commented out)

Moves     :

Left click to drag and drop cards from/to tableaus and free pool 
Right click to place a card onto winning pile if possible
Esc to quit the game at any stage

When all the cards from tableaus have been placed in winning piles, the game ends with a success. 

Following features are NOT available in this version:

1. Undo of previous move(s)
2. Hint for next move
3. Game itself prompting a Loss if there are no possible legal moves


GOOD LUCK
------------------------------------------------------------------------------





 
