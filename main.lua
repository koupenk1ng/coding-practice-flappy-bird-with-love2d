--土管に関する変数
local pipeImage
local pipes = {}
local GAP_HEIGHT = 100
local pipeTimer = 0
local PIPE_INTERVAL = 1.6

--背景に関する変数
local backgroundImage

--鳥に関する関数
local birdImage
local birdY = 200
local birdVelocity = 0
local GRAVITY = 900
local JUMP_FORCE = -300

--地面に関する変数
local baseImage
local baseY
local baseScroll = 0
local BASE_SPEED = 120

function love.load()
    --ウィンドウサイズとタイトル
    love.window.setMode(288, 512)
    love.window.setTitle("flappy bird")

    --画像読み込み
    backgroundImage = love.graphics.newImage("flappy-bird-assets-master/sprites/background-day.png")
    birdImage = love.graphics.newImage("flappy-bird-assets-master/sprites/redbird-downflap.png")
    baseImage = love.graphics.newImage("flappy-bird-assets-master/sprites/base.png")
    pipeImage = love.graphics.newImage("flappy-bird-assets-master/sprites/pipe-green.png")

    --床の高さ
    baseY = 512 - baseImage:getHeight()
end

--操作
function love.keypressed(key)
    --ジャンプ
    if key == "space" then
        birdVelocity = JUMP_FORCE
    end
end

function love.update(dt)
    --重力計算
    birdVelocity = birdVelocity + GRAVITY * dt

    --鳥に重力適応
    birdY = birdY + birdVelocity * dt

    --床の当たり判定
    local birdFloorY = baseY - birdImage:getHeight()

    if birdY > birdFloorY then
        birdY = birdFloorY
        birdVelocity = 0
    end

    --地面スクロール
    baseScroll = (baseScroll + BASE_SPEED * dt) % 48

    --土管のタイマー
    pipeTimer = pipeTimer + dt
    if pipeTimer > PIPE_INTERVAL then
        table.insert(pipes, {
            x = 288,
            y = love.math.random(50, 250)
        })
        pipeTimer = 0
    end
    --テーブル内のすべての土管を動かす
    for i = #pipes, 1, -1 do
        local p = pipes[i]
        p.x = p.x - BASE_SPEED * dt

        --画面から消えたらテーブルから削除
        if p.x < - pipeImage:getWidth() then
            table.remove(pipes, i)
        end
    end
end

function love.draw()
    --背景描写
    love.graphics.draw(backgroundImage, 0, 0)

    --鳥描写
    love.graphics.draw(birdImage, 50, birdY)

        --土管の描写
    for _, p in ipairs(pipes) do
        love.graphics.draw(pipeImage, p.x, p.y, 0, 1, -1)
        love.graphics.draw(pipeImage, p.x, p.y + GAP_HEIGHT)
    end

    --床描写
    love.graphics.draw(baseImage, -baseScroll, baseY)
end