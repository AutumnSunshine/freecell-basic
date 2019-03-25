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

--[[
    Pick up the card, flagging it as such, then remove it from the tableau
    in which it is. Make a copy of this card and add it to the game board's
    staging hand.
]]
function Card:pickUp(tableau, gameBoard)
    self.pickedUp = true
     
    if tableau == nil then
        return
    end

    table.insert(gameBoard.pickedUpCards, table.remove(tableau, #tableau))

    if self.child then
        self.child:pickUp(tableau, gameBoard)
    end
end

function Card:placeDown(gameBoard)

    -- card by itself
    if self.child == nil and self.parent == nil then
        
        -- check to see if placing in tableau OR winning pile
    
    -- otherwise, only worry about placing a top-level card
    -- place ONLY in tableaus, not winning piles
    elseif self.child ~= nil and self.parent == nil then
        
    end
end

function Card:update(dt, gameBoard, tableau)
   
    -- update card based on its parent
    if self.pickedUp then
     if self.parent == nil or self.parent.pickedUp == false then
	    self.x, self.y = love.mouse.getPosition()
            self.x = self.x - CARD_WIDTH / 2
            self.y = self.y - CARD_HEIGHT / 2
     else
           self.x = self.parent.x
           self.y = self.parent.y + 25
     end  
    end

    if love.mouse.wasButtonPressed(1)  then
        local x, y = love.mouse.getPosition()

        -- confine Y bounds checking based on parenting; smaller hit box
        -- for when cards are behind other cards
        local yBounds = CARD_HEIGHT
        if self.child ~= nil then
            yBounds = 25
        end

        if x >= self.x and x <= self.x + CARD_WIDTH and
           y >= self.y and y <= self.y + yBounds then

            -- ensure we're not already picking up a card
            if not gameBoard.cardPickedUp then
                
                --[[Ensure this is the topmost card being picked up
                    set the cardPickedUp of gameboard to the topmost card
                    & pick up all the cards below topmost card ]]
                    
                if self.parent == nil or self.parent.pickedUp == false then
                    gameBoard.cardPickedUp = self
                    
                    for key, tab in pairs(gameBoard.tableaus) do
		        if tab == tableau then
		                gameBoard.pickedUpTableau = key
		        end
		    end
                    
                    local tempCard = self
		    while (tempCard~=nil) do
    		       tempCard.pickedUp = true
		       tempCard = tempCard.child
		    end
                    --self:pickUp(tableau, gameBoard)
		end
		
	    ---i.e. some card is already picked up and its time to put them down
            elseif self.pickedUp  then	
                         --[[ Place down all the picked up cards
                             set the cardPickedUp of gameboard to NIL
                           ]]
		        self:transferTableaus(gameBoard, tableau, x,y)
		        local tempCard = gameBoard.cardPickedUp
		        while (tempCard~=nil) do
    		                tempCard.x = tempCard.parent.x
    		                tempCard.y = tempCard.parent.y + 25
    		                tempCard.pickedUp = false
		                tempCard = tempCard.child
		        end
		       gameBoard.cardPickedUp = nil
		       gameBoard.pickedUpTableau = 0
            end
        end
    elseif love.mouse.wasButtonPressed(2)  then
        local x, y = love.mouse.getPosition()
	print("Calling else if")
    end
end

function Card:render(x, y)
        love.graphics.draw(gTextures['cards'], gCardQuads[self.suit][self.face], 
            self.x, self.y)
end

function Card:transferTableaus(gameBoard, tableau, x,y)
        ---find position of top Card in its old tableau
        local topCardPosition = 0
        for position,card in pairs(tableau) do
                if card == gameBoard.cardPickedUp then
                        topCardPosition = position
                        break
                end 
        end
       
        for i = 1, NUM_TABLEAUS do
              ---ensure it is not the same as original Tableau
              if i ~= gameBoard.pickedUpTableau and #gameBoard.tableaus[i] > 0 then
                      local bottomCard = gameBoard.tableaus[i][#gameBoard.tableaus[i]]
                      local tableau_x = bottomCard.x
                      local tableau_y = bottomCard.y
                      if x >= tableau_x and x <= tableau_x + CARD_WIDTH and
                         y >= tableau_y and y <= tableau_y + CARD_HEIGHT
                      then 
                              print("Calling Placedown..."..bottomCard.face.."--"..bottomCard.suit)
                              gameBoard.cardPickedUp:placeDown(gameBoard, gameBoard.tableaus[i], bottomCard)
                              
                              -- remove the picked up cards from old tableau and insert into new tableau 
                              while topCardPosition <= #tableau  do
                                  table.insert(gameBoard.tableaus[i], table.remove(tableau, topCardPosition)) 
                                  print("Position is:"..gameBoard.tableaus[i][#gameBoard.tableaus[i]].face)
	                      end   
	                      
	                      if gameBoard.cardPickedUp.parent then 
	                        gameBoard.cardPickedUp.parent.child = nil
	                      end
	                      gameBoard.cardPickedUp.parent = bottomCard
                              bottomCard.child = gameBoard.cardPickedUp
                                                   
                      return
                      end
              end
        end
end 

--- compare self with secondCard as per order & suit mentioned as parameters --
function Card:compareCards(secondCard, order, suit)
         
         print("Comparing..."..self.face.." "..self.suit.."and"..secondCard.face.." "..secondCard.suit)
         
         local resultFace = false
         local resultSuit = false
        
         if order == 'ascending' then
                resultFace = ( secondCard.face == (self.face + 1))
         elseif order == 'descending' then
                resultFace = ( secondCard.face == (self.face - 1))
         end
         
         if self.suit ~= 'opposite' then
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
         
         if suit == 'opposite' then
                resultSuit= (self.suit == secondCard.suit) and resultSuit
         end
         
         return (resultFace and resultSuit)
end                
         
         
         


