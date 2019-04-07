--[[
    Card Class
]]

Card = Class{}

function Card:init(face, suit, x, y)
    ---Properties that will remain fixed over the lifetime of a card
    self.face = face
    self.suit = suit
    
    ---Properties that will be modified over the lifetime of a card
    self.pickedUp = false
    self.isOrdered = false

    self.x = x
    self.y = y

    self.parent = nil
    self.child = nil
end

function Card:render(x, y)
        love.graphics.draw(gTextures['cards'], gCardQuads[self.suit][self.face], 
            self.x, self.y)
end

--[[
    Pick up the card, flagging it as such, then remove it from the tableau
    in which it is. 
]]

function Card:update(dt, gameBoard, tableau, pile)
   
    -- update card based on its parent
    if self.pickedUp then
        if self.parent == nil or self.parent.pickedUp == false then
	    self.x, self.y = love.mouse.getPosition()
            self.x = self.x - CARD_WIDTH / 2
            self.y = self.y - CARD_HEIGHT / 2
        else
           self.x = self.parent.x
           self.y = self.parent.y + CARD_PADDING
        end  
    end -- okay

    if love.mouse.wasButtonPressed(1)  then
        local x, y = love.mouse.getPosition()

        -- confine Y bounds checking based on parenting; smaller hit box
        -- for when cards are behind other cards
        local yBounds = CARD_HEIGHT
        if self.child ~= nil then
            yBounds = CARD_PADDING
        end -- okay

        if x >= self.x and x <= self.x + CARD_WIDTH and
           y >= self.y and y <= self.y + yBounds then

            -- ensure we're not already picking up a card
            if not gameBoard.cardPickedUp then
                
                --[[Ensure this is the topmost card being picked up,
                    set the cardPickedUp of gameboard to the topmost card
                    & pick up all the cards below topmost card ]]
                    
                if self.parent == nil or self.parent.pickedUp == false then
                    gameBoard.cardPickedUp = self
                    
                    --if picked up card in a tableau--
                    if pile == TABLEAU_PILE then
                        for key, tab in pairs(gameBoard.tableaus) do
		            if tab == tableau then
		                gameBoard.pickedUpTableau = key
		            end
		        end 
		    else
		    -- check if picked up card is not in freePool --
		        for key, tab in pairs(gameBoard.freePools) do
		            if tab == tableau then
		               gameBoard.pickedUpTableau = key
		            end
		        end
                    end
                    
                    local tempCard = self
		    while (tempCard~=nil) do
    		       tempCard.pickedUp = true
		       tempCard = tempCard.child
		    end
		    gameBoard:countEmptyPiles()
		end 
		
	    ---i.e. some card is already picked up and its time to put them down
            elseif self.pickedUp  then	
                         --[[ Place down all the picked up cards
                             set the cardPickedUp of gameboard to NIL
                           ]]
		        self:transferTableaus(gameBoard, tableau, x, y, pile)
		        gameBoard.cardPickedUp = nil
		        gameBoard.pickedUpTableau = 0
		        gameBoard:checkOrder(tableau)
		        gameBoard:countEmptyPiles()
		        love.mouse.setPosition(self.x - 5, self.y)
		        
            end  
       end
       
    elseif love.mouse.wasButtonPressed(2)  then
        local x, y = love.mouse.getPosition()
        -- check if this card is a single card can be placed in the WinPool
        if self.child == nil then
            if x >= self.x and x <= self.x + CARD_WIDTH and
               y >= self.y and y <= self.y + CARD_HEIGHT then
               local index = self:checkWinPile(gameBoard)  
               if index > 0 then
                    self:moveCards(tableau, #tableau, gameBoard.winPools[index],
                                   gameBoard.winPools[index][#gameBoard.winPools[index]], 410 + 80 * (index - 1), 50 )
                    gameBoard:checkOrder(tableau)
                    gameBoard:checkForWin()
                    love.mouse.setPosition(x - 5 ,y)
                    
               end
            end
        end
   end   
end

--[[ checks if the current card can be placed in any winning pile and 
      returns the index of the winPool if so; else returns 0 ]]
    
function Card:checkWinPile(gameBoard)

        -- find out number of winPools already populated--        
        local count = 0
        local index = 0
        for i = 1, 4 do
                if #gameBoard.winPools[i] > 0 then
                   count = count + 1
                end
        end
        
       
        --[[ if this card is an ace start a new WinPool, else check if this card can be placed on top of any existing WinPool ]]--
        
        if self.face == ACE then
                return (count + 1)
        else
            for i = 1, count do
                local temp = #gameBoard.winPools[i]
                if (self:compareCards(gameBoard.winPools[i][temp], 'descending', 'same')) then
                   index = i
                   return index
                end
            end
        end
        return index
end

function Card:transferTableaus(gameBoard, tableau, x,y, pile)
        ---find position of top Card in its old tableau/pool
        local topCardPosition = 0
        for position,card in pairs(tableau) do
                if card == gameBoard.cardPickedUp then
                        topCardPosition = position
                        break
                end 
        end
        
        
        --check if its a single card & if its destination is an available free Pool--
        if not gameBoard.cardPickedUp.child then
                if gameBoard.numEmptyFreePools > 0 then
                        for i = 1, NUM_FREEPOOLS do
                                local posX = FREEPOOL_X_POS + 80 * (i - 1)
                                local posY = POOL_Y_POS
                                if #gameBoard.freePools[i] == 0 and
                                   x >= posX and x <= posX + CARD_WIDTH and
                                   y >= posY and y <= posY + CARD_HEIGHT then
                                   gameBoard.mastercard:setQuote(0)
                                   gameBoard.cardPickedUp:moveCards(tableau, topCardPosition, gameBoard.freePools[i],
                                      nil, posX, posY )
                                return
                                end
                        end
                end
         end 
                                        
        --check if the card is placed on another tableau (not same as original tableau)
        for i = 1, NUM_TABLEAUS do
              if pile == FREEPOOL_PILE or i ~= gameBoard.pickedUpTableau then
                      local allowedNumCards = (2 ^ (gameBoard.numEmptyTableaus)) * (gameBoard.numEmptyFreePools + 1)
                      local bottomCard = nil 
                      local tableau_x = 10 + 80 * (i - 1)
                      local tableau_y = 160
                      
                      if #gameBoard.tableaus[i] > 0 then 
                               bottomCard=gameBoard.tableaus[i][#gameBoard.tableaus[i]]
                               tableau_x = bottomCard.x
                               tableau_y = bottomCard.y
                      else
                          allowedNumCards = allowedNumCards / 2
                      end
                      --if the bottom card for this tableau is of opposite suit & 1 value above the top Picked up card 
                      --remove the picked up cards from old tableau and insert into new tableau 
                      
                        if x >= tableau_x and x <= tableau_x + CARD_WIDTH and
                           y >= tableau_y and y <= tableau_y + CARD_HEIGHT 
                       --    and (#tableau - topCardPosition + 1) <= allowedNumCards 
                       
                       --[[retain/remove the comment from above line for ignoring/enforcing freecell rules 
                           for number of cards that can be moved]]  
                        
                        then 
                              --move the cards from old tableau to new tableau
                              gameBoard.mastercard:setQuote(1)
                              if bottomCard == nil then --i.e. empty tableau
                                gameBoard.cardPickedUp:moveCards(tableau, topCardPosition, gameBoard.tableaus[i],
                                      bottomCard, tableau_x, tableau_y )
                                return
                              elseif gameBoard.cardPickedUp:compareCards(bottomCard,'ascending','opposite') then
                                gameBoard.cardPickedUp:moveCards(tableau, topCardPosition, gameBoard.tableaus[i],
                                      bottomCard, tableau_x, tableau_y + CARD_PADDING)
                                return
                              end
                        end
              end
        end
        
        --not a valid transfer move & restore picked Up cards to their old position--
        --if old position is from a tableau --
        if pile == TABLEAU_PILE then
           local tableau_y = 160
           gameBoard.mastercard:setQuote(0)
           if gameBoard.cardPickedUp.parent then
                tableau_y = gameBoard.cardPickedUp.parent.y + CARD_PADDING
           end
           gameBoard.cardPickedUp:moveCards(tableau, #tableau + 1, tableau,
                                     gameBoard.cardPickedUp.parent , 10 + 80 * (gameBoard.pickedUpTableau - 1), tableau_y)
                                     
        else -- old position was from free Pool
          gameBoard.cardPickedUp:moveCards(tableau, #tableau + 1, tableau,
                                     gameBoard.cardPickedUp.parent , 10 + 80 * (gameBoard.pickedUpTableau - 1) , 50)
        end
end 



-- move cards starting from self till last child from old tableau to new Tableau
function Card:moveCards(oldTableau, posInTableau, newTableau, newParent, newPosX, newPosY)
         
         --shift the cards to new tableau
         while posInTableau <= #oldTableau  do
                 table.insert(newTableau, table.remove(oldTableau, posInTableau)) 
         end   
         
         --reassign parent & child for self, old & new Parent cards
         if self.parent then
                self.parent.child = nil
         end
         
         if newParent then
                newParent.child = self
         end
         
         --Change x & y position of moved cards
         self.parent = newParent
         self.pickedUp = false
         self.x = newPosX
         self.y = newPosY
          
         local tempCard = self.child
         while (tempCard~=nil) do
                tempCard.pickedUp = false
                tempCard.x = tempCard.parent.x
    		tempCard.y = tempCard.parent.y + CARD_PADDING
		tempCard = tempCard.child
         end                     
end

--- compare self with secondCard as per order & suit mentioned as parameters --
function Card:compareCards(secondCard, order, suitOrder)
         
         local resultFace = false
         local resultSuit = false
         
         if order == 'ascending' then
                resultFace = ( secondCard.face == (self.face + 1))
         elseif order == 'descending' then
                resultFace = ( secondCard.face == (self.face - 1))
         end
         
         if suitOrder ~= 'opposite' then
                resultSuit = (self.suit == secondCard.suit)
         elseif self.suit == HEARTS then
                resultSuit = (secondCard.suit ~= DIAMONDS)
         elseif self.suit == DIAMONDS then
                resultSuit = (secondCard.suit ~= HEARTS)
         elseif self.suit == SPADES then
                resultSuit = (secondCard.suit ~= CLUBS)
         else 
                resultSuit = (secondCard.suit ~= SPADES)
         end
         
         if suitOrder == 'opposite' then
                resultSuit=( (self.suit ~= secondCard.suit) and resultSuit)
         end
        
         return (resultFace and resultSuit)
end                
 
