--[[
    Game Board Class
]]

GameBoard = Class{}

function GameBoard:init()
    self.deck = Deck()
    self.tableaus = {}
    self.winPools = {}
    self.freePools = {}
    self.cardPickedUp = nil
    self.pickedUpTableau = 0 
    self.numEmptyFreePools = 4
    self.numEmptyTableaus = 0
    self.isWin = false
    self.mastercard = MasterCard()

    self:generateTableaus()
end

--function that checks and sets if cards are ordered, starting from bottom of each tableau 
-- to identify which cards are allowed to move
function GameBoard:checkOrder(tableau)
             
             local tempCard = tableau[#tableau]
             while tempCard do
               tempCard.isOrdered = true
               if tempCard.parent and tempCard:compareCards(tempCard.parent,'ascending', 'opposite') then
                   tempCard = tempCard.parent
               else
                   tempCard = nil
               end
             end
end  

function GameBoard:generateTableaus()
    
    -- populate all tableaus with starting cards
    for i = 1, NUM_TABLEAUS do
        table.insert(self.tableaus, {})

        local yPos = 160
        local xPos = 10 + 80 * (i - 1)
        local padding = 0
        local cards_per_tableau = 7
	
	if i >= 5 then
		cards_per_tableau = 6
	end

        for j = 1, cards_per_tableau do
            
            local newCard = self.deck:draw()
            newCard.x = xPos
            newCard.y = yPos

	    --initiate parent for every card & simltaneously set the parent's child card
	    if j > 1 then
		newCard.parent = self.tableaus[i][j-1]
	    	newCard.parent.child = newCard
	    end
	    	
            table.insert(self.tableaus[i], newCard)
            yPos = yPos + CARD_PADDING
        end
        self:checkOrder(self.tableaus[i])
    end
    
    --populate the freePool with empty lists
    for i = 1, NUM_FREEPOOLS do
        table.insert(self.freePools,{})
    end
    
    --populate the winPool with empty lists
    for i = 1, 4 do
        table.insert(self.winPools,{})
    end
    
 end

function GameBoard:update(dt)

    -- iterate through all tableau cards, allowing mouse input if card is bottom-most 
    for i = 1, NUM_TABLEAUS do

        for j = #self.tableaus[i], 1, -1 do
            local temp = self.tableaus[i][j]
            if temp~= nil and temp.isOrdered then
                self.tableaus[i][j]:update(dt, self, self.tableaus[i], TABLEAU_PILE)
            end 
        end
    end 

    -- iterate through all pool cards, allowing mouse input
    
    for i = 1, NUM_FREEPOOLS do
        if (#self.freePools[i] > 0) then 
               self.freePools[i][1]:update(dt, self, self.freePools[i], FREEPOOL_PILE)
        end
    end 
end

function GameBoard:render()
   
   self:drawBackground()
   self.mastercard:render()
   self:renderTableaus()
   self:renderPickedUpCards()
   self:renderPools()
   if self.isWin then
         --print the congratulations message--
         love.graphics.clear(0, 0.3, 0, 1)
         love.graphics.setNewFont(50)
         love.graphics.setColor(1, 1, 1, 1)
         love.graphics.printf ("Congratulations! You have won!", 0 ,  WINDOW_HEIGHT/4, WINDOW_WIDTH, "center")
   end

end

function GameBoard:renderPickedUpCards()
    local tempCard = self.cardPickedUp
    while tempCard ~= nil do
        tempCard:render()
        tempCard = tempCard.child
    end
end

function GameBoard:renderTableaus()
    
    -- iterate over and draw cards in tableaus
    for i = 1, NUM_TABLEAUS do
        for j = 1,#self.tableaus[i] do
            self.tableaus[i][j]:render()
        end
    end
end

function GameBoard:renderPools()
   
    for i = 1, NUM_FREEPOOLS do
        for j = 1, #self.freePools[i] do
            self.freePools[i][j]:render()
        end
    end
    
    for i = 1, 4 do
        for j = 1, #self.winPools[i] do
            self.winPools[i][j]:render()
        end
    end
end

function GameBoard:countEmptyPiles()
    local count = 0
    
    for i = 1, NUM_FREEPOOLS do
        if #self.freePools[i] == 0 then
           count = count + 1
        end
    end
    
    self.numEmptyFreePools = count
    count = 0
    
    for i = 1, NUM_TABLEAUS do
        if #self.tableaus[i] == 0 then
        
           count = count + 1
        end
    end
    
    self.numEmptyTableaus = count
end

function GameBoard:checkForWin()
   
   for i = 1, 4 do
        if #self.winPools[i] < CARDS_IN_SUIT then
                return
        end
   end
   self.isWin = true
end

---draws the outlines for Free Pile, Win Pile and tableaus
function GameBoard:drawBackground()
    love.graphics.clear(0, 0.3, 0, 1)

    -- free Pool 
    love.graphics.rectangle('line', 10, 50, CARD_WIDTH, CARD_HEIGHT, 3)
    love.graphics.rectangle('line', 90, 50, CARD_WIDTH, CARD_HEIGHT, 3)
    love.graphics.rectangle('line', 170, 50, CARD_WIDTH, CARD_HEIGHT, 3)
    love.graphics.rectangle('line', 250, 50, CARD_WIDTH, CARD_HEIGHT, 3)

    -- winPool
    love.graphics.rectangle('line', 410, 50, CARD_WIDTH, CARD_HEIGHT, 3)
    love.graphics.rectangle('line', 490, 50, CARD_WIDTH, CARD_HEIGHT, 3)
    love.graphics.rectangle('line', 570, 50, CARD_WIDTH, CARD_HEIGHT, 3)
    love.graphics.rectangle('line', 650, 50, CARD_WIDTH, CARD_HEIGHT, 3)
        
    -- tableau grid markers
    love.graphics.rectangle('line', 10, 160, CARD_WIDTH, CARD_HEIGHT, 3)
    love.graphics.rectangle('line', 90, 160, CARD_WIDTH, CARD_HEIGHT, 3)
    love.graphics.rectangle('line', 170, 160, CARD_WIDTH, CARD_HEIGHT, 3)
    love.graphics.rectangle('line', 250, 160, CARD_WIDTH, CARD_HEIGHT, 3)
    love.graphics.rectangle('line', 330, 160, CARD_WIDTH, CARD_HEIGHT, 3)
    love.graphics.rectangle('line', 410, 160, CARD_WIDTH, CARD_HEIGHT, 3)
    love.graphics.rectangle('line', 490, 160, CARD_WIDTH, CARD_HEIGHT, 3)
    love.graphics.rectangle('line', 570, 160, CARD_WIDTH, CARD_HEIGHT, 3)
    
end
