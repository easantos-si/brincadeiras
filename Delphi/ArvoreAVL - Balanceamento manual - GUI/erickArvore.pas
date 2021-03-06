// Titulo: Trabalho ArvoreAVL
// Extra: Balanceamento din�mico acionado por gatilho, sem limites de No's a ser balanceado
// Extra: Representa��o Grafica da estrutura da arvore acionada por gatilho
// Extra: Tratamento anticolis�o para No's em representa��o grafica  
// Data: 15/11/2010
// Autor: Erick Andrade dos Santos
// Termo: 4� A 
// Faculdade: Uniesp - Presidente Prudente

unit erickArvore;

interface

  uses Graphics, SysUtils;


  const MovX = 40;
        MovY = 40;
  type

      NO = ^rec;
    rec = record
      valor:integer;
      D:NO;
      E:NO;
    end;

    cor = TColor;
    TelaImagem = TBitmap;

    recItemPosi = record
      y:integer;
      x:integer;
    end;

    recP = record
      CE:recItemPosi;
      CD:recItemPosi;
      BE:recItemPosi;
      BD:recItemPosi;
      L:recItemPosi;
      S:recItemPosi;
    end;

    posicao = ^recC;

    recC = record
      Referencia:NO;
      Posicoes:recP;
      Prox:posicao;
      CorTinta:cor;
      Sobscrito:^string;
      SobsCarga:^string;
    end;


    memoria  = class
        Function NovoNOArvore:NO;
        Procedure CarregarArvore;
        Procedure BalancearArvore;
        Procedure GerenciarBalanceamento(var Rais:NO);
        Procedure RodarEsquerda(var Rais:NO);
        Procedure RodarDireita(var Rais:NO);
        Procedure VerificarNiveis(Rais:NO;cont:integer;var nvE,nvD:integer; var validE,validD:boolean);
        Procedure GerenciarAlocacao(var Rais:NO;NovoNO:NO);
        Procedure Inserir(NovoNO:NO);
        Function GetTotalNos:integer;
        Procedure DestruirArvore(var Rais:NO);
        Procedure Desenhar(Cordenadas:posicao; var ImagemTrabalho:TelaImagem);
        Procedure GerenciadorDeOrientacao(Rais:NO; var orientacao:posicao; y,x:Integer;tinta:cor);
        Procedure AntiSobscricao(var ordenadasAtual:posicao;ordenadaLista:posicao;cont:integer);
        Function CriarImagemDaArvore:TelaImagem;
        Procedure LimparOrientacoes(var ODescarte:posicao);
      private
        Arvore:NO; NivelE,NivelD,TotalNos:integer; OrientacaoGrafica:posicao;
      Public

      Published
        Destructor Apagar;
    end;
implementation

uses DateUtils, Math, StrUtils;

Function memoria.GetTotalNos:integer;
begin
  GetTotalNos:= TotalNos;
end;

Function memoria.NovoNOArvore:NO;
var Novo:NO;
begin
  new(Novo);
  Novo^.valor:= 0;
  Novo^.D:= nil;
  Novo^.E:= nil;
  IF Arvore = nil then
  begin
    Arvore:=Novo;
    inc(TotalNos);
  end;
  NovoNOArvore:= Novo;
end;

Procedure memoria.CarregarArvore;
begin
  IF Arvore = nil then
  begin
    OrientacaoGrafica:= nil;
  end;
  NivelE:=1;
  NivelD:=1;
end;

Procedure memoria.VerificarNiveis(Rais:NO;cont:integer;var nvE,nvD:integer; var validE,validD:boolean);
begin
  IF Rais <> nil then
    begin
      IF validE = true then
        IF ((Rais^.E <> nil) and (nvE = 1))then
          VerificarNiveis(Rais^.E,cont+1,nvE,nvD,validE,validD)
        else
          IF ((Rais^.E = nil) and (validE = true)) then
          begin
            validD:= false;
            validE:= false;
            nvE:=cont;
          end;

      if cont = 1 then
        validD:= true;

      If validD = true then
        IF ((Rais^.D <> nil) and (nvD = 1))then
          VerificarNiveis(Rais^.D,cont+1,nvE,nvD,validE,validD)
        else
          IF ((Rais^.D = nil) and (validD = true)) then
          begin
            validD:= false;
            nvD:=cont;
         end;
     end;
end;

