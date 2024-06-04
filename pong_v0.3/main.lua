
-- Prendiamo la libreria push, serve a dare un tocco retrò al gioco dandoci delle dimensioni virtuali della finestra, la finestra avrà comunque altezza e larghezza scelte ma renderizzerà il gioco alle dimensioni virtuali.
-- Link della libreria: https://github.com/Ulydev/push
push = require 'push'

-- Variabili di sistema utilizzate dalla funzione love.window.setmode per definire la grandezza della finestra
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- Variabili della renderizzazione virtuale
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- Creiamo un valore di velocità dei rettangoli
PADDLE_SPEED = 200

-- funzione love.load() viene chiamata solo quando il gioco parte, serve per inizializzare il gioco.

function love.load()

    -- il filtro nearest ci permette di rimuovere l'effetto offuscato dal testo, rimuovere per provare
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- creiamo una variabile font prendendolo dal file nella directory, il numero indica la grandezza del font
    smallFont = love.graphics.newFont('font.ttf', 8)

    -- creiamo un font più grande che servirà per il risultato
    scoreFont = love.graphics.newFont('font.ttf', 30)

    -- Per settare la larghezza della finestra non usiamo più la funzione window.setmode ma utilizziamo la libreria push
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    -- inizializzo due variabili per il punteggio dei due giocatori
    player1Score = 0
    player2Score = 0

    -- posizioni dei rettangoli, ci concentriamo sulla Y perché ci si può muovere solo in alto e in basso
    player1Y = 30
    player2Y = VIRTUAL_HEIGHT - 50

end

-- funzione love.pressedkey() serve a intercettare gli input degli utenti
function love.keypressed(key)
    
    if key == 'escape' then
        -- utilizzo la funzione di love che chiude l'applicazione
        love.event.quit()
    end
end


function love.update(dt)
    -- movimenti player 1
    if love.keyboard.isDown('w') then
        -- aggiungiamo movimento negativo alla Y (quindi verso l'alto) moltiplicato per il delta time(per aver un movimento costante nel tempo)
        player1Y = player1Y + -PADDLE_SPEED * dt
    elseif love.keyboard.isDown('s') then
        -- aggiungiamo movimento positivo x delta time
        player1Y = player1Y + PADDLE_SPEED * dt
    end

    --movimenti player 2 
    if love.keyboard.isDown('up') then
        -- aggiungiamo movimento negativo alla Y (quindi verso l'alto) moltiplicato per il delta time(per aver un movimento costante nel tempo)
        player2Y = player2Y + -PADDLE_SPEED * dt
    elseif love.keyboard.isDown('down') then
        -- aggiungiamo movimento positivo x delta time
        player2Y = player2Y + PADDLE_SPEED * dt
    end
end

-- funzione love.draw() viene chiamata dopo l'update di LOVE2D e serve per disegnare qualcosa sullo schermo.

function love.draw()

    --aggiungiamo la libreria push per renderizzare utilizzando il filtro e la risoluzione virtuale
    -- tutto quello che c'è tra push:apply('start') e push:apply('end') verrà renderizzato e filtrato secondo la libreria
    push:apply('start')

    -- sposto più in alto la scritta ciao pong rispetto allo scorso commit ricordando che adesso le misure rispecchieranno quelle virtuali

    love.graphics.printf(
        'Ciao Pong', --testo da stampare
        0, -- posizione X iniziale
        20, -- posizione Y iniziale (utilizziamo l'altezza della finestra /2 per metterlo a metà schermo)
        VIRTUAL_WIDTH, -- Il numero dei pixel all'interno del quale il testo è centrato
        'center') --metodo di allineamento, può essere 'center', 'left' o 'right'
    
    --scrivo il punteggio a schermo
    -- setto il font come prima cosa altrimenti utilizza quello precedente
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

    -- Disegno il primo rettangolo
    love.graphics.rectangle(
        'fill', -- tipo del rettangolo, può essere 'fill' o 'line'
        10, -- posizione X iniziale
        player1Y, -- posizione Y iniziale
        5, -- larghezza
        20 -- lunghezza
    )

    -- Disegno la pallina
    love.graphics.rectangle('fill',VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    -- Disegno il secondo rettangolo
    love.graphics.rectangle(
        'fill', -- tipo del rettangolo, può essere 'fill' o 'line'
        VIRTUAL_WIDTH - 10, -- posizione X iniziale
        player2Y, -- posizione Y iniziale
        5, -- larghezza
        20 -- lunghezza
    )
    push:apply('end') 
end
