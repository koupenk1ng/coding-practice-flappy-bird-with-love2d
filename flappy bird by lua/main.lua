local backgroundImage
local birdImage
local baseImage
local baseY

--鳥に関する関数
local birdY = 200
local birdVelocity = 0
local GRAVITY = 900
local JUMP_FORCE = -300

--地面に関する変数
local baseScroll = 0
local BASE_SPEED = 120

function love.load()
    --ウィンドウサイズとタイトル
    love.window.setMode(288, 512)
    love.window.setTitle("flappy bird")

function love.keypressed(key)
    --ジャンプ
    if key == "space" then
        birdVelocity = JUMP_FORCE
    end
end

    --画像読み込み
    backgroundImage = love.graphics.newImage("flappy-bird-assets-master/sprites/background-day.png")
    birdImage = love.graphics.newImage("flappy-bird-assets-master/sprites/redbird-downflap.png")
    baseImage = love.graphics.newImage("flappy-bird-assets-master/sprites/base.png")

    --床の高さ
    baseY = 512 - baseImage:getHeight()
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
end

function love.draw()
    --背景描写
    love.graphics.draw(backgroundImage, 0, 0)
    --鳥描写
    love.graphics.draw(birdImage, 50, birdY)
    --床描写
    love.graphics.draw(baseImage, -baseScroll, baseY)
end