Procedure memoria.RodarEsquerda(var Rais:NO);
var temp,realocar:NO;
begin
  temp:= Rais;
  Rais:=Rais^.D;
  realocar:= Rais;
    while realocar^.E <> nil do
      realocar:= realocar^.E;
  realocar^.E:= temp;
  temp^.D:= nil;
end;

Procedure memoria.RodarDireita(var Rais:NO);
var temp,realocar:NO;
begin
  temp:= Rais;
  Rais:=Rais^.E;
  realocar:= Rais;
    while realocar^.D <> nil do
      realocar:= realocar^.D;
  realocar^.D:= temp;
  temp^.E:= nil;
end;

Procedure memoria.GerenciarBalanceamento(var Rais:NO);
var vE,vD:Boolean;
begin
  IF Rais <> nil then
  begin
    vE:= true;
    vD:= true;
    NivelE:=1;
    NivelD:=1;
    IF Rais^.E <> nil then
      GerenciarBalanceamento(Rais^.E);
    IF Rais^.D <> nil then
      GerenciarBalanceamento(Rais^.D);
    VerificarNiveis(Rais,1,NivelE,NivelD,vE,vD);
    IF ((NivelD - NivelE) >= 2) then
      RodarEsquerda(Rais);
    IF ((NivelD - NivelE) <= -2) then
      RodarDireita(Rais);
    NivelE:=1;
    NivelD:=1;
    vE:= true;
    vD:= true;
  end;   
end;

Procedure memoria.GerenciarAlocacao(var Rais:NO;NovoNO:NO);
begin
  IF  NovoNO^.valor > Rais^.valor then
  begin
    IF Rais^.D <> nil then
      GerenciarAlocacao(Rais^.D,NovoNO)
    else
      IF Rais^.D = nil then
      begin
        Rais^.D:= NovoNO;
        inc(TotalNos);
      end;
  end
  else
    IF  NovoNO^.valor < Rais^.valor then
    begin
      IF Rais^.E <> nil then
        GerenciarAlocacao(Rais^.E,NovoNO)
      else
        IF Rais^.E = nil then
        begin
          Rais^.E:= NovoNO;
          inc(TotalNos);
        end;
   end;     
end;

Procedure memoria.BalancearArvore;
begin
  GerenciarBalanceamento(Arvore);
end;

Procedure memoria.Inserir(NovoNO:NO);
begin
  GerenciarAlocacao(Arvore,NovoNO);
end;

