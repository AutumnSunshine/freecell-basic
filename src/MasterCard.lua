--[[
    Master Card Class
]]

MasterCard = Class{}

function MasterCard:init()
self.quote = "LEFT-CLICK & DRAG: To move cards between tableaus/free cells.  \n\nRIGHT-CLICK: To move cards to winning piles. \n\nESC: Quit & close. \nNo Undo/Hint"
self.ahead = {
"Even with nougat, you can have a perfect moment.",
"Can we fix it? - Yes, we can!",
"I'm not throwin' away my... shot!",
"'Forty-two,' said Deep Thought with infinite majesty and calm",
"Life is more fun if you play games",
"Two rights don't equal a left",
"The only appropriate state of mind is surprise.",
"I never look back darling, it distracts from the now",
"Just keep swimming! Just keep swimming!",
"It's still magic even if you know how it's done.",
"It's amazing what you see if you keep your eyes open",
"Big things often have small beginnings",
"This may come as something of a surprise but I'm a sore loser",
"Zone of absolute fortune :D",
"Hakuna Matata! Means no worries for the rest of your days",
"My intellect is everything...Defeat is absurd!",
"Omelette du fromage!",
"It's not the beard on the outside that counts - its the beard on the inside!",
"I am not defeated, I will hold my ground!",
"I have all the right moves."
}

self.behind = {
"But what you throw away, you'll never get back!",
"Bugrit! Millenium hand and shrimp!",
"Welcome to day 255,642 aboard the Axiom!",
"I do not like the Cone of Shame!",
"It won't be easy...it will be worth it!",
"You must let go of the illusion of control",
"One thing you can always count on is that hearts change!",
"Played with your heart, got lost in the game..",
"Damn Daniel!",
"It's gonna be a bumpy ride!",
"There's a benefit to losing...You get to learn from your mistakes!",
"Ferret or no ferret, Yoshie-chan is a girl's name :P",
"There's no secret ingredient. It's just you!",
"You've fallen right into my trap!",
"You got a problem buddy? Huh? Huh?",
"I don't know, don't know...So don't ask me why",
"From her point of view, losing was something that happened to other people.",
"There's always a way to turn things around, to find the fun",
"How you gonna fix this? - Grit, spit and a whole lotta duct tape.",
"Ruh-roh! Zoinks!!!"
}
end

function MasterCard:setQuote(moveType)
   --If type is 1, quote is set for a successful move, else for an invalid move

    if moveType == 1 then
        local pos = math.random(#self.ahead)
        self.quote = self.ahead[pos]
    else
        local pos = math.random(#self.behind)
        self.quote = self.behind[pos]
    end
end
        
function MasterCard:update(dt)

end
function MasterCard:render()         
         love.graphics.setColor(58/255, 36/255, 59/255, 1)
         love.graphics.rectangle('fill', 800, 280, CARD_WIDTH * 3, CARD_HEIGHT * 3, 3)
         love.graphics.setColor(1, 1, 1, 1)
         love.graphics.setNewFont(21)
         love.graphics.printf (self.quote,805, 285, CARD_WIDTH * 2.9, "left")
         love.graphics.setColor(1, 1, 1, 1)         
end

