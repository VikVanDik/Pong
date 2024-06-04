
-- Prendiamo la libreria push, serve a dare un tocco retrò al gioco dandoci delle dimensioni virtuali della finestra, la finestra avrà comunque altezza e larghezza scelte ma renderizzerà il gioco alle dimensioni virtuali.
-- Link della libreria: https://github.com/Ulydev/push
push = require 'push'


-- libreria class, utilizzata per semplificare l'utilizzo delle classi
-- link della libreria: https://github.com/vrld/hump/blob/master/class.lua
Class = require 'class'

-- richiamiamo la classe Paddle che contiene tutte le info dei Paddle
require 'Paddle'

-- facciamo la stessa cosa con la palla
require 'Ball'

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

    -- facciamo un seed del randomizer (ha bisogno di un valore per funzionare)
    -- utilizziamo il tempo attuale in secondi dal 01/01/1970
    math.randomseed(os.time())

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

    -- -- posizioni dei rettangoli, ci concentriamo sulla Y perché ci si può muovere solo in alto e in basso
    -- player1Y = 30
    -- player2Y = VIRTUAL_HEIGHT - 50

    -- quello sopra viene sosotutito da
    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10,VIRTUAL_HEIGHT - 30, 5, 20)

    -- -- inzializziamo la posizione della palla così da poterla controllare dopo
    -- ballX = VIRTUAL_HEIGHT / 2 - 2
    -- ballY = VIRTUAL_WIDTH / 2 - 2

    -- -- creo dei delta della palla in modo da farla muovere inizialmente in maniera casuale
    -- ballDY = math.random(2) == 1 and 100 or -100
    -- ballDX = math.random(-50, 50)

    -- quello sopra viene sostituito da
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    -- creo una variabile di stato del gioco, per dividere i vari momenti
    -- start è il momento in cui ancora non si gioca ed è tutto fermo
    gameState = 'start'
end

-- funzione love.pressedkey() serve a intercettare gli input degli utenti
function love.keypressed(key)
    
    if key == 'escape' then
        -- utilizzo la funzione di love che chiude l'applicazione
        love.event.quit()


    elseif key == 'enter' or key == 'return' then 
        if gameState == 'start' then
            gameState = 'play'
        else
            gamestate = 'start'

            -- -- resetto la posizione della palla
            -- ballX = VIRTUAL_HEIGHT / 2 - 2
            -- ballY = VIRTUAL_WIDTH / 2 - 2

            -- -- creo dei delta della palla in modo da darle una velocità casuale
            -- ballDY = math.random(2) == 1 and 100 or -100
            -- ballDX = math.random(-50, 50) * 1.5

            ball:reset()
        end
    end
end


function love.update(dt)
    -- movimenti player 1
    if love.keyboard.isDown('w') then
        -- aggiungiamo movimento negativo alla Y (quindi verso l'alto) moltiplicato per il delta time(per aver un movimento costante nel tempo)
        -- modifico la posizione in modo tale che non si superi lo schermo
        -- usando math.max ottengo il più grande di due valori; 0 e la Y del giocatore
        -- così non supero lo schermo
        -- player1Y = math.max(0, player1Y + -PADDLE_SPEED * dt) questo viene sostituito ora che abbiamo gli oggetti
        player1.dy = -PADDLE_SPEED

    elseif love.keyboard.isDown('s') then
        -- aggiungiamo movimento positivo x delta time
        -- faccio la stessa cosa ma con math.min
        -- player1Y = math.min(VIRTUAL_HEIGHT - 20, player1Y + PADDLE_SPEED * dt)
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    --movimenti player 2 
    if love.keyboard.isDown('up') then
        -- aggiungiamo movimento negativo alla Y (quindi verso l'alto) moltiplicato per il delta time(per aver un movimento costante nel tempo)
        -- facciamo la stessa cosa di sopra per non fare superare i bordi dello schermo
        -- player2Y = math.max(0, player2Y + -PADDLE_SPEED * dt)
        player2.dy = - PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        -- aggiungiamo movimento positivo x delta time
        -- player2Y = math.min(VIRTUAL_HEIGHT - 20, player2Y + PADDLE_SPEED * dt)
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    if gameState == 'play' then
        ball:update(dt)
    end

    player1:update(dt)
    player2:update(dt)
end

-- funzione love.draw() viene chiamata dopo l'update di LOVE2D e serve per disegnare qualcosa sullo schermo.

function love.draw()

    --aggiungiamo la libreria push per renderizzare utilizzando il filtro e la risoluzione virtuale
    -- tutto quello che c'è tra push:apply('start') e push:apply('end') verrà renderizzato e filtrato secondo la libreria
    push:apply('start')
    
    -- sposto più in alto la scritta ciao pong rispetto allo scorso commit ricordando che adesso le misure rispecchieranno quelle virtuali
    love.graphics.setFont(smallFont)

    love.graphics.printf(
        'Ciao Pong', --testo da stampare
        0, -- posizione X iniziale
        20, -- posizione Y iniziale (utilizziamo l'altezza della finestra /2 per metterlo a metà schermo)
        VIRTUAL_WIDTH, -- Il numero dei pixel all'interno del quale il testo è centrato
        'center') --metodo di allineamento, può essere 'center', 'left' o 'right'
    love.graphics.printf(
        gameState, --testo da stampare
        0, -- posizione X iniziale
        0, -- posizione Y iniziale (utilizziamo l'altezza della finestra /2 per metterlo a metà schermo)
        VIRTUAL_WIDTH, -- Il numero dei pixel all'interno del quale il testo è centrato
        'center') --metodo di allineamento, può essere 'center', 'left' o 'right'
    
    --scrivo il punteggio a schermo
    -- setto il font come prima cosa altrimenti utilizza quello precedente
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

    -- creiamo i due giocatori, utilizzando le classi adesso
    player1:render()
    player2:render()

    -- facciamo la stessa cosa con la palla
    ball:render()

    push:apply('end') 
end