Procedure memoria.Desenhar(Cordenadas:posicao; var ImagemTrabalho:TelaImagem);
var i,x,y:integer; tempCor:recItemPosi; temp:string;
begin
  if Cordenadas <> nil then
  begin
    tempCor.y:= Cordenadas^.Posicoes.L.y;
  tempCor.x:= Cordenadas^.Posicoes.L.x;

  IF not(Cordenadas^.CorTinta = clBlack) then
      while not((Cordenadas^.Posicoes.S.x = tempCor.x) and (Cordenadas^.Posicoes.S.y = tempCor.y)) do
      begin
        if tempCor.x <> Cordenadas^.Posicoes.S.x then
          if tempCor.x < Cordenadas^.Posicoes.S.x then
            inc(tempCor.x)
          else
           if tempCor.x > Cordenadas^.Posicoes.S.x then
             dec(tempCor.x);

        if tempCor.y <> Cordenadas^.Posicoes.S.y then
          if tempCor.y < Cordenadas^.Posicoes.S.y then
            inc(tempCor.y)
          else
           if tempCor.y > Cordenadas^.Posicoes.S.y then
            dec(tempCor.y);

        With ImagemTrabalho.Canvas do
        begin
            Pixels[tempCor.x,tempCor.y]:= cordenadas^.CorTinta;
        end;
      end;


  if Cordenadas^.Sobscrito <> nil then
    begin
      IF Cordenadas^.CorTinta = clGreen then
      begin
        ImagemTrabalho.Canvas.Brush.Style:= bsClear;
        ImagemTrabalho.Canvas.Font.Color:= cordenadas^.CorTinta;

        if Cordenadas^.SobsCarga <> nil then
        begin
          if  Cordenadas^.SobsCarga^ = 'A' then
            begin
              y:= cordenadas^.Posicoes.CE.y - 15;
              x:= cordenadas^.Posicoes.CE.x + 5;
            end
            else
              if  Cordenadas^.SobsCarga^ = 'B' then
                begin
                  y:= cordenadas^.Posicoes.CE.y + 23;
                  x:= cordenadas^.Posicoes.CE.x + 5;
                end;
        end
        else
          begin
            y:= cordenadas^.Posicoes.CE.y + 10;
            for x:=(cordenadas^.Posicoes.CE.x - 5) to cordenadas^.Posicoes.CE.x do
              ImagemTrabalho.Canvas.Pixels[x,y]:= Cordenadas^.CorTinta;

            y:= cordenadas^.Posicoes.CE.y + 5;
            x:= cordenadas^.Posicoes.CE.x-20;
          end;

        ImagemTrabalho.Canvas.TextOut(x,y,IntToStr(Cordenadas^.Referencia^.valor));
        Cordenadas^.CorTinta:= clRed;
      end
      else
        if Cordenadas^.CorTinta = clBlue then
        begin
          ImagemTrabalho.Canvas.Brush.Style:= bsClear;
          ImagemTrabalho.Canvas.Font.Color:= cordenadas^.CorTinta;

          if Cordenadas^.SobsCarga <> nil then
        begin
          if  Cordenadas^.SobsCarga^ = 'A' then
            begin
              y:= cordenadas^.Posicoes.CE.y - 15;
              x:= cordenadas^.Posicoes.CE.x + 5;
            end
            else
              if  Cordenadas^.SobsCarga^ = 'B' then
                begin
                  y:= cordenadas^.Posicoes.CE.y + 23;
                  x:= cordenadas^.Posicoes.CE.x + 5;
                end;
        end
        else
          begin
            y:= cordenadas^.Posicoes.CE.y + 10;
            for x:=(cordenadas^.Posicoes.CE.x + 20) to cordenadas^.Posicoes.CE.x + 25  do
              ImagemTrabalho.Canvas.Pixels[x,y]:= Cordenadas^.CorTinta;

            y:= cordenadas^.Posicoes.CE.y + 5;
            x:= cordenadas^.Posicoes.CE.x + 30;
          end;

        ImagemTrabalho.Canvas.TextOut(x,y,IntToStr(Cordenadas^.Referencia^.valor));
        Cordenadas^.CorTinta:= clRed;
      end;
    end
    else
      ImagemTrabalho.Canvas.TextOut(cordenadas^.Posicoes.CE.x + 5,cordenadas^.Posicoes.CE.y + 5 ,IntToStr(Cordenadas^.Referencia^.valor));

    Desenhar(Cordenadas^.Prox, ImagemTrabalho);

    for y:= cordenadas^.Posicoes.CE.y to cordenadas^.Posicoes.BE.y do
    begin
      x:= cordenadas^.Posicoes.CE.x;
      With ImagemTrabalho.Canvas do
      begin
        Pixels[x,y]:= cordenadas^.CorTinta;
      end;
    end;

    for x:= cordenadas^.Posicoes.CE.x to cordenadas^.Posicoes.CD.x do
    begin
      y:= cordenadas^.Posicoes.CE.y;
      With ImagemTrabalho.Canvas do
      begin
        Pixels[x,y]:= cordenadas^.CorTinta;
      end;
    end;


    for y:= cordenadas^.Posicoes.CD.y to cordenadas^.Posicoes.BD.y do
    begin
      x:= cordenadas^.Posicoes.CD.x;
      With ImagemTrabalho.Canvas do
      begin
        Pixels[x,y]:= cordenadas^.CorTinta;
      end;
    end;

    for x:= cordenadas^.Posicoes.BE.x to cordenadas^.Posicoes.BD.x do
    begin
      y:= cordenadas^.Posicoes.BE.y;
      With ImagemTrabalho.Canvas do
      begin
        Pixels[x,y]:= cordenadas^.CorTinta;
      end;
    end;
   end;
end;

