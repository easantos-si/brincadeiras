unit Erick_ArvoreAVL;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, erickArvore, ExtCtrls, Menus;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    Button2: TButton;
    B_Inserir: TButton;
    E_Entrada: TEdit;
    Label1: TLabel;
    GroupBox2: TGroupBox;
    L_TotalNos: TLabel;
    Panel2: TPanel;
    IM_visualizador: TImage;
    SaveDialog1: TSaveDialog;
    PopupMenu1: TPopupMenu;
    Salvar1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure B_InserirClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure E_EntradaKeyPress(Sender: TObject; var Key: Char);
    procedure Salvar1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1; MinhaArvore:memoria;

implementation

{$R *.dfm}


procedure TForm1.FormCreate(Sender: TObject);
begin
  MinhaArvore:= memoria.Create;
  MinhaArvore.CarregarArvore;
  L_TotalNos.Caption:= IntToStr(MinhaArvore.GetTotalNos);
  E_Entrada.Focused;
end;

procedure TForm1.B_InserirClick(Sender: TObject);
var novo:NO;
begin
  if E_Entrada.Text <>  '' then
  begin
    Novo:=nil;
    novo:= MinhaArvore.NovoNOArvore;
    novo^.valor:= StrToInt(E_Entrada.Text);
    MinhaArvore.Inserir(novo);
    Novo:=nil;
    L_TotalNos.Caption:= IntToStr(MinhaArvore.GetTotalNos);
    IM_visualizador.Picture.Bitmap:= MinhaArvore.CriarImagemDaArvore;
    form1.IM_visualizador.Refresh;
    Form1.Refresh;
    E_Entrada.Clear;
  end;
  E_Entrada.Focused;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  MinhaArvore.BalancearArvore;
  L_TotalNos.Caption:= IntToStr(MinhaArvore.GetTotalNos);
  IM_visualizador.Picture.Bitmap:= MinhaArvore.CriarImagemDaArvore;
  form1.IM_visualizador.Refresh;
  Form1.Refresh;
end;

procedure TForm1.E_EntradaKeyPress(Sender: TObject; var Key: Char);
begin
  IF Key = #13 then
  begin
    B_Inserir.Click;
  end;
end;

procedure TForm1.Salvar1Click(Sender: TObject);
begin
    SaveDialog1.Execute;
    if SaveDialog1.FileName <> '' then
    begin
      if IM_visualizador.Picture.Bitmap <> nil then
      begin
        IM_visualizador.Picture.Bitmap.Canvas.Font:= Label1.Font;
        IM_visualizador.Picture.Bitmap.Canvas.Font.Color:= clRed;
        IM_visualizador.Picture.Bitmap.Canvas.Font.Size:=8;
        IM_visualizador.Picture.Bitmap.Canvas.Font.Handle;
        IM_visualizador.Picture.Bitmap.Canvas.TextOut(5,5,'Erick - Trabalho EDII 2� Semestre Uniesp 20/11/2010');
        IM_visualizador.Picture.SaveToFile(SaveDialog1.FileName + '.bmp');
      end;
    end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MinhaArvore.Apagar;
end;

end.
