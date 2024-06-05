
-- dire che questa è una classe
Ball = Class {}

-- Classe:init è un inizializzatore della classe 

function Ball:init(x, y, width, height)
    -- i parametri che ci servono per creare una palla
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    -- questi invece i parametri che servono per il movimento
    self.dy = math.random(2) == 1 and 100 or -100
    self.dx =  math.random(-50, 100)
end

-- creo la funzione di collisione della palla con i paddles da utilizzare nel main
function Ball:collide(paddle)
    -- se il valore x della palla è maggiore del valore x del paddle più la sua larghezza allora non collidono
    -- lo stesso vale al contrario
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
        return false
    end
    
    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then 
        return false
    end

    -- se nessuna delle condizioni sopra è vera allora si stanno toccando quindi diamo un return true
    return true
end


-- funzione di reset della palla, da chiamare quando si cambia gamestate
function Ball:reset()
    -- resetto la posizione della palla
    self.y = VIRTUAL_HEIGHT / 2 - 2
    self.x = VIRTUAL_WIDTH / 2 - 2

    -- creo dei delta della palla in modo da darle una velocità casuale
    self.dy = math.random(2) == 1 and 100 or -100
    self.dx = math.random(-50, 50)
end

-- funzione di update che applica la velocità alla posizione così da far muovere la palla
function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

-- funzione per stampare la pallina
function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