Procedure memoria.AntiSobscricao(var ordenadasAtual:posicao;ordenadaLista:posicao;cont:integer);
begin
  if ordenadasAtual <> nil then
  begin
    if ordenadaLista <> nil then
      if ordenadaLista^.Prox <> nil then
        AntiSobscricao(ordenadasAtual,ordenadaLista^.Prox,cont+1);
    IF ((ordenadasAtual^.Posicoes.CE.y = ordenadaLista^.Posicoes.CE.y) and (ordenadasAtual^.Posicoes.CE.x = ordenadaLista^.Posicoes.CE.x) and (ordenadasAtual^.Referencia <> ordenadaLista^.Referencia)) then
    begin
        new(ordenadasAtual^.Sobscrito);
           ordenadasAtual^.Sobscrito^:= 'B';
        new(ordenadaLista^.Sobscrito);
            ordenadaLista^.Sobscrito^:= 'A';

       IF ordenadasAtual^.CorTinta = ordenadaLista^.CorTinta then
       begin
        new(ordenadasAtual^.SobsCarga);
          ordenadasAtual^.SobsCarga^:= 'B';
        new(ordenadaLista^.SobsCarga);
          ordenadaLista^.SobsCarga^:= 'A';
       end;
    end;
    IF cont = 1 then
      AntiSobscricao(ordenadasAtual^.Prox,ordenadaLista,cont);
  end;

end;

Procedure memoria.GerenciadorDeOrientacao(Rais:NO; var orientacao:posicao; y,x:Integer;tinta:cor);
begin
    IF Rais <> nil then
    begin
    IF orientacao = nil then
      begin
        new(orientacao);
        orientacao^.Referencia:= Rais;
        orientacao^.Prox:= nil;
        orientacao^.CorTinta:= tinta;
        orientacao^.Sobscrito:= nil;
        orientacao^.SobsCarga:= nil;

        IF Rais^.E <> nil then
        begin
          GerenciadorDeOrientacao(Rais^.E,orientacao^.Prox, y + MovY, x - MovX, clBlue);
        end;
        IF Rais^.D <> nil then
        begin
          GerenciadorDeOrientacao(Rais^.D,orientacao^.Prox, y + MovY, x + MovX, clGreen);
        end;

      orientacao^.Posicoes.CE.x:= x;
      orientacao^.Posicoes.CE.y:= y;

      orientacao^.Posicoes.BE.x:= orientacao^.Posicoes.CE.x;
      orientacao^.Posicoes.BE.y:= orientacao^.Posicoes.CE.y + 20;

      orientacao^.Posicoes.CD.x:= orientacao^.Posicoes.CE.x + 20;
      orientacao^.Posicoes.CD.y:= orientacao^.Posicoes.CE.y;

      orientacao^.Posicoes.BD.x:= orientacao^.Posicoes.BE.x + 20;
      orientacao^.Posicoes.BD.y:= orientacao^.Posicoes.BE.y;

      IF tinta = clBlue then
      begin
        orientacao^.Posicoes.S.x:= orientacao^.Posicoes.CD.x + MovX;
        orientacao^.Posicoes.S.y:= orientacao^.Posicoes.CD.y - 20;
        orientacao^.Posicoes.L:= orientacao^.Posicoes.CD;
        end
      else
        IF tinta = clGreen then
          begin
            orientacao^.Posicoes.S.x:= orientacao^.Posicoes.CE.x - MovX;
            orientacao^.Posicoes.S.y:= orientacao^.Posicoes.CE.y - 20;
            orientacao^.Posicoes.L:= orientacao^.Posicoes.CE;
          end;
    end
    else
      GerenciadorDeOrientacao(Rais,orientacao^.Prox, y,x,tinta);
  end;
end;

Procedure memoria.LimparOrientacoes(var ODescarte:posicao);
begin
  if ODescarte <> nil then
  begin
     LimparOrientacoes(ODescarte^.Prox);
     ODescarte^.Referencia:= nil;
     ODescarte^.Prox:= nil;
     Dispose(ODescarte);
     ODescarte:= nil;
  end;
end;

Procedure memoria.DestruirArvore(var Rais:NO);
begin
IF Rais <> nil then
    begin
          DestruirArvore(Rais^.E);
          DestruirArvore(Rais^.D);
          FreeMem(Rais);
          Rais:= nil;
     end;
end;

Destructor memoria.Apagar;
begin
   DestruirArvore(Arvore);
   FreeMem(Arvore);
end;

Function memoria.CriarImagemDaArvore:TelaImagem;
var imagemtemp:TelaImagem;
begin
  imagemtemp:= TBitmap.Create;
  imagemtemp.Height:= 600;
  imagemtemp.Width:= 800;
  GerenciadorDeOrientacao(Arvore, OrientacaoGrafica, 20,400, clBlack);
  AntiSobscricao(OrientacaoGrafica,OrientacaoGrafica,1);
  Desenhar(OrientacaoGrafica, imagemtemp);
  LimparOrientacoes(OrientacaoGrafica);
  CriarImagemDaArvore:= imagemtemp;
end;

end.
