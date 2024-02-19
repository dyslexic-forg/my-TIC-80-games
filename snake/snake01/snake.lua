-- title:   snake
-- author:  danilo
-- desc:    a simple snake game
-- license: MIT License
-- version: 0.1
-- script:  lua

-- constantes
-- dimensões da tela
largura = 240
altura = 136

-- dimensões da grade
tamanhoDoQuadrado = 8
larguraDaGrade = largura // tamanhoDoQuadrado
alturaDaGrade = altura // tamanhoDoQuadrado

-- variáveis da cobra
-- direcao = "direita"
-- segmentos = {
--	{ linha = alturaDaGrade // 2, coluna = 3 },
--	{ linha = alturaDaGrade // 2, coluna = 2 },
--	{ linha = alturaDaGrade // 2, coluna = 1 },
--}
-- timerCobra = 0
tempoParaMoverCobra = 0.1
-- proximaDirecoes = {}

function reiniciaCobra()
	direcao = "direita"
	segmentos = {
		{ linha = alturaDaGrade // 2, coluna = 3 },
		{ linha = alturaDaGrade // 2, coluna = 2 },
		{ linha = alturaDaGrade // 2, coluna = 1 },
	}
	timerCobra = 0
	proximaDirecoes = {}
end

-- funções da cobra
function desenhaCobra()
	for i,s in ipairs(segmentos) do
		rect(s.coluna * tamanhoDoQuadrado, s.linha * tamanhoDoQuadrado, tamanhoDoQuadrado, tamanhoDoQuadrado, 6)
	end
end

function atualizaCobra(dt)
	timerCobra = timerCobra + dt
	if timerCobra >= tempoParaMoverCobra then
		moveCobra()
		timerCobra = 0
	end
end

function moveCobra()
	for i=#segmentos, 2,-1 do
		segmentos[i].linha = segmentos[i-1].linha
		segmentos[i].coluna = segmentos[i-1].coluna
	end
	local cabeca = segmentos[1]
	if direcao == "direita" then cabeca.coluna = cabeca.coluna + 1
	elseif direcao == "esquerda" then cabeca.coluna = cabeca.coluna - 1
	elseif direcao == "cima" then cabeca.linha = cabeca.linha - 1
	else cabeca.linha = cabeca.linha + 1
	end
	if #proximaDirecoes > 0 then
		local d = table.remove(proximaDirecoes)
		if d ~= direcaoOposta(direcao) then
			direcao = d
		end
	end
end

function cresceCobra()
	table.insert(segmentos, 2, {linha = -1, coluna = -1})
end

function colisaoComOCorpo()
	for i,s1 in ipairs(segmentos) do
		for j,s2 in ipairs(segmentos) do
			if i ~= j and s1.linha == s2.linha and s1.coluna == s2.coluna then
				return true
			end
		end
	end
	return false
end

function direcaoOposta(d)
	if d == "direita" then return "esquerda"
	elseif d == "esquerda" then return "direita"
	elseif d == "cima"then return "baixo"
	else return "cima"
	end
end

function mudaDirecaoDaCobra(d)
	table.insert(proximaDirecoes, d)
end

-- variáveis da comida
-- comida = {linha = alturaDaGrade // 2, coluna = larguraDaGrade // 2}

-- funções da comida
function reiniciaComida()
	comida = {linha = alturaDaGrade // 2, coluna = larguraDaGrade // 2}
end

function desenhaComida()
	circ(comida.coluna * tamanhoDoQuadrado + tamanhoDoQuadrado / 2, comida.linha * tamanhoDoQuadrado + tamanhoDoQuadrado / 2, tamanhoDoQuadrado // 4, 2)
end

function atualizaComida()
	comida.linha = math.random(0, alturaDaGrade-1)
	comida.coluna = math.random(0, larguraDaGrade-1)
end

-- variáveis do jogo
ehFimDeJogo = false

-- funções do jogo
function novoJogo()
	ehFimDeJogo = false
	reiniciaCobra()
	reiniciaComida()
	score = 0
end

novoJogo()

function fimDeJogo()
	ehFimDeJogo = true
end

function desenhaScore()
	print("Score: "..score, 5, 5)
end

function TIC()
	if not ehFimDeJogo then
		if btnp(0) then mudaDirecaoDaCobra("cima") end
		if btnp(1) then mudaDirecaoDaCobra("baixo") end
		if btnp(2) then mudaDirecaoDaCobra("esquerda") end
		if btnp(3) then mudaDirecaoDaCobra("direita") end

		atualizaCobra(1/60)
		-- verifica se a cobra comeu a comida
		if segmentos[1].linha == comida.linha and segmentos[1].coluna == comida.coluna then
			cresceCobra()
			atualizaComida()
			score = score + 1
		end
		-- verifica se a cobra colidiu com as bordas
		if segmentos[1].linha < 0 or segmentos[1].linha >= alturaDaGrade or segmentos[1].coluna < 0 or segmentos[1].coluna >= larguraDaGrade then
			fimDeJogo()
		end

		if colisaoComOCorpo() then fimDeJogo() end

		cls(13)
		desenhaComida()
		desenhaCobra()
		desenhaScore()
	else
		if keyp(50) then novoJogo() end

		cls(13)
		desenhaComida()
		desenhaCobra()
		desenhaScore()
		print("Fim de Jogo", 60, 30, 15, false, 2)
		print("pressione [ENTER] para jogar de novo", 20, 50, 15, false, 1)
	end
end

-- <TILES>
-- 001:eccccccccc888888caaaaaaaca888888cacccccccacc0ccccacc0ccccacc0ccc
-- 002:ccccceee8888cceeaaaa0cee888a0ceeccca0ccc0cca0c0c0cca0c0c0cca0c0c
-- 003:eccccccccc888888caaaaaaaca888888cacccccccacccccccacc0ccccacc0ccc
-- 004:ccccceee8888cceeaaaa0cee888a0ceeccca0cccccca0c0c0cca0c0c0cca0c0c
-- 017:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
-- 018:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
-- 019:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
-- 020:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
-- </TILES>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- </SFX>

-- <TRACKS>
-- 000:100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </TRACKS>

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>

