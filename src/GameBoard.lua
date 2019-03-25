--[[
    Game Board Class
]]

GameBoard = Class{}

function GameBoard:init()
    self.deck = Deck()
    self.tableaus = {}
    self.tablePool = {}
    self.freePool = {}
    self.cardPickedUp = nil
    self.pickedUpTableau = 0 

    self:generateTableaus()
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

	    --Initiate parent for every card & simltaneously set the parent's child card
	    if j > 1 then
		newCard.parent = self.tableaus[i][j-1]
	    	newCard.parent.child = newCard
	    end
	    	
            table.insert(self.tableaus[i], newCard)
            
            local padding = 25
            yPos = yPos + padding
        end
    end
end

function GameBoard:update(dt)

    -- update all cards in hand first
    --[[for i = 1, #self.pickedUpCards do
        self.pickedUpCards[i]:update(dt, self)
    end]]--

    -- iterate through all visible cards, allowing mouse input 
    for i = 1, NUM_TABLEAUS do

        for j = #self.tableaus[i], 1, -1 do
            local temp = self.tableaus[i][j]
            if temp~= nil then
                self.tableaus[i][j]:update(dt, self, self.tableaus[i])
            end 
       
        end
	
    end 
end

function GameBoard:render()
    self:drawBackground()

    -- render tableaus
    self:renderTableaus()

   self:renderPickedUpCards()
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


---draws the outlines for Free Pile, Win Pile and tableaus
function GameBoard:drawBackground()
    love.graphics.clear(0, 0.3, 0, 1)

    -- main stack placeholders
    love.graphics.rectangle('line', 10, 50, CARD_WIDTH, CARD_HEIGHT, 3)
    love.graphics.rectangle('line', 90, 50, CARD_WIDTH, CARD_HEIGHT, 3)
    love.graphics.rectangle('line', 170, 50, CARD_WIDTH, CARD_HEIGHT, 3)
    love.graphics.rectangle('line', 250, 50, CARD_WIDTH, CARD_HEIGHT, 3)

    -- active stock card
    love.graphics.rectangle('line', 410, 50, CARD_WIDTH, CARD_HEIGHT, 3)

    -- stock itself
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
