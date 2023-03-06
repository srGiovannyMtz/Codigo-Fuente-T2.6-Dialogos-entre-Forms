{ Angel Giovanny Martinez Soto Nc: 19940214 8AS

T2.6 Diálogos entre forms.
Realizar la práctica siguiendo los pasos del documento anexo a este documento.
Esta tarea consiste en lanzar una ventana para editar un texto, ese texto se va guardando
en un archivo, si el usuario se sale de esa ventana, hay que preguntar si desea guardar los
cambios, en el caso de que los cambios se guarden, estos se deben guardar fìsicamente en el
dispositivo, para que el archivo pueda ser cargado en el futuro. Si el usuario no hace cambios,
entonces "no es necesario mostrar el diàlogo, puesto que no hubo cambios".

Nota: debe tener cuidado de intentar abrir un archivo que no existe, si este archivo no existe
y lo intenta abrir, la app lanzará una excepción. Para evitar esto, hay que usar las funciones
de verficación correspondientes.
}

unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.DialogService, FMX.Platform;

type
  TfrmMain = class(TForm)
    lblMain: TLabel;
    btnShowFrmDatos: TButton;
    btnExit: TButton;
    procedure btnExitClick(Sender: TObject);
    procedure btnShowFrmDatosClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses
  uData;


procedure TfrmMain.btnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.btnShowFrmDatosClick(Sender: TObject);
begin
{$IFDEF MSWINDOWS OR MACOS}
  // Windows specific code here
  frmData.ShowModal;
{$ELSE}
  // Android/iOS specific code here
  frmData.Show;
{$ENDIF}
end;

end.